require 'rails_helper'

RSpec.describe Company, type: :model do
  it "is valid with a name" do
    company = Company.new(name: "Test")
    expect(company).to be_valid
  end
  it "is invalid without a name" do
    company = Company.new(name: nil)
    company.valid?
    expect(company.errors[:name]).to include("can't be blank")
  end
end
