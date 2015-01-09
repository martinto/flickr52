class MemberMailer < ActionMailer::Base
  default from: "martin@tomes.org.uk"

  def wrong_year_email(photo)
    @photo = photo
    mail(to: 'martin.tomes@gmail.com', subject: "#{@photo.challenge.title}: Photo taken in wrong year")
  end

  def no_tag_email(photo)
    @photo = photo
    mail(to: 'martin.tomes@gmail.com', subject: "#{@photo.challenge.title}: Photo has no tag")
  end

  def wrong_tag_email(photo)
    @photo = photo
    mail(to: 'martin.tomes@gmail.com', subject: "#{@photo.challenge.title}: Photo tag incorrect")
  end
end
