class MasjidsController < ApplicationController
  before_action :set_masjid, only: %i[ show edit update destroy ]

  # GET /masjids/1 or /masjids/1.json
  def show
    # Retrieve balance from Stripe
    unless @masjid.stripe_account_id.nil?
      begin
        Rails.logger.debug "!!!!!!!!!!!!!!!!Stripe Masjid Inspection #{@masjid.stripe_account_id}!!!!!!!!!!!" 

        balance = Stripe::Balance.retrieve({}, {stripe_account: @masjid.stripe_account_id})
        Rails.logger.debug "!!!!!!!!!!!!!!!!Stripe Balance Inspection #{balance.inspect}!!!!!!!!!!!!!!!!!!!!!"

        if balance['available'].any?
          withdrawal_balance = balance['pending'].first['amount'] / 100
          @available_balance = balance['available'].first['amount'] / 100.0 # Convert cents to dollars
          if withdrawal_balance < 0
            @available_balance = @available_balance + withdrawal_balance
          end
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
        Rails.logger.debug "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Error #{e.message}!!!!!!!!!!!!!!!!!!!!!!!!" 
        flash[:alert] = "Error retrieving balance: #{e.message}"
        @available_balance = 0.0
        @pending_balance = 0.0
      end
      if onboarding_incomplete?(@masjid)
        @stripe_onboarding_link = generate_stripe_onboarding_link(@masjid)
      end
    else
      @available_balance = 0.0
      @pending_balance = 0.0
    end
    Rails.logger.debug "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Available balance #{@available_balance}!!!!!!!!!!!!!!!!!!!!!!!!" 
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

  def open_stripe_dashboard
    @masjid = current_masjid
    begin
      login_link = Stripe::Account.create_login_link(@masjid.stripe_account_id)
      redirect_to login_link.url, allow_other_host: true
    rescue Stripe::StripeError => e
      flash[:alert] = "Error opening Stripe Dashboard: #{e.message}"
      redirect_to masjid_path(@masjid)
    end
  end

  def connect_stripe
    masjid = Masjid.find(current_masjid.id)
  
    # Ensure the masjid has a Stripe account
    stripe_account_id = masjid.stripe_account_id || create_stripe_account(masjid)
  
    # Generate fully qualified URLs
    refresh_url = url_for(action: :connect_stripe, masjid_id: masjid.id, host: request.host_with_port)
    return_url = masjid_url(masjid, host: request.host_with_port)
  
    # Production flow: Redirect to onboarding
    account_link = Stripe::AccountLink.create({
      account: stripe_account_id,
      refresh_url: refresh_url,
      return_url: return_url,
      type: 'account_onboarding'
    })
  
    redirect_to account_link.url, allow_other_host: true
  end

  private
  
  def create_stripe_account(masjid)
    account = Stripe::Account.create({
      type: 'express',
      country: 'US',
      email: masjid.email,
      business_type: 'non_profit'
    })
    masjid.update!(stripe_account_id: account.id)
    account.id
  end

  def onboarding_incomplete?(masjid)
    stripe_account = Stripe::Account.retrieve(masjid.stripe_account_id)
    Rails.logger.debug "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Onboarding: #{stripe_account.inspect}!!!!!!!!!!!!!!!!!!!!!!!!" 
    stripe_account.requirements.currently_due.any?
  rescue Stripe::StripeError => e
    flash[:alert] = "Error checking onboarding status: #{e.message}"
    false
  end

  def generate_stripe_onboarding_link(masjid)
    url = masjid_url(masjid, host: request.host_with_port)
  
    Stripe::AccountLink.create(
      account: masjid.stripe_account_id,
      refresh_url: url,
      return_url: url,
      type: 'account_onboarding'
    ).url
  rescue Stripe::StripeError => e
    flash[:alert] = "Error generating Stripe onboarding link: #{e.message}"
    nil
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
