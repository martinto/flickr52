class WeeksController < ApplicationController
  before_action :set_week, only: [:show, :edit, :update, :destroy]

  # GET /challenges/:challenge_id/weeks
  # GET/challenges/:challenge_id/weeks.json
  def index
    challenge_id = params[:challenge_id]
    @challenge = Challenge.find(challenge_id)
    @weeks = Week.where :challenge_id => challenge_id
  end

  # GET /challenges/:challenge_id/weeks/:id
  # GET /weeks/1.json
  def show
    challenge_id = params[:challenge_id]
    @challenge = Challenge.find(challenge_id)
  end

  # GET /challenges/:challenge_id/weeks/new
  def new
    challenge_id = params[:challenge_id]
    @challenge = Challenge.find(challenge_id)
    @week = Week.new id: 1
    @post_url = challenge_weeks_path
  end

  # GET /challenges/:challenge_id/weeks/:id/edit
  def edit
    challenge_id = params[:challenge_id]
    @challenge = Challenge.find(challenge_id)
    @week = Week.find(params[:id])
    @post_url = challenge_week_path
  end

  # POST /challenges/:challenge_id/weeks
  # POST /weeks.json
  def create
    @week = Week.new(week_params)

    respond_to do |format|
      if @week.save
        format.html { redirect_to({ action: :show, challenge_id: params[:challenge_id], id: @week.id}, notice: 'Week was successfully created.' ) }
        format.json { render :show, status: :created, location: @week }
      else
        format.html { render :new }
        format.json { render json: @week.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /challenges/:challenge_id/weeks/:id
  # PATCH/PUT /weeks/1.json
  def update
    respond_to do |format|
      if @week.update(week_params)
        format.html { redirect_to({ action: :show, challenge_id: params[:challenge_id], id: @week.id}, notice: 'Week was successfully updated.' )}
        format.json { render :show, status: :ok, location: @week }
      else
        format.html { render :edit }
        format.json { render json: @week.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /weeks/1
  # DELETE /weeks/1.json
  def destroy
    @week.destroy
    respond_to do |format|
      format.html { redirect_to challenge_weeks_url, notice: 'Week was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # DELETE /challenges/:challenge_id/weeks/clear
  def clear
    Week.where(:challenge_id =>  params[:challenge_id]).destroy_all
    redirect_to({ action: :index, challenge_id: params[:challenge_id]})
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_week
      @week = Week.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def week_params
      params.require(:week).permit(:week_number, :subject, :challenge_id)
    end
end
