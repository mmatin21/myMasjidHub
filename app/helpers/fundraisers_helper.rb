module FundraisersHelper
  def qr_code_url(fundraiser)
    rails_blob_url(fundraiser.qr_code, disposition: 'inline') if fundraiser.qr_code.attached?
  end
end
