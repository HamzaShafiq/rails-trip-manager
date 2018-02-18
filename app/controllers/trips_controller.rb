class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :update, :destroy]
  before_action :check_user_role , only: :create
  before_action :validate_params, only: :create
  before_action :validate_data, only: :create
  before_action :validate_index_params, only: :index

  # GET /trips
  def index
    start_time = params[:start_time].to_datetime.utc
    end_time = params[:end_time].to_datetime.utc
    @trips = Trip.get_trips(start_time, end_time)

    if params[:user_id].present?
      @trips = @trips.where(user_id: params[:user_id])
    end

    if params[:vehicle_id].present?
      @trips = @trips.where(vehicle_id: params[:vehicle_id])
    end

    @trips = @trips.where(user_id: @company.users.pluck(:id), vehicle_id: @company.vehicles.pluck(:id))

    render json: @trips
  end

  # POST /trips
  def create
    @trips = params[:trips]

    Trip.transaction do
       @trips.each do |trip|
        start_time = trip[:start_time].to_datetime.utc
        end_time = trip[:end_time].to_datetime.utc if trip[:end_time].present?
        @trip = Trip.new(start_time: start_time, end_time: end_time,
                        distance_travelled: trip[:distance_travelled], user_id: trip[:user_id],
                        vehicle_id: trip[:vehicle_id])
        @trip.save!
      end
    end

    if @trip.errors.blank?
      render json: { message: 'Trips created successfully' }, status: :created
    else
      render json: { message: "Trips cannot be created" }, status: :bad_request
    end
  end

  private

    def check_user_role
      render json: { message: "User don't have permission to create trips." }, status: :unauthorized if @current_user.read_only?
    end

    def validate_index_params
      if params[:start_time].blank? || params[:end_time].blank?
        return render json: { message: "Start/End time parameter missing" }, status: :bad_request
      end
    end

    def validate_params
      params[:trips].each do |trip|
        Trip::ALLOWED_PARAMS.each do |key|
          next if key == :end_time
          return render json: { message: "#{key} parameter missing" }, status: :bad_request if trip[key].blank?
        end
      end
    end

    def validate_data
      params[:trips].each do |trip|
        message = check_users_and_vehicles(trip)
        message = check_trip_time_validity(trip) if message.blank?
        message = check_trips(trip, params[:trips]) if message.blank?

        return render json: { message: message }, status: :bad_request if message.present?
      end
    end

    def check_users_and_vehicles(trip)
      'Invalid user/vehicle id' unless Trip.company_user?(trip[:user_id], @company) && Trip.company_vehicle?(trip[:vehicle_id], @company)
    end

    def check_trips(trip, all_trips)
      'Trips Overlapping' if Trip.overlap?(trip, all_trips) == true
    end

    def check_trip_time_validity(trip)
      'Start time must be smaller than end time' if trip[:end_time].present? && Trip.valid_trip_time?(trip)
    end

    # Only allow a trusted parameter "white list" through.
    def trip_params
      params.require(:trip).permit(:start_time, :end_time, :distance_travelled, :user_id, :vehicle_id)
    end
end
