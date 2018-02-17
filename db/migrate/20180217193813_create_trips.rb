class CreateTrips < ActiveRecord::Migration[5.1]
  def change
    create_table :trips do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.string :distance_travelled

      t.timestamps
    end
  end
end
