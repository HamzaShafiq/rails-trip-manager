class TripSerializer < ActiveModel::Serializer
  attributes :id, :start_time, :end_time, :distance_travelled

  has_one :user
  has_one :vehicle
end
