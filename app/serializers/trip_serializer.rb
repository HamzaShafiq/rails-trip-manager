class TripSerializer < ActiveModel::Serializer
  attributes :id, :start_time, :end_time, :distance_travelled
end
