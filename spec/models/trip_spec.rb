require 'rails_helper'

RSpec.describe Trip, type: :model do

  it "is invalid without start_time" do
    trip = Trip.new(start_time: nil)
    trip.valid?
    expect(trip.errors[:start_time]).to include("can't be blank")
  end

  it "is invalid without end_time" do
    trip = Trip.new(end_time: nil)
    trip.valid?
    expect(trip.errors[:end_time]).to include("can't be blank")
  end

  it "is invalid without distance_travelled" do
    trip = Trip.new(distance_travelled: nil)
    trip.valid?
    expect(trip.errors[:distance_travelled]).to include("can't be blank")
  end

  it "returns true if trip start_time & end_time is not valid" do
    trip = { :start_time => DateTime.now, end_time: DateTime.now }
    expect(Trip.valid_trip_time?(trip)).to eq false
  end

  it "returns false if user does not belongs to company users" do
    user_id = 1
    company = Company.create(name: "Test")
    expect(Trip.company_user?(user_id, company)).to eq false
  end
end
