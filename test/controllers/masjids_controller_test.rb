require "test_helper"

class MasjidsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @masjid = masjids(:one)
  end

  test "should get index" do
    get masjids_url
    assert_response :success
  end

  test "should get new" do
    get new_masjid_url
    assert_response :success
  end

  test "should create masjid" do
    assert_difference("Masjid.count") do
      post masjids_url, params: { masjid: { address: @masjid.address, city: @masjid.city, email: @masjid.email, name: @masjid.name, phone_number: @masjid.phone_number, state: @masjid.state, zipcode: @masjid.zipcode } }
    end

    assert_redirected_to masjid_url(Masjid.last)
  end

  test "should show masjid" do
    get masjid_url(@masjid)
    assert_response :success
  end

  test "should get edit" do
    get edit_masjid_url(@masjid)
    assert_response :success
  end

  test "should update masjid" do
    patch masjid_url(@masjid), params: { masjid: { address: @masjid.address, city: @masjid.city, email: @masjid.email, name: @masjid.name, phone_number: @masjid.phone_number, state: @masjid.state, zipcode: @masjid.zipcode } }
    assert_redirected_to masjid_url(@masjid)
  end

  test "should destroy masjid" do
    assert_difference("Masjid.count", -1) do
      delete masjid_url(@masjid)
    end

    assert_redirected_to masjids_url
  end
end
