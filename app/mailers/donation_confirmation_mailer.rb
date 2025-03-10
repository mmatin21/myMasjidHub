class DonationConfirmationMailer < ApplicationMailer
  default from: 'noreply@masjidhub.com'

  def donation_confirmation(donation, amount)
    @donation = donation
    @amount = amount
    mail(to: @donation.contact.email, subject: 'Donation Confirmation')
  end
end
