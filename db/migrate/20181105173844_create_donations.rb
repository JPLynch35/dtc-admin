class CreateDonations < ActiveRecord::Migration[5.1]
  def change
    create_table :donations do |t|
      t.string :stripe_id
      t.string :name
      t.string :email
      t.string :amount
      t.string :donation_type
      t.string :city
      t.string :state
      t.date :date

      t.timestamps
    end
  end
end
