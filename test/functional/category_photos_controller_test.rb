require 'test_helper'

class CategoryPhotosControllerTest < ActionController::TestCase
  setup do
    @category_photo = category_photos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:category_photos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create category_photo" do
    assert_difference('CategoryPhoto.count') do
      post :create, category_photo: { ancestry: @category_photo.ancestry, name: @category_photo.name }
    end

    assert_redirected_to category_photo_path(assigns(:category_photo))
  end

  test "should show category_photo" do
    get :show, id: @category_photo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @category_photo
    assert_response :success
  end

  test "should update category_photo" do
    put :update, id: @category_photo, category_photo: { ancestry: @category_photo.ancestry, name: @category_photo.name }
    assert_redirected_to category_photo_path(assigns(:category_photo))
  end

  test "should destroy category_photo" do
    assert_difference('CategoryPhoto.count', -1) do
      delete :destroy, id: @category_photo
    end

    assert_redirected_to category_photos_path
  end
end
