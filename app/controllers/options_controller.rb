class OptionsController < ApplicationController
  def pledges
    contact_id = params[:contact_id]
    fundraiser_id = params[:fundraiser_id]
    
    # Filter pledges based on the selected contact and fundraiser
    @pledges = Pledge.where(contact_id: contact_id, fundraiser_id: fundraiser_id)

    @pledges.each do |pledge|
      Rails.logger.debug "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Pledges Name: #{pledge.name}!!!!!!!!!!!!!!!!!!!!!!!!" 
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          params[:target],
          partial: "donations/select",
          locals: { pledges: @pledges }
        )
      end
    end
  end
end
