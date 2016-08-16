class ChangesInvitationsAddEvents < ActiveRecord::Migration
  def change
    add_foreign_key :invitations, :users
    add_reference :invitations, :event, index: true
  end
end
