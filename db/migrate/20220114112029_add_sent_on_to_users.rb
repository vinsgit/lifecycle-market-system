class AddSentOnToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :sent_on, :boolean, default: false
  end
end
