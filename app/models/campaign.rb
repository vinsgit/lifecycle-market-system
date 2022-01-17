class Campaign < ApplicationRecord
  belongs_to :email_template

  validates :name, :send_at, :email_template, presence: true

  before_save :set_new_job
  after_destroy :delete_current_job!

  # 0 stands for those who just registered
  enum category: { for_new_user: 0 }

  def send_time
    time_zone =  Time.now.in_time_zone(Time.zone.name).formatted_offset
    today_send_time = "#{Date.today.to_s} #{send_at} #{time_zone}".to_datetime
    if Time.current <= today_send_time
      today_send_time
    else
      # one day instead of 24 hours for the sake of WT & DST
      today_send_time + 1.day
    end
  end

  private

  def set_new_job
    if category == 'for_new_user'
      if job_id.blank?
        set_new_job_id
      else
        delete_current_job!
        set_new_job_id
      end
    end
  end

  def set_new_job_id
    self.job_id = schedual_email_worker
  end

  def schedual_email_worker
    SendEmailToNewUsersWorker.perform_at(send_time, id)
  end

  def delete_current_job!
    Sidekiq::ScheduledSet.new.find_job(job_id)&.delete
  end

end
