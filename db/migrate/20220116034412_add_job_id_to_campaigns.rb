class AddJobIdToCampaigns < ActiveRecord::Migration[6.0]
  def change
    add_column :campaigns, :job_id, :string
  end
end
