class AddVehicleIdToTrips < ActiveRecord::Migration[5.1]
  def change
    add_column :trips, :vehicle_id, :integer
    add_index :trips, :vehicle_id
  end
end
