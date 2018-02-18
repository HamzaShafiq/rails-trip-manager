class Trip < ApplicationRecord
	belongs_to :user
	belongs_to :vehicle

  ALLOWED_PARAMS = [:start_time, :end_time, :distance_travelled, :user_id, :vehicle_id]

  def self.overlap?(current_trip, all_trips)
    result = false
    trips = format_trips(all_trips)
    other_trips = trips.delete_if { |trip| trip == current_trip }
    other_trips.each do |trip|
      current_trip_start_time = current_trip[:start_time].to_datetime.utc
      current_trip_end_time = current_trip[:end_time].to_datetime.utc if current_trip[:end_time].present?
      other_trip_start_time = trip[:start_time].to_datetime.utc
      other_trip_end_time = trip[:end_time].to_datetime.utc if trip[:end_time].present?
      if current_trip_end_time.present? && other_trip_end_time.blank?
        result = current_trip_end_time >= other_trip_start_time
      elsif current_trip_end_time.blank? && other_trip_end_time.present?
        result = other_trip_end_time >= current_trip_start_time
      else
        result = current_trip_start_time <= other_trip_end_time && other_trip_start_time <= current_trip_end_time
      end
    end

    return result
  end

  def self.format_trips(trips)
    all_trips = []

    trips.each do |trip|
      temp = trip.to_unsafe_h
      all_trips.push(temp)
    end

    all_trips
  end

  def self.valid_trip_time?(trip)
    start_time = trip[:start_time].to_datetime.utc
    end_time = trip[:end_time].to_datetime.utc

    end_time <= start_time
	end

  def self.company_user?(user_id, company)
    user_id.to_i.in?(company.users.pluck(:id))
  end

  def self.company_vehicle?(vehicle_id, company)
    vehicle_id.to_i.in?(company.vehicles.pluck(:id))
  end

end
