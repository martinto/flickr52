class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]

  # GET /challenges/:challenge_id/members
  # GET/challenges/:challenge_id/members.json
  def index
    challenge_id = params[:challenge_id]
    @challenge = Challenge.find(challenge_id)
    @members = @challenge.members
  end

  # GET /challenges/:challenge_id/members/:id
  # GET /members/1.json
  def show
    challenge_id = params[:challenge_id]
    @challenge = Challenge.find(challenge_id)
  end

  private

  def set_member
    @member = Member.find(params[:id])
  end

end
