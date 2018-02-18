require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with a name, role, and company_id" do
    user = User.new(
      name: "Test",
      role:  "Admin",
      company_id: Company.create(name: "Test").id
    )
    expect(user).to be_valid
  end

  it "is invalid without a name" do
    user = User.new(name: nil)
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  it "is invalid without a role" do
    user = User.new(role: nil)
    user.valid?
    expect(user.errors[:role]).to include("can't be blank")
  end

  it "is invalid without an company_id" do
    user = User.new(company_id: nil)
    user.valid?
    expect(user.errors[:company]).to include("must exist")
  end

  it "returns true if user role is admin" do
    user = User.new(
      name: "Test",
      role:  "admin",
      company_id: Company.create(name: "Test").id
    )
    expect(user.role).to eq "admin"
  end

  it "returns true if user role is read-only" do
    user = User.new(
      name: "Test",
      role:  "read-only",
      company_id: Company.create(name: "Test").id
    )
    expect(user.role).to eq "read-only"
  end
end
