class AddStatusToMessages < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :status, :string
  end
end
