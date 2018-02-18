require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  it "is valid with a name, and company_id" do
    vehicle = Vehicle.new(
      name: "Toyota",
      company_id: Company.create(name: "Test").id
    )
    expect(vehicle).to be_valid
  end

  it "is invalid without a name" do
    vehicle = Vehicle.new(name: nil)
    vehicle.valid?
    expect(vehicle.errors[:name]).to include("can't be blank")
  end
end
