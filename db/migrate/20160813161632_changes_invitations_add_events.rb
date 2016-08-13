class ChangesInvitationsAddEvents < ActiveRecord::Migration
  def change
    add_foreign_key :invitations, :users
    add_reference :invitations, :event, index: true, foreign_key: true
  end
end
