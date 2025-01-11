class BulkDeletesController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_masjid!
  def expenses_and_revenues
    # Properly capitalize and singularize the model name
    klass = params[:model_type].classify.constantize
    Rails.logger.debug "ids: #{params[:ids]}"
    items = klass.where(id: params[:ids].split(','))
    items.destroy_all
    
    @q = klass.where(masjid_id: current_masjid.id).ransack(params[:q])
    @records = @q.result
    @pagy, @table_records = pagy(@records)
    
    respond_to do |format|
      format.turbo_stream { 
        render turbo_stream: [
          turbo_stream.update("results", 
            partial: "tables/table",
            locals: { 
              model: klass,
              table: @table_records,
              query: @q,
              pagy: @pagy
            }
          )
        ]
      }
    end
  end

  def pledges
    klass = params[:model_type].classify.constantize
    Rails.logger.debug "ids: #{params[:ids]}"
    items = klass.where(id: params[:ids].split(','))
    items.destroy_all

    @q = klass.where(masjid_id: current_masjid.id).ransack(params[:q])
    @records = @q.result.includes(:contact)
    @pagy, @table_records = pagy(@records)

    respond_to do |format|
      format.turbo_stream { 
        render turbo_stream: [
          turbo_stream.update("results", 
            partial: "tables/pledge_table",
            locals: { 
              model: klass,
              table: @table_records,
              query: @q,
              pagy: @pagy
            }
          )
        ]
      }
    end
  end

  def contacts
    klass = params[:model_type].classify.constantize
    Rails.logger.debug "ids: #{params[:ids]}"
    items = klass.where(id: params[:ids].split(','))
    items.destroy_all

    @q = klass.where(masjid_id: current_masjid.id).ransack(params[:q])
    @records = @q.result
    @pagy, @table_records = pagy(@records)

    respond_to do |format|
      format.turbo_stream { 
        render turbo_stream: [
          turbo_stream.update("results", 
            partial: "tables/contact_table",
            locals: { 
              model: klass,
              table: @table_records,
              query: @q,
              pagy: @pagy
            }
          )
        ]
      }
    end
  end

  def donations
    klass = params[:model_type].classify.constantize
    Rails.logger.debug "ids: #{params[:ids]}"
    items = klass.where(id: params[:ids].split(','))
    items.destroy_all

    @q = klass.where(masjid_id: current_masjid.id).ransack(params[:q])
    @records = @q.result
    @pagy, @table_records = pagy(@records)

    respond_to do |format|
      format.turbo_stream { 
        render turbo_stream: [
          turbo_stream.update("results", 
            partial: "tables/donation_table",
            locals: { 
              model: klass,
              table: @table_records,
              query: @q,
              pagy: @pagy
            }
          )
        ]
      }
    end
  end
end
