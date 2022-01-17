class AddCategoryToCampaigns < ActiveRecord::Migration[6.0]
  def change
    add_column :campaigns, :category, :integer
  end
end
