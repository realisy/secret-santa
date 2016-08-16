class CreateRelations < ActiveRecord::Migration
  def change
     add_reference :users, :city, index: true, foreign_key: true
     add_reference :events, :city, index: true, foreign_key: true
     add_reference :events, :creator, references: :users, index: true, foreign_key: true
     add_reference :gifts, :user, index: true, foreign_key: true
     add_reference :invitations, :user, index: true, foreign_key: true
     create_join_table :users, :events
  end
end
