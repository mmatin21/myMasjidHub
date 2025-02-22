class DonationConfirmationMailer < ApplicationMailer
  default from: 'noreply@mymasjidhub.com'

  def donation_confirmation(donation, amount)
    @donation = donation
    @amount = amount
    mail(to: @donation.contact.email, subject: 'Donation Confirmation')
  end

  def installment_donation_confirmation(donation, amount)
    @donation = donation
    @amount = amount
    mail(to: @donation.contact.email, subject: 'Installment Donation Confirmation')
  end

  def recurring_donation_confirmation(donation, amount)
    @donation = donation
    @amount = amount
    mail(to: @donation.contact.email, subject: 'Recurring Donation Confirmation')
  end
end
