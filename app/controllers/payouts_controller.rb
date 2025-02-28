class PayoutsController < ApplicationController
  before_action :authenticate_masjid!
  before_action :set_masjid

  def new
    # Fetch available balance for the connected account

    balance = Stripe::Balance.retrieve({}, { stripe_account: @masjid.stripe_account_id })
    withdrawal_balance = balance['pending'].first['amount'] / 100
    @available_balance = balance['available'].first['amount'] / 100.0 # Convert cents to dollars
    @available_balance += withdrawal_balance if withdrawal_balance.negative?
  rescue Stripe::StripeError => e
    flash[:alert] = "Error retrieving balance: #{e.message}"
    @available_balance = 0.0
  end

  def create
    amount = params[:amount].to_f * 100 # Convert dollars to cents

    begin
      # Create a payout
      Stripe::Payout.create(
        {
          amount: amount.to_i,
          currency: 'usd'
        },
        { stripe_account: @masjid.stripe_account_id }
      )

      flash[:notice] = "Payout of $#{params[:amount]} created successfully!"
      redirect_to masjid_path(@masjid)
    rescue Stripe::StripeError => e
      Rails.logger.debug "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Payout Failed #{e.message}!!!!!!!!!!!!!!!!!!!!!!!!"
      flash[:notice] = "Payout failed: #{e.message}"
      redirect_to new_masjid_payout_path(@masjid)
    end
  end

  private

  def set_masjid
    @masjid = Masjid.find_by(id: current_masjid.id)
  end
end
