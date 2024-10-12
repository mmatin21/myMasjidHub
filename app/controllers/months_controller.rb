class MonthsController < ApplicationController
  def months
    
    @target = params[:target]
   
    if URI(request.referer).path == '/revenues'
      model_months = Revenue.where(masjid_id: current_masjid.id)
    elsif URI(request.referer).path == '/expenses'
      model_months = Expense.where(masjid_id: current_masjid.id)
    else
      model_months = Balance.where(masjid_id: current_masjid.id)
    end
    
    @months = model_months.where('extract(year from date) = ?', params[:year].to_i)
                                 .select("DISTINCT extract(month from date) AS month")
                                 .map { |e| e.month.to_i }

    @months = @months.map { |m| [Date::MONTHNAMES[m], m] }
    @months = @months.prepend("All Months")

    @months.each do |month|
      Rails.logger.debug "Month Name: #{month}" 
    end
     Rails.logger.debug "Finding which model: #{URI(request.referer).path}"
    respond_to do |format|
      format.turbo_stream
    end
  end
end
