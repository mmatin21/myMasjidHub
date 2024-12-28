class MasjidsController < ApplicationController
  before_action :set_masjid, only: %i[ show edit update destroy ]

  # GET /masjids/1 or /masjids/1.json
  def show
        # Retrieve balance from Stripe
        begin
          balance = Stripe::Balance.retrieve(stripe_account: @masjid.stripe_account_id)
          if balance['available'].any?
            @available_balance = balance['available'].first['amount'] / 100.0 # Convert cents to dollars
          else
            @available_balance = 0.0
            flash[:alert] = "No available balance yet. Funds might still be pending."
          end

          if balance['pending'].any?
            @pending_balance = balance['pending'].first['amount'] / 100.0 # Convert cents to dollars
          else
            @pending_balance = 0.0
            flash[:alert] = "No pending balance yet. Funds might still be pending."
          end
        rescue Stripe::StripeError => e
          flash[:alert] = "Error retrieving balance: #{e.message}"
          @available_balance = 0.0
          @pending_balance = 0.0
        end
      

    
  end

  # GET /masjids/new
  def new
    @masjid = Masjid.new
  end

  # GET /masjids/1/edit
  def edit
  end

  # POST /masjids or /masjids.json
  def create
    @masjid = Masjid.new(masjid_params)

    respond_to do |format|
      if @masjid.save
        format.html { redirect_to masjid_url(@masjid), notice: "Masjid was successfully created." }
        format.json { render :show, status: :created, location: @masjid }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @masjid.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /masjids/1 or /masjids/1.json
  def update
    respond_to do |format|
      if @masjid.update(masjid_params)
        format.html { redirect_to masjid_url(@masjid), notice: "Masjid was successfully updated." }
        format.json { render :show, status: :ok, location: @masjid }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @masjid.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /masjids/1 or /masjids/1.json
  def destroy
    @masjid.destroy

    respond_to do |format|
      format.html { redirect_to masjids_url, notice: "Masjid was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  

  def connect_stripe
    masjid = Masjid.find(current_masjid.id)

    if Rails.env.test? || Rails.env.development?
      # Create a test Stripe account programmatically
      account = Stripe::Account.create({
        type: 'express',
        country: 'US',
        email: masjid.email,
        capabilities: {
          transfers: 'active',
        },
      })
      masjid.update!(stripe_account_id: account.id)
      flash[:notice] = "Test Stripe account connected successfully!"
      redirect_to masjid_path(masjid)
    else
      # Production flow: Redirect to onboarding
      account_link = Stripe::AccountLink.create({
        account: masjid.stripe_account_id || create_stripe_account(masjid),
        refresh_url: connect_stripe_masjid_url(masjid),
        return_url: masjid_dashboard_url(masjid),
        type: 'account_onboarding'
      })
      redirect_to account_link.url, allow_other_host: true
    end
  end 

  private

    def create_stripe_account(masjid)
      account = Stripe::Account.create({
        type: 'express',
        country: 'US',
        email: masjid.email,
        business_type: 'non_profit',
      })
      masjid.update!(stripe_account_id: account.id)
      account.id
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_masjid
      @masjid = Masjid.find_by(id: current_masjid.id)
    end

    # Only allow a list of trusted parameters through.
    def masjid_params
      params.require(:masjid).permit(:name, :address, :city, :state, :zipcode, :phone_number)
    end
end
