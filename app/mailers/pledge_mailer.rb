class PledgeMailer < ApplicationMailer
  def confirmation_email(pledge)
    @pledge = pledge
    @contact = pledge.contact
    @fundraiser = pledge.fundraiser
    @masjid = pledge.masjid

    @return_url = "#{ENV['FRONTEND_URL']}/masjids/#{@masjid.slug}/fundraisers/#{@fundraiser.slug}/donations/new?pledge_id=#{@pledge.id}"

    mail(
      to: @contact.email,
      subject: "Your Pledge Confirmation for #{@fundraiser.name}"
    )
  end
end
