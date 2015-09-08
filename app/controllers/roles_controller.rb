class RolesController < ApplicationController
  before_action :set_role, only: [:show, :edit, :update, :destroy]

  # GET /roles
  # GET /roles.json
  def index
    #only vacant roles
    #smarter way to do this?
    if(%w(vacant).include? params[:scope])
      @roles = Role.vacant.order(:name).page params[:page]
    else
      #all roles
      @roles = Role.order(:name).page params[:page]
    end
  end

  def vacant
    #render plain: "okay"

    @all = Role.vacant.order(:name).page params[:page]
    @overdue = Role.vacant_by_date(24.months.ago,Date.today)
    @months_3 = Role.vacant_by_date(Date.today,Date.today+3.months)
    @months_6 = Role.vacant_by_date(Date.today+3.months,Date.today+6.months)
    @months_6_plus = Role.vacant_by_date(Date.today+6.months,Date.today+24.months)

  end

  # GET /roles/1
  # GET /roles/1.json
  def show
  end

  #POST /roles/import
  def import
    if(params[:file])
      msg = Role.import(params[:file])
      if(msg.to_s.empty?)
        redirect_to roles_url, notice: "Import successful."
      else
        redirect_to roles_path, flash: {:error=> msg}
      end
    else
      redirect_to roles_path, flash: {:error=> "Oops, no CVS file specified."}
    end
  end

  # GET /roles/new
  def new
    @role = Role.new
  end

  # GET /roles/1/edit
  def edit
  end

  # POST /roles
  # POST /roles.json
  def create
    @role = Role.new(role_params)

    respond_to do |format|
      if @role.save
        format.html { redirect_to @role, notice: 'Role was successfully created.' }
        format.json { render :show, status: :created, location: @role }
      else
        format.html { render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roles/1
  # PATCH/PUT /roles/1.json
  def update
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to @role, notice: 'Role was successfully updated.' }
        format.json { render :show, status: :ok, location: @role }
      else
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy
    @role.destroy
    respond_to do |format|
      format.html { redirect_to roles_url, notice: 'Role was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def role_params
      params.require(:role).permit(:name, :title, :type, :monthly_cost, :apr, :may, :jun, :jul, :aug, :sep, :oct, :nov, :dec, :jan, :feb, :mar, :comments, :function_name, :team)
    end
end
