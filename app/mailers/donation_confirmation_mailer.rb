class DonationConfirmationMailer < ApplicationMailer
  default from: 'noreply@mymasjidhub.com'

  def donation_confirmation(donation, amount)
    @donation = donation
    @amount = amount
    mail(to: @donation.contact.email, subject: 'Donation Confirmation')
  end

  def donation_installment_confirmation(donation, amount)
    @donation = donation
    @amount = amount
    mail(to: @donation.contact.email, subject: 'Donation Installment Confirmation')
  end
end
