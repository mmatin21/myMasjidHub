class BulkDeletesController < ApplicationController
  include Pagy::Backend
  before_action :authenticate_masjid!
  def expenses_and_revenues
    # Properly capitalize and singularize the model name
    return unless params[:model_type].present?

    klass = params[:model_type].classify.constantize
    Rails.logger.debug "!!!!!! BULK DELETE EXPENSE OR REVENUE: #{params[:ids]}"
    items = klass.where(id: params[:ids].split(','))
    items.destroy_all

    @q = klass.where(masjid_id: current_masjid.id).ransack(params[:q])
    @records = @q.result
    @pagy, @table_records = pagy(@records)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('results',
                              partial: 'tables/table',
                              locals: {
                                model: klass,
                                table: @table_records,
                                query: @q,
                                pagy: @pagy
                              }),
          turbo_stream.replace('flash',
                               partial: 'shared/alert', locals: { notice: 'Items were successfully destroyed.' })

        ]
      end
    end
  end

  def pledges
    return unless params[:model_type].present?

    klass = params[:model_type].classify.constantize
    Rails.logger.debug "ids: #{params[:ids]}"
    items = klass.where(id: params[:ids].split(','))
    items.destroy_all

    @q = klass.where(masjid_id: current_masjid.id).ransack(params[:q])
    @records = @q.result.includes(:contact)
    @pagy, @table_records = pagy(@records)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('results',
                              partial: 'tables/pledge_table',
                              locals: {
                                model: klass,
                                table: @table_records,
                                query: @q,
                                pagy: @pagy
                              }),
          turbo_stream.replace('flash',
                               partial: 'shared/alert', locals: { notice: 'Pledges were successfully destroyed.' })
        ]
      end
    end
  end

  def contacts
    return unless params[:model_type].present?

    klass = params[:model_type].classify.constantize
    Rails.logger.debug "ids: #{params[:ids]}"
    items = klass.where(id: params[:ids].split(','))
    items.destroy_all

    Rails.logger.debug "items count #{items.count}"
    alert_type = 'alert'
    notice = 'Contacts were successfully destroyed.'

    if items.count > 0
      alert_type = 'error'
      notice = 'Error deleting some or all contacts.'
    end

    @q = klass.where(masjid_id: current_masjid.id).ransack(params[:q])
    @records = @q.result
    @pagy, @table_records = pagy(@records)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('results',
                              partial: 'tables/contact_table',
                              locals: {
                                model: klass,
                                table: @table_records,
                                query: @q,
                                pagy: @pagy
                              }),
          turbo_stream.replace('flash',
                               partial: "shared/#{alert_type}", locals: { notice: notice })
        ]
      end
    end
  end

  def donations
    return unless params[:model_type].present?

    klass = params[:model_type].classify.constantize
    Rails.logger.debug "ids: #{params[:ids]}"
    items = klass.where(id: params[:ids].split(','))
    items.destroy_all

    @q = klass.where(masjid_id: current_masjid.id).ransack(params[:q])
    @records = @q.result
    @pagy, @table_records = pagy(@records)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update('results',
                              partial: 'tables/donation_table',
                              locals: {
                                model: klass,
                                table: @table_records,
                                query: @q,
                                pagy: @pagy
                              }),
          turbo_stream.replace('flash',
                               partial: 'shared/alert', locals: { notice: 'Donations were successfully destroyed.' })
        ]
      end
    end
  end
end
