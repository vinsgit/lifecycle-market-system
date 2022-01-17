FactoryBot.define do
  factory :email_template do
    name { "Test Template" }
    template { "<p>Test</p>" }
  end
end