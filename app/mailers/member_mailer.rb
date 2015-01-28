class MemberMailer < ActionMailer::Base
  default from: "martin@tomes.org.uk"

  def wrong_year_email(photo)
    @photo = photo
    to = to_whom(photo)
    mail(to: to, subject: "#{@photo.challenge.title}: Photo taken in wrong year")
    SentEmail.create! photo: photo, sent_at: DateTime.now, error_type: 'wrong_year', title: "#{@photo.challenge.title}: Photo taken in wrong year"
  end

  def no_tag_email(photo)
    @photo = photo
    to = to_whom(photo)
    mail(to: to, subject: "#{@photo.challenge.title}: Photo has no tag")
    SentEmail.create! photo: photo, sent_at: DateTime.now, error_type: 'no_tag', title: "#{@photo.challenge.title}: Photo has no tag"
  end

  def wrong_tag_email(photo)
    @photo = photo
    to = to_whom(photo)
    mail(to: to, subject: "#{@photo.challenge.title}: Photo tag incorrect")
    SentEmail.create! photo: photo, sent_at: DateTime.now, error_type: 'wrong_tag', title: "#{@photo.challenge.title}: Photo tag incorrect"
  end

private
  def to_whom(photo)
    to = photo.member.email
    if Rails.env.development?
      to = 'martin.tomes@gmail.com'
    end
    return to
  end
end
