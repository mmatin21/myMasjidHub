require "application_system_test_case"

class PrayersTest < ApplicationSystemTestCase
  setup do
    @prayer = prayers(:one)
  end

  test "visiting the index" do
    visit prayers_url
    assert_selector "h1", text: "Prayers"
  end

  test "should create prayer" do
    visit prayers_url
    click_on "New prayer"

    fill_in "Adhaan", with: @prayer.adhaan
    fill_in "Iqaamah", with: @prayer.iqaamah
    fill_in "Masjid", with: @prayer.masjid_id
    fill_in "Name", with: @prayer.name
    click_on "Create Prayer"

    assert_text "Prayer was successfully created"
    click_on "Back"
  end

  test "should update Prayer" do
    visit prayer_url(@prayer)
    click_on "Edit this prayer", match: :first

    fill_in "Adhaan", with: @prayer.adhaan
    fill_in "Iqaamah", with: @prayer.iqaamah
    fill_in "Masjid", with: @prayer.masjid_id
    fill_in "Name", with: @prayer.name
    click_on "Update Prayer"

    assert_text "Prayer was successfully updated"
    click_on "Back"
  end

  test "should destroy Prayer" do
    visit prayer_url(@prayer)
    click_on "Destroy this prayer", match: :first

    assert_text "Prayer was successfully destroyed"
  end
end
