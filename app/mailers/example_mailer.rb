class ExampleMailer < ApplicationMailer
    default from: "from@example.com"

  def sample_email
    # @user = user
    mail(to: 'dipeshbirla57@gmail.com', subject: 'Sample Email')
  end
end
