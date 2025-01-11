class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def stripe
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    endpoint_secret = ENV['STRIPE_WEBHOOK_SECRET'] || Rails.application.credentials.dig(:stripe, :webhook_key)

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
    Rails.logger.info "Payment intent paid: #{payment_intent['id']}"
  end 
end
