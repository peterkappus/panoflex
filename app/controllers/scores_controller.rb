class ScoresController < ApplicationController
  before_action :set_score, only: [:show, :edit, :update, :destroy]
  #before_action :set_goal, only: [:new, :create, :index, :show, :edit, :update, :destroy]
  #before_action :check_admin, only: [:new, :edit, :create, :update, :destroy]

  #TODO: Refactor and merge these together... they're so similar.
  #can the user see the "new" action?
  before_action only: [:new] do
    #are they the owner of the goal or an admin?
    is_admin? || Goal.find(params[:goal_id]).owner == current_user
  end

  #can the user save a new score?
  before_action only: [:create] do
    #are they they owner of the goal or an admin?
     is_admin? || Goal.find(params[:score][:goal_id]).owner == current_user
  end

  #only admins can modify updates
  before_action only: [:edit, :update, :destroy] do
     is_admin?
  end

  # GET /scores
  # GET /scores.json
  def index
    @scores = Score.all
  end

  # GET /scores/1
  # GET /scores/1.json
  def show
  end

  # GET /scores/new
  def new

    #TODO:  Redirect home
    @goal = Goal.find(params[:goal_id])

    if(@goal.nil?)
      flash[:error] = "Could not find goal with id #{params[:goal_id]}"
      redirect_to root_path
    end

    #otherwise... we're good to go...
    @score = Score.new
    @score.goal = @goal #use the goal_id passed in...
    #if we tried to find a goal to attach this score to but couldn't find it, bail out.
  end

  # GET /scores/1/edit
  def edit
  end

  # POST /scores
  # POST /scores.json
  def create
    @score = Score.new(score_params)
    @score.user = current_user

    respond_to do |format|
      if @score.save
        format.html { redirect_to @score.goal, notice: 'Score was successfully created.' }
        format.json { render :show, status: :created, location: @score.goal }
      else
        format.html { render :new }
        format.json { render json: @score.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scores/1
  # PATCH/PUT /scores/1.json
  def update
    @score.user = current_user
    respond_to do |format|
      if @score.update(score_params)
        format.html { redirect_to @score.goal, notice: 'Score was successfully updated.' }
        format.json { render :show, status: :ok, location: @score.goal }
      else
        format.html { render :edit }
        format.json { render json: @score.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scores/1
  # DELETE /scores/1.json
  def destroy
    @score.destroy
    respond_to do |format|
      format.html { redirect_to @score.goal, notice: 'Score was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_score
      @score = Score.find(params[:id])
    end

    #def set_goal
    #  @goal = Goal.find(params[:goal_id]) if params[:goal_id]
    #  || @score.goal
      #raise "Goal not found!"
    #end

    # Never trust parameters from the scary internet, only allow the white list through.
    def score_params
      params.require(:score).permit(:amount, :reason, :goal_id)
    end
end
