require 'test_helper'

class RolesControllerTest < ActionController::TestCase
  setup do
    @role = roles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:roles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create role" do
    assert_difference('Role.count') do
      post :create, role: { apr: @role.apr, aug: @role.aug, comments: @role.comments, dec: @role.dec, feb: @role.feb, function: @role.function, jan: @role.jan, jul: @role.jul, jun: @role.jun, mar: @role.mar, may: @role.may, monthly_cost: @role.monthly_cost, name: @role.name, nov: @role.nov, oct: @role.oct, sep: @role.sep, team: @role.team, title: @role.title, type: @role.role_type }
    end

    assert_redirected_to role_path(assigns(:role))
  end

  test "should show role" do
    get :show, id: @role
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @role
    assert_response :success
  end

  test "should update role" do
    patch :update, id: @role, role: { apr: @role.apr, aug: @role.aug, comments: @role.comments, dec: @role.dec, feb: @role.feb, function: @role.function, jan: @role.jan, jul: @role.jul, jun: @role.jun, mar: @role.mar, may: @role.may, monthly_cost: @role.monthly_cost, name: @role.name, nov: @role.nov, oct: @role.oct, sep: @role.sep, team: @role.team, title: @role.title, type: @role.type }
    assert_redirected_to role_path(assigns(:role))
  end

  test "should destroy role" do
    assert_difference('Role.count', -1) do
      delete :destroy, id: @role
    end

    assert_redirected_to roles_path
  end
end
