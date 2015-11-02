require 'test_helper'

class PolishesControllerTest < ActionController::TestCase
  setup do
    @polish = polishes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:polishes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create polish" do
    assert_difference('Polish.count') do
      post :create, polish: {  }
    end

    assert_redirected_to polish_path(assigns(:polish))
  end

  test "should show polish" do
    get :show, id: @polish
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @polish
    assert_response :success
  end

  test "should update polish" do
    patch :update, id: @polish, polish: {  }
    assert_redirected_to polish_path(assigns(:polish))
  end

  test "should destroy polish" do
    assert_difference('Polish.count', -1) do
      delete :destroy, id: @polish
    end

    assert_redirected_to polishes_path
  end
end
