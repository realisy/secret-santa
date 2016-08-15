class CreateTables < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.timestamps
    end

    create_table :cities do |t|
      t.string :city_name
      t.string :province
      t.string :country
      t.timestamps
    end

    create_table :gifts do |t|
      t.string :gift_name
      t.text :gift_description
      t.decimal :est_value
      t.timestamps
    end

    create_table :events do |t|
      t.string :event_name
      t.text :event_description
      t.date :start_date
      t.date :registration_deadline
      t.date :event_date
      t.boolean :public_event, null: false, default: false
      t.integer :max_participants
      t.decimal :min_value
      t.decimal :max_value
      t.timestamps
    end

    create_table :invitations do |t|
      t.string :name
      t.string :email
      t.string :invitation_code
    end
  end
end
