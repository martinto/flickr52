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
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sent_email
      @sent_email = SentEmail.find(params[:id])
    end
end
