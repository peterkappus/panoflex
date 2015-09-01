require 'test_helper'

class ActualsControllerTest < ActionController::TestCase
  setup do
    @actual = actuals(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:actuals)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create actual" do
    assert_difference('Actual.count') do
      post :create, actual: { account: @actual.account, account_description: @actual.account_description, account_type: @actual.account_type, cost_centre: @actual.cost_centre, cost_centre_description: @actual.cost_centre_description, credit: @actual.credit, customer_or_supplier: @actual.customer_or_supplier, debit: @actual.debit, description: @actual.description, gl_date: @actual.gl_date, period: @actual.period, po_number: @actual.po_number, reference: @actual.reference, team: @actual.team, total: @actual.total }
    end

    assert_redirected_to actual_path(assigns(:actual))
  end

  test "should show actual" do
    get :show, id: @actual
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @actual
    assert_response :success
  end

  test "should update actual" do
    patch :update, id: @actual, actual: { account: @actual.account, account_description: @actual.account_description, account_type: @actual.account_type, cost_centre: @actual.cost_centre, cost_centre_description: @actual.cost_centre_description, credit: @actual.credit, customer_or_supplier: @actual.customer_or_supplier, debit: @actual.debit, description: @actual.description, gl_date: @actual.gl_date, period: @actual.period, po_number: @actual.po_number, reference: @actual.reference, team: @actual.team, total: @actual.total }
    assert_redirected_to actual_path(assigns(:actual))
  end

  test "should destroy actual" do
    assert_difference('Actual.count', -1) do
      delete :destroy, id: @actual
    end

    assert_redirected_to actuals_path
  end
end
