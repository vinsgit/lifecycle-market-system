require 'rails_helper'
require 'sidekiq/testing' 
Sidekiq::Testing.fake!

RSpec.describe Campaign, type: :model do
  describe "#Instant methods" do
    let(:send_at) { "#{Time.now.hour + 1 }:00" }
    let!(:email_template) { create(:email_template) }
    let!(:campaign) { create(:campaign, email_template_id: email_template.id, send_at: send_at ) }

    context "send_at earlier than current time" do
      let(:send_at) { "#{Time.now.hour - 1 }:00" }
      it "send_time should be at the same time of the next day" do
        expect(campaign.send_time).to eq "#{Date.today.to_s} #{send_at} +08:00".to_datetime + 1.day
      end
    end

    context "send_at later than current time" do
      it "send_time should be at the same time of today" do
        expect(campaign.send_time).to eq "#{Date.today.to_s} #{send_at} +08:00".to_datetime
      end
    end


    it "schedual_email_worker should create a new SendEmailToNewUsersWorker to sidekiq" do
      expect do
        campaign.send(:schedual_email_worker)
      end.to change(SendEmailToNewUsersWorker.jobs, :size).by(1)
    end

    it "set_new_job_id should change job_id from campaign" do
      old_job_id = campaign.job_id
      expect do
        campaign.send(:set_new_job_id)
      end.to change(campaign, :job_id)
    end

    context "when job_id is nil" do
      it "set_new_job should change job_id from campaign" do
        campaign.update_column(:job_id, nil)
        campaign.send(:set_new_job)
        expect(campaign.job_id).not_to be_nil
      end
    end

    context "when job_id is not nil" do
      it "set_new_job should change job_id from campaign" do
        expect do
          campaign.send(:set_new_job)
        end.to change(campaign, :job_id)
      end
    end
  end
end