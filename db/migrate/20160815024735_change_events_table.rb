class ChangeEventsTable < ActiveRecord::Migration
  def change
    add_column  :events, :targets_assigned, :boolean, default: false
  end
end
