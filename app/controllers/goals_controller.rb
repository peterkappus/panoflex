class GoalsController < ApplicationController
  before_action :set_goal, only: [:show, :edit, :update, :destroy]
  before_action :check_admin, only: [:new, :edit, :create, :update, :destroy]

  # GET /goals
  # GET /goals.json
  def index
    @goals = Goal.all
    Goal.gds_goals
  end

  # GET /goals/1
  # GET /goals/1.json
  def show
  end

  # GET /goals/new
  def new
    @goal = Goal.new

    #set the parent ID for the new goal if we passed one in via the params and if it's been found
    #what's a more "railsy" way to do this?
    @goal.parent_id = params[:parent_id] if Goal.find_by_id(params[:parent_id])
  end

  # GET /goals/1/edit
  def edit
  end

  # POST /goals
  # POST /goals.json
  def create
    @goal = Goal.new(goal_params)

    respond_to do |format|
      if @goal.save
        format.html { redirect_to @goal, notice: 'Goal was successfully created.' }
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
    @goal.destroy
    #orphan children on destroying
    #NOTE: use :dependent :nullify, instead
    #@goal.children.each do |c|
    #  c.update!(parent_id: nil)
    #end

    respond_to do |format|
      format.html { redirect_to goals_url, notice: 'Goal was successfully destroyed.' }
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
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def goal_params
      params.require(:goal).permit(:name, :team_id, :group_id, :parent_id)
    end
end
