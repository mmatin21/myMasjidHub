require "test_helper"

class FundraisersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fundraiser = fundraisers(:one)
  end

  test "should get index" do
    get fundraisers_url
    assert_response :success
  end

  test "should get new" do
    get new_fundraiser_url
    assert_response :success
  end

  test "should create fundraiser" do
    assert_difference("Fundraiser.count") do
      post fundraisers_url, params: { fundraiser: { description: @fundraiser.description, end_date: @fundraiser.end_date, goal_amount: @fundraiser.goal_amount, masjid_id: @fundraiser.masjid_id, name: @fundraiser.name } }
    end

    assert_redirected_to fundraiser_url(Fundraiser.last)
  end

  test "should show fundraiser" do
    get fundraiser_url(@fundraiser)
    assert_response :success
  end

  test "should get edit" do
    get edit_fundraiser_url(@fundraiser)
    assert_response :success
  end

  test "should update fundraiser" do
    patch fundraiser_url(@fundraiser), params: { fundraiser: { description: @fundraiser.description, end_date: @fundraiser.end_date, goal_amount: @fundraiser.goal_amount, masjid_id: @fundraiser.masjid_id, name: @fundraiser.name } }
    assert_redirected_to fundraiser_url(@fundraiser)
  end

  test "should destroy fundraiser" do
    assert_difference("Fundraiser.count", -1) do
      delete fundraiser_url(@fundraiser)
    end

    assert_redirected_to fundraisers_url
  end
end
