class DonationConfirmationMailer < ApplicationMailer
  default from: 'noreply@masjidhub.com'

  def donation_confirmation(donation)
    @donation = donation
    mail(to: @donation.contact.email, subject: 'Donation Confirmation')
  end
end
