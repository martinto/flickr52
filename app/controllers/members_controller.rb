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

  # GET /challenges/:challenge_id/members/:id/edit
  def edit
    challenge_id = params[:challenge_id]
    @challenge = Challenge.find(challenge_id)
    @member = Member.find(params[:id])
    @post_url = challenge_member_path
  end

  # PATCH/PUT /challenges/:challenge_id/members/:id
  # PATCH/PUT /members/1.json
  def update
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to({ action: :show, challenge_id: params[:challenge_id], id: @member.id}, notice: 'Member was successfully updated.' )}
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_member
    @member = Member.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def member_params
    params.require(:member).permit(:email)
  end

end
