def self.notify_masjid(pledge)
  # Send a notification to the masjid about the new pledge
  fundraiser = pledge.fundraiser
  contact = pledge.contact

  Notification.create!(
    masjid_id: fundraiser.masjid_id,
    message: "#{contact.first_name} #{contact.last_name} has pledged $#{'%.2f' % pledge.amount} to the '#{fundraiser.name}' fundraiser."
    # No donation_id since this is a pledge
  )
end
