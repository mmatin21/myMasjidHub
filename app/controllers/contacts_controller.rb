class ContactsController < ApplicationController
  before_action :set_contact, only: %i[ show edit update destroy ]
  include Pagy::Backend
  Pagy::DEFAULT[:limit] = 30
  
  # GET /contacts or /contacts.json
  def index
    @contacts = Contact.where(masjid_id: current_masjid.id)
    @q = @contacts.ransack(params[:q])
    @contacts = @q.result
    @pagy, @table_contacts = pagy(@contacts)
  end

  # GET /contacts/1 or /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts or /contacts.json
  def create
    @contact = Contact.new(contact_params)
    @contact.masjid_id = current_masjid.id

    
    respond_to do |format|
      if @contact.save
        if params[:step].to_i == 2 
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("turbo-modal", 
              partial: "contacts/success_pledge", locals: { pledge: Pledge.new, contact: Contact.new, contact_id: @contact.id}
            )
          end
        elsif params[:step].to_i == 3
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("turbo-modal", 
              partial: "contacts/success_donation", locals: { donation: Donation.new, contact: Contact.new, pledge: Pledge.new, contact_id: @contact.id}
            )
          end
        end
        format.turbo_stream do
          render turbo_stream: turbo_stream.append("contact_table", partial: "tables/contact_row", locals: { item: @contact }) 
        end 
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1 or /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to contact_url(@contact), notice: "Contact was successfully updated." }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1 or /contacts/1.json
  def destroy
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to contacts_url, notice: "Contact was successfully destroyed." }
      format.json { head :no_content }
    end
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
