class EmailTemplate < ApplicationRecord
  validates :template, :name, presence: true
end
