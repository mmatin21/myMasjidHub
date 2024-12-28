class PayoutsController < ApplicationController
  before_action :set_masjid

  def new
    # Fetch available balance for the connected account
    begin
      balance = Stripe::Balance.retrieve(stripe_account: @masjid.stripe_account_id)
      @available_balance = balance['available'].first['amount'] / 100.0 # Convert cents to dollars
    rescue Stripe::StripeError => e
      flash[:alert] = "Error retrieving balance: #{e.message}"
      @available_balance = 0.0
    end
  end

  def create
    amount = params[:amount].to_f * 100 # Convert dollars to cents

    begin
      # Create a payout
      payout = Stripe::Payout.create(
        {
          amount: amount.to_i,
          currency: 'usd',
        },
        { stripe_account: @masjid.stripe_account_id }
      )

      flash[:notice] = "Payout of $#{params[:amount]} created successfully!"
      redirect_to masjid_path(@masjid)
    rescue Stripe::StripeError => e
      flash[:alert] = "Payout failed: #{e.message}"
      redirect_to new_masjid_payout_path(@masjid)
    end
  end

  private

  def set_masjid
    @masjid = Masjid.find(params[:masjid_id])
  end
end
