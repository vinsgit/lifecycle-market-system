class SendgridMailer < ActionMailer::Base
  include SendGrid

  default from: "Vita <vitamiumiu@gmail.com>"

  def send_letter(campaign_id, emails, names)
    campaign = Campaign.find(campaign_id)
    sendgrid_recipients emails
    sendgrid_substitute "|name|", names
    mail(to: 'vitamiumiu@gmail.com', content_type: 'text/html', body: campaign.template, subject: campaign.name)
  end
end