# frozen_string_literal: true

# ApplicationMailer is the base mailer for all mailers in the application.
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
