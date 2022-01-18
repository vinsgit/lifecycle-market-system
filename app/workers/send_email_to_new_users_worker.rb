class SendEmailToNewUsersWorker
  include Sidekiq::Worker
  queue_as :default
  sidekiq_options retry: 1, backtrace: true

  def perform(campaign_id)
    user_created_date = Date.today - 7.days
    users = User.where('created_at<= ? and sent_on = ?', user_created_date, false)
    emails = users.map(&:email)
    names = users.map(&:name)
    SendgridMailer.send_letter(campaign_id, emails, names)
    users.update_all(sent_on: true)
    # Arrange next day job
    schedual_next_email_worker!(campaign_id)
  end

  def schedual_next_email_worker!(campaign_id)
    campaign = Campaign.find(campaign_id)
    job_id = SendEmailToNewUsersWorker.perform_at(campaign.send_time, campaign_id)
    campaign.update_column(:job_id, job_id)
  end
end