require "application_system_test_case"

class MasjidsTest < ApplicationSystemTestCase
  setup do
    @masjid = masjids(:one)
  end

  test "visiting the index" do
    visit masjids_url
    assert_selector "h1", text: "Masjids"
  end

  test "should create masjid" do
    visit masjids_url
    click_on "New masjid"

    fill_in "Address", with: @masjid.address
    fill_in "City", with: @masjid.city
    fill_in "Email", with: @masjid.email
    fill_in "Name", with: @masjid.name
    fill_in "Phone number", with: @masjid.phone_number
    fill_in "State", with: @masjid.state
    fill_in "Zipcode", with: @masjid.zipcode
    click_on "Create Masjid"

    assert_text "Masjid was successfully created"
    click_on "Back"
  end

  test "should update Masjid" do
    visit masjid_url(@masjid)
    click_on "Edit this masjid", match: :first

    fill_in "Address", with: @masjid.address
    fill_in "City", with: @masjid.city
    fill_in "Email", with: @masjid.email
    fill_in "Name", with: @masjid.name
    fill_in "Phone number", with: @masjid.phone_number
    fill_in "State", with: @masjid.state
    fill_in "Zipcode", with: @masjid.zipcode
    click_on "Update Masjid"

    assert_text "Masjid was successfully updated"
    click_on "Back"
  end

  test "should destroy Masjid" do
    visit masjid_url(@masjid)
    click_on "Destroy this masjid", match: :first

    assert_text "Masjid was successfully destroyed"
  end
end
