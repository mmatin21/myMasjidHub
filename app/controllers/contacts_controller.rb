class ContactsController < ApplicationController
  before_action :authenticate_masjid!
  before_action :set_contact, only: %i[show edit update destroy]

  include Pagy::Backend
  Pagy::DEFAULT[:limit] = 30

  # GET /contacts or /contacts.json
  def index
    @contacts = current_masjid.contacts
    @q = @contacts.ransack(params[:q])
    @contacts = @q.result
    @pagy, @table_contacts = pagy(@contacts)
  end

  # GET /contacts/1 or /contacts/1.json
  def show; end

  # GET /contacts/new
  def new
    @contact = Contact.new
  end

  # GET /contacts/1/edit
  def edit; end

  # POST /contacts or /contacts.json
  def create
    @contact = Contact.new(contact_params)
    @contact.masjid_id = current_masjid.id

    respond_to do |format|
      if @contact.save
        if params[:step].to_i == 2
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace('turbo-modal',
                                                      partial: 'contacts/success_pledge', locals: { pledge: Pledge.new,
                                                                                                    contact: Contact.new,
                                                                                                    contact_id: @contact.id })
          end
        elsif params[:step].to_i == 3
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace('turbo-modal',
                                                      partial: 'shared/success_donation', locals: { donation: Donation.new,
                                                                                                    contact: Contact.new,
                                                                                                    pledge: Pledge.new,
                                                                                                    contact_id: @contact.id,
                                                                                                    contact_creation: true })
          end
        end
        format.turbo_stream do
          render turbo_stream: [turbo_stream.append('contact_table', partial: 'tables/contact_row',
                                                                     locals: { item: @contact }),
                                turbo_stream.replace('flash',
                                                     partial: 'shared/alert', locals: { notice: 'Contact was successfully created.' })]
        end
        format.json { render :show, status: :created, location: @contact }
      else
        if params[:step].to_i == 2
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace('turbo-modal',
                                                      partial: 'contacts/success_pledge', locals: { pledge: Pledge.new,
                                                                                                    contact: Contact.new,
                                                                                                    contact_id: 'nil' })
          end
        elsif params[:step].to_i == 3
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace('turbo-modal',
                                                      partial: 'shared/success_donation', locals: { donation: Donation.new,
                                                                                                    contact: Contact.new,
                                                                                                    pledge: Pledge.new,
                                                                                                    contact_id: @contact.id,
                                                                                                    contact_creation: true })
          end
        else
          format.html { render :new, status: :unprocessable_entity }
        end
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1 or /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to contact_url(@contact), notice: 'Contact was successfully updated.' }
        format.turbo_stream do
          render turbo_stream: [turbo_stream.replace("contact_#{@contact.id}", partial: 'tables/contact_row',
                                                                               locals: { item: @contact }),
                                turbo_stream.replace("show_#{@contact.id}", partial: 'contacts/contact',
                                                                            locals: { contact: @contact }),
                                turbo_stream.replace('flash',
                                                     partial: 'shared/alert', locals: { notice: 'Contact was successfully edited.' })]
        end
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1 or /contacts/1.json
  def destroy
    if @contact.destroy

      respond_to do |format|
        format.html { redirect_to contacts_url, notice: 'contact was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('flash',
                                                    partial: 'shared/error', locals:
                                                     { notice: 'Error: Please remove the linked pledges/donations.' })
        end
      end
    end
  end

  def export_csv
    @contacts = Contact.where(masjid_id: current_masjid.id)

    respond_to do |format|
      format.csv { send_data @contacts.to_csv, filename: "contacts_#{Date.today}.csv" }
    end
  end

  def import_csv
    if params[:file].present?
      masjid_id = current_masjid.id # Get the masjid_id for the current user
      Contact.import(params[:file], masjid_id)
      redirect_to contacts_path, notice: 'Records imported successfully.'
    else
      redirect_to contacts_path, alert: 'Please upload a valid CSV file.'
    end
    Rails.logger.warn 'No file uploaded'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contact
    @contact = Contact.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def contact_params
    params.require(:contact).permit(:masjid_id, :first_name, :middle_name, :last_name, :email, :phone_number)
  end
end
