class DeviseCustomMailer < Devise::Mailer
  before_action :add_inline_attachment!

  private

  def add_inline_attachment!
    pngs = ['mail.png']

    pngs.each do |png|
      attachments.inline[png] = File.read("#{Rails.root}/app/assets/images/mailer/" + png)
    end
  end
  default from: 'ENV["GMAIL_USER_NAME"]'
  layout 'mailer'
end