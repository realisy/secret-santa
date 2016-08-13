class CreateTargetsTable < ActiveRecord::Migration
  def change
    create_table :targets, id: false do |t|
      t.references :santa
      t.references :recipient
      t.references :event
    end
  end
end
