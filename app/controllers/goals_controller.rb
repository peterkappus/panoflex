class GoalsController < ApplicationController
  before_action :set_goal, only: [:show, :edit, :update, :destroy]

  before_action only: [:import_okrs]

  before_action only: [:new, :create ] do
     can_create? Goal.find_by(id: params['parent_id'])
  end

  before_action only: [:edit, :update, :destroy] do
     can_modify? @goal
  end
  #around_filter :catch_not_found

  # GET /goals
  # GET /goals.json
  def index
    @goals = Goal.all
    #Goal.gds_goals
    respond_to do |format|
      format.html
      format.csv { send_data @goals.to_csv}
    end

  end

  # GET /goals/1
  # GET /goals/1.json
  def show
  end

  def show_export
    render :text=>"<pre>" + Goal.to_csv.to_s
  end

  # GET /goals/new
  def new
    @goal = Goal.new

    @goal.owner = current_user


    #set the parent ID for the new goal if we passed one in via the params and if it's been found
    #what's a more "railsy" way to do this?
    @goal.parent = Goal.find_by_id(params[:parent_id])

    if(params[:group_id] || params[:group])
      @goal.group = Group.find_by_id(params[:group_id]) || Group.friendly.find(params[:group])
    end

    if(params[:team_id] || params[:team])
      @goal.team = Team.find_by_id(params[:team_id]) || Team.friendly.find(params[:team])
    end

    if @goal.parent
      @goal.team = @goal.parent.team
      @goal.group = @goal.parent.group
    end
  end

  # GET /goals/1/edit
  def edit
  end

  # POST /goals
  # POST /goals.json
  def create
    @goal = Goal.new(goal_params)
    set_owner

    respond_to do |format|
      if @goal.save
        format.html { redirect_to @goal.parent.nil? ? @goal : @goal.parent, notice: 'Goal was successfully created.' }
        format.json { render :show, status: :created, location: @goal }
      else
        format.html { render :new }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /goals/1
  # PATCH/PUT /goals/1.json
  def update
    #set_owner unless @goal.owner
    #raise goal_params.to_s
    respond_to do |format|
      if @goal.update(goal_params)
        format.html { redirect_to @goal, notice: 'Goal was successfully updated.' }
        format.json { render :show, status: :ok, location: @goal }
      else
        format.html { render :edit }
        format.json { render json: @goal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /goals/1
  # DELETE /goals/1.json
  def destroy
    #TODO: rewrite this method to actually "archive" the goals and include a note on why it was archived.
    #do some separate, more secure method for actually deleting them.

    if(!@goal.children.empty?)
      redirect_to @goal, error: "Goals may only be deleted if they have no sub-goals. Please delete the #{pluralize(@Goals.children.count,"sub-goal")} of this goal and try again."
    end

    @goal.destroy
    #orphan children on destroying
    #NOTE: use :dependent :nullify, instead
    #@goal.children.each do |c|
    #  c.update!(parent_id: nil)
    #end

    redirect_url = (@goal.parent) ? @goal.parent : goals_path

    respond_to do |format|
      format.html { redirect_to redirect_url, notice: 'Goal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import_okrs
    if(params[:file])
      msg = Goal.import_okrs(params[:file])
      if(msg.to_s.empty?)
        redirect_to goals_path, notice: "Import successful."
      else
        redirect_to goals_path, flash: {:error=> msg}
      end
    else
      redirect_to goals_path, flash: {:error=> "Oops, no CVS file specified."}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_goal
      @goal = Goal.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url, :flash => { :error => "Sorry, that goal could not be found. It may have been moved following a recent import." }
    end

    #use to track who modified goals
    def set_owner
      @goal.owner = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def goal_params
      params.require(:goal).permit(:name, :team_id, :user_id, :group_id, :parent_id, :deadline, :start_date)
    end
end
