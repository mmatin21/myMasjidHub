require "application_system_test_case"

class FundraisersTest < ApplicationSystemTestCase
  setup do
    @fundraiser = fundraisers(:one)
  end

  test "visiting the index" do
    visit fundraisers_url
    assert_selector "h1", text: "Fundraisers"
  end

  test "should create fundraiser" do
    visit fundraisers_url
    click_on "New fundraiser"

    fill_in "Description", with: @fundraiser.description
    fill_in "End date", with: @fundraiser.end_date
    fill_in "Goal amount", with: @fundraiser.goal_amount
    fill_in "Masjid", with: @fundraiser.masjid_id
    fill_in "Name", with: @fundraiser.name
    click_on "Create Fundraiser"

    assert_text "Fundraiser was successfully created"
    click_on "Back"
  end

  test "should update Fundraiser" do
    visit fundraiser_url(@fundraiser)
    click_on "Edit this fundraiser", match: :first

    fill_in "Description", with: @fundraiser.description
    fill_in "End date", with: @fundraiser.end_date
    fill_in "Goal amount", with: @fundraiser.goal_amount
    fill_in "Masjid", with: @fundraiser.masjid_id
    fill_in "Name", with: @fundraiser.name
    click_on "Update Fundraiser"

    assert_text "Fundraiser was successfully updated"
    click_on "Back"
  end

  test "should destroy Fundraiser" do
    visit fundraiser_url(@fundraiser)
    click_on "Destroy this fundraiser", match: :first

    assert_text "Fundraiser was successfully destroyed"
  end
end
