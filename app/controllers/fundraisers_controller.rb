class FundraisersController < ApplicationController
  before_action :authenticate_masjid!
  before_action :set_fundraiser, only: %i[show edit update destroy]
  include Pagy::Backend
  Pagy::DEFAULT[:limit] = 30

  # GET /fundraisers or /fundraisers.json
  def index
    @fundraisers = current_masjid.fundraisers
  end

  # GET /fundraisers/1 or /fundraisers/1.json
  def show
    @donations = Donation.where(fundraiser_id: @fundraiser.id).order(created_at: :desc).limit(8)

    @q = @donations.ransack(params[:q])
    @pagy, @table_donations = pagy(@donations)
  end

  # GET /fundraisers/new
  def new
    @fundraiser = Fundraiser.new
  end

  # GET /fundraisers/1/edit
  def edit; end

  # POST /fundraisers or /fundraisers.json
  def create
    @fundraiser = Fundraiser.new(fundraiser_params)
    @fundraiser.masjid_id = current_masjid.id

    respond_to do |format|
      if @fundraiser.save
        format.html { redirect_to fundraiser_url(@fundraiser), notice: 'Fundraiser was successfully created.' }
        format.turbo_stream do
          render turbo_stream: [turbo_stream.prepend('fundraisers', partial: 'fundraisers/fundraiser',
                                                                    locals: { fundraiser: @fundraiser }),
                                turbo_stream.replace('flash',
                                                     partial: 'shared/alert', locals: { notice: 'Fundraiser was successfully created.' })]
        end
        format.json { render :show, status: :created, location: @fundraiser }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @fundraiser.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fundraisers/1 or /fundraisers/1.json
  def update
    respond_to do |format|
      if @fundraiser.update(fundraiser_params)
        format.turbo_stream do
          render turbo_stream: [turbo_stream.replace("detail_#{@fundraiser.id}", partial: 'fundraisers/detail',
                                                                                 locals: { fundraiser: @fundraiser }),
                                turbo_stream.replace('flash',
                                                     partial: 'shared/alert', locals: { notice: 'Fundraiser was successfully edited.' })]
        end
        format.html { redirect_to fundraiser_url(@fundraiser), notice: 'Fundraiser was successfully updated.' }
        format.json { render :show, status: :ok, location: @fundraiser }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @fundraiser.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fundraisers/1 or /fundraisers/1.json
  def destroy
    if @fundraiser.destroy

      respond_to do |format|
        format.html { redirect_to fundraisers_url, notice: 'Fundraiser was successfully destroyed.' }
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_fundraiser
    @fundraiser = Fundraiser.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def fundraiser_params
    params.require(:fundraiser).permit(:name, :description, :goal_amount, :masjid_id, :end_date)
  end
end
