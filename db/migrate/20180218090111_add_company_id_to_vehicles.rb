class AddCompanyIdToVehicles < ActiveRecord::Migration[5.1]
  def change
    add_column :vehicles, :company_id, :integer
    add_index :vehicles, :company_id
  end
end
