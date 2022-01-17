class CreateCampaigns < ActiveRecord::Migration[6.0]
  def change
    create_table :campaigns do |t|
      t.string :name
      t.string :send_at
      t.integer :email_template_id
      t.timestamps
    end
  end
end
