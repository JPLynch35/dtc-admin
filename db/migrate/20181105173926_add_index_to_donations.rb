class AddIndexToDonations < ActiveRecord::Migration[5.1]
  def change
    add_index :donations, :stripe_id
  end
end
