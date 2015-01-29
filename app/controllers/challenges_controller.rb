class ChallengesController < ApplicationController
  before_action :set_challenge, only: [:show, :edit, :update, :destroy]

  # GET /challenges
  # GET /challenges.json
  def index
    @challenges = Challenge.all.order(:year)
  end

  # PUT /challenges/1/flickr_update
  def flickr_update
    challenge = Challenge.find(params[:challenge_id])
    challenge.update_from_flickr
    redirect_to challenges_path
  end

  def flickr_check_photos
    @challenge = Challenge.find(params[:challenge_id])
    @errors = @challenge.flickr_check_photos
  end

  # GET /challenges/1
  # GET /challenges/1.json
  def show
  end

  # GET /challenges/new
  def new
    @challenge = Challenge.new
  end

  # GET /challenges/1/edit
  def edit
  end

  # POST /challenges
  # POST /challenges.json
  def create
    @challenge = Challenge.new(challenge_params)

    respond_to do |format|
      if @challenge.save
        format.html { redirect_to @challenge, notice: 'Challenge was successfully created.' }
        format.json { render :show, status: :created, location: @challenge }
      else
        format.html { render :new }
        format.json { render json: @challenge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /challenges/1
  # PATCH/PUT /challenges/1.json
  def update
    respond_to do |format|
      if @challenge.update(challenge_params)
        format.html { redirect_to @challenge, notice: 'Challenge was successfully updated.' }
        format.json { render :show, status: :ok, location: @challenge }
      else
        format.html { render :edit }
        format.json { render json: @challenge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /challenges/1
  # DELETE /challenges/1.json
  def destroy
    @challenge.destroy
    respond_to do |format|
      format.html { redirect_to challenges_url, notice: 'Challenge was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # PUT /challenges/2/send_email/1305
  def send_email
    photo_id = params[:id]
    photo = Photo.find(photo_id)
    error_type = params[:error]
    if error_type == 'wrong_year'
      MemberMailer.wrong_year_email(photo).deliver
    elsif error_type == 'no_tag'
      MemberMailer.no_tag_email(photo).deliver
    elsif error_type == 'wrong_tag'
      MemberMailer.wrong_tag_email(photo).deliver
    end
    redirect_to challenge_flickr_check_photos_url(params[:challenge_id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_challenge
      @challenge = Challenge.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def challenge_params
      params.require(:challenge).permit(:year, :title, :url)
    end
end
