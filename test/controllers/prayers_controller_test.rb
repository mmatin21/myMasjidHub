require "test_helper"

class PrayersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @prayer = prayers(:one)
  end

  test "should get index" do
    get prayers_url
    assert_response :success
  end

  test "should get new" do
    get new_prayer_url
    assert_response :success
  end

  test "should create prayer" do
    assert_difference("Prayer.count") do
      post prayers_url, params: { prayer: { adhaan: @prayer.adhaan, iqaamah: @prayer.iqaamah, masjid_id: @prayer.masjid_id, name: @prayer.name } }
    end

    assert_redirected_to prayer_url(Prayer.last)
  end

  test "should show prayer" do
    get prayer_url(@prayer)
    assert_response :success
  end

  test "should get edit" do
    get edit_prayer_url(@prayer)
    assert_response :success
  end

  test "should update prayer" do
    patch prayer_url(@prayer), params: { prayer: { adhaan: @prayer.adhaan, iqaamah: @prayer.iqaamah, masjid_id: @prayer.masjid_id, name: @prayer.name } }
    assert_redirected_to prayer_url(@prayer)
  end

  test "should destroy prayer" do
    assert_difference("Prayer.count", -1) do
      delete prayer_url(@prayer)
    end

    assert_redirected_to prayers_url
  end
end
