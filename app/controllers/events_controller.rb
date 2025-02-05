class EventsController < ApplicationController
  before_action :authenticate_masjid!
  before_action :set_event, only: %i[show edit update destroy]

  # GET /events or /events.json
  def index
    @events = current_masjid.events.order(event_date: 'asc')
  end

  # GET /events/1 or /events/1.json
  def show; end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit; end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)
    @event.masjid_id = current_masjid.id

    respond_to do |format|
      if @event.save
        format.html { redirect_to event_url(@event), notice: 'Event was successfully created.' }
        format.turbo_stream do
          render turbo_stream: [turbo_stream.prepend('events', partial: 'events/event', locals: { event: @event }),
                                turbo_stream.replace('flash', partial: 'shared/alert',
                                                              locals: { notice: 'Fundraiser was successfully created.' })]
        end
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.turbo_stream do
          render turbo_stream: [turbo_stream.replace("detail_#{@event.id}", partial: 'events/detail',
                                                                            locals: { event: @event }),
                                turbo_stream.replace('flash', partial: 'shared/alert',
                                                              locals: { notice: 'Event was successfully edited.' })]
        end
        format.html { redirect_to event_url(@event), notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:name, :description, :event_date, :address, :city, :state, :zipcode, :latitude,
                                  :longitude)
  end
end
