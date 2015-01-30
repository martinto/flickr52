class MemberMailer < ActionMailer::Base
  default from: "martin@tomes.org.uk"

  def wrong_year_email(photo)
    @photo = photo
    to = to_whom(photo)
    return mail(to: to, subject: "#{@photo.challenge.title}: Photo taken in wrong year")
  end

  def no_tag_email(photo)
    @photo = photo
    to = to_whom(photo)
    return mail(to: to, subject: "#{@photo.challenge.title}: Photo has no tag")
  end

  def wrong_tag_email(photo)
    @photo = photo
    to = to_whom(photo)
    return mail(to: to, subject: "#{@photo.challenge.title}: Photo tag incorrect")
  end

private
  def to_whom(photo)
    to = photo.member.email
    if Rails.env.development? || to.nil?
      to = 'martin.tomes@gmail.com'
    end
    return to
  end
end
