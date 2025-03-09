class PledgeNotifier
  def self.notify_masjid(pledge)
    # Send a notification to the masjid about the new pledge
    fundraiser = pledge.fundraiser
    contact = pledge.contact
    masjid = fundraiser.masjid

    masjid.notifications.create(
      title: 'New Pledge Received',
      content: "#{contact.first_name} #{contact.last_name} has pledged $#{format('%.2f',
                                                                                 pledge.amount)} to the '#{fundraiser.name}' fundraiser.",
      notification_type: 'pledge',
      metadata: {
        pledge_id: pledge.id,
        fundraiser_id: fundraiser.id,
        contact_id: contact.id,
        amount: pledge.amount
      }
    )

    # Broadcast notification to masjid admins if using ActionCable
    # NotificationChannel.broadcast_to(masjid, notification)
  end
end
