class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def stripe
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = if Rails.env.development?
                        Rails.application.credentials.dig(:stripe, :webhook_key)
                      else
                        Rails.application.credentials.dig(:stripe, :webhook_qa_key)
                      end

    unless endpoint_secret.is_a?(String) && endpoint_secret.present?
      Rails.logger.error "Invalid webhook secret: #{endpoint_secret.inspect}"
      render json: { error: 'Webhook secret is not configured correctly' }, status: 500 and return
    end

    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError
      render json: { error: 'Invalid payload' }, status: 400 and return
    rescue Stripe::SignatureVerificationError
      render json: { error: 'Invalid signature' }, status: 400 and return
    end

    # Process the webhook event
    case event['type']
    when 'account.updated'
      handle_account_updated(event['data']['object'])
    when 'payout.created'
      handle_payout_created(event['data']['object'])
    when 'payout.paid'
      handle_payout_paid(event['data']['object'])
    when 'payout.updated'
      handle_payout_updated(event['data']['object'])
    when 'payment_intent.succeeded'
      handle_payment_paid(event['data']['object'])
    when 'invoice.paid'
      handle_invoice_paid(event['data']['object'])
    else
      Rails.logger.info "Unhandled event type: #{event['type']}"
    end

    render json: { message: 'success' }, status: 200
  end

  private

  def handle_account_updated(account)
    masjid = Masjid.find_by(stripe_account_id: account['id'])
    if masjid
      masjid.update(
        charges_enabled: account['charges_enabled'],
        payouts_enabled: account['payouts_enabled']
      )
      Rails.logger.info "Updated Masjid ##{masjid.id} with onboarding status"
    else
      Rails.logger.warn "Masjid with Stripe account ID #{account['id']} not found"
    end
  end

  def handle_payout_created(payout)
    Rails.logger.info "Payout created: #{payout['id']} for amount #{payout['amount']}"
  end

  def handle_payout_paid(payout)
    Rails.logger.info "Payout paid: #{payout['id']} for amount #{payout['amount']}"
  end

  def handle_payout_updated(payout)
    Rails.logger.info "Payout updated: #{payout['id']}"
  end

  def handle_payment_paid(payment_intent)
    metadata = payment_intent['metadata']

    masjid_id = metadata['masjid_id']

    contact = Contact.find_by(email: metadata['contact_email'], masjid_id: masjid_id) ||
              Contact.new(email: metadata['contact_email'], masjid_id: masjid_id)
    if contact.new_record?
      contact.first_name = metadata['contact_first_name']
      contact.last_name = metadata['contact_last_name']
      contact.masjid_id = masjid_id

      return { donation: nil, errors: contact.errors.full_messages } unless contact.save
    end
    amount = payment_intent['amount'].to_f / 100.0
    fee = payment_intent['application_fee_amount'].to_f / 100.0
    amount_after_fee = (amount - fee).round(2)
    payment_method = metadata['payment_method'] == 'us_bank_account' ? 'Bank Transfer' : 'Card'
    donation = Donation.new(
      amount: amount_after_fee,
      fundraiser_id: metadata['fundraiser_id'],
      masjid_id: masjid_id,
      contact_id: contact.id,
      payment_method: payment_method,
      donation_type: 'One Time',
      mymasjidhub_donation: true
    )
    donation.save!
    DonationConfirmationMailer.donation_confirmation(donation, amount).deliver_now

    Notification.create!(
      masjid_id: masjid_id,
      message: "A new donation of $#{'%.2f' % amount_after_fee} has been made to your fundraiser #{donation.fundraiser.name} by #{donation.contact.name}!",
      donation_id: donation.id
    )
  end

  def handle_invoice_paid(invoice)
    Rails.logger.debug "Invoice: #{invoice.inspect}"
    metadata = invoice['subscription_details']['metadata']
    masjid_id = metadata['masjid_id']

    contact = Contact.find_by(email: metadata['contact_email'], masjid_id: masjid_id) ||
              Contact.new(email: metadata['contact_email'], masjid_id: masjid_id)
    if contact.new_record?
      contact.first_name = metadata['contact_first_name']
      contact.last_name = metadata['contact_last_name']
      contact.masjid_id = masjid_id

      return { donation: nil, errors: contact.errors.full_messages } unless contact.save
    end

    contact.stripe_customer_id = invoice['customer'] if contact.stripe_customer_id.nil?
    contact.save

    amount = invoice['amount_paid'].to_f / 100.0
    fee = invoice['application_fee_amount'].to_f / 100
    amount_after_fee = (amount - fee).round(2)

    Rails.logger.debug "amount after fee #{amount_after_fee}"

    donation_type = metadata['total_installments'].present? ? 'Installment' : 'Recurring'
    payment_method = metadata['payment_method'] == 'us_bank_account' ? 'Bank Transfer' : 'Card'

    donation = Donation.new(
      amount: amount_after_fee,
      fundraiser_id: metadata['fundraiser_id'],
      masjid_id: masjid_id,
      contact_id: contact.id,
      payment_method: payment_method,
      donation_type: donation_type,
      mymasjidhub_donation: true
    )
    donation.save!
    if metadata['total_installments'].present?
      DonationConfirmationMailer.installment_donation_confirmation(donation, amount).deliver_now
    else
      DonationConfirmationMailer.recurring_donation_confirmation(donation, amount).deliver_now
    end

    Notification.create!(
      masjid_id: masjid_id,
      message: "A new donation of $#{'%.2f' % amount_after_fee} has been made to your fundraiser
                #{donation.fundraiser.name} by #{donation.contact.name}!",
      donation_id: donation.id
    )
  end
end
