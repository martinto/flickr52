class SentEmailsController < ApplicationController
  before_action :set_sent_email, only: [:show ]

  # GET /sent_emails
  # GET /sent_emails.json
  def index
    @sent_emails = SentEmail.all
  end

  # GET /sent_emails/1
  # GET /sent_emails/1.json
  def show
    if @sent_email.photo.nil?
      @display_name = ''
      @title = ''
      @flickr_url = ''
    else
      @display_name = @sent_email.photo.member.display_name
      @title = @sent_email.photo.title
      @flickr_url = @sent_email.photo.get_flickr_url
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sent_email
      @sent_email = SentEmail.find(params[:id])
    end
end
