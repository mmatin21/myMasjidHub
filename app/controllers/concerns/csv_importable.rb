module CsvImportable
  extend ActiveSupport::Concern

  def import_csv
    if params[:file].present?
      masjid_id = current_masjid.id
      model_class.import(params[:file], masjid_id)
      redirect_to url_for(controller: controller_name, action: :index), notice: 'Records imported successfully.'
    else
      redirect_to url_for(controller: controller_name, action: :index), alert: 'Please upload a valid CSV file.'
    end
  end

  private

  def model_class
    controller_name.classify.constantize
  end
end
