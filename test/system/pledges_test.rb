require "application_system_test_case"

class PledgesTest < ApplicationSystemTestCase
  setup do
    @pledge = pledges(:one)
  end

  test "visiting the index" do
    visit pledges_url
    assert_selector "h1", text: "Pledges"
  end

  test "should create pledge" do
    visit pledges_url
    click_on "New pledge"

    fill_in "Amount", with: @pledge.amount
    fill_in "Contact", with: @pledge.contact_id
    fill_in "Fundraiser", with: @pledge.fundraiser_id
    click_on "Create Pledge"

    assert_text "Pledge was successfully created"
    click_on "Back"
  end

  test "should update Pledge" do
    visit pledge_url(@pledge)
    click_on "Edit this pledge", match: :first

    fill_in "Amount", with: @pledge.amount
    fill_in "Contact", with: @pledge.contact_id
    fill_in "Fundraiser", with: @pledge.fundraiser_id
    click_on "Update Pledge"

    assert_text "Pledge was successfully updated"
    click_on "Back"
  end

  test "should destroy Pledge" do
    visit pledge_url(@pledge)
    click_on "Destroy this pledge", match: :first

    assert_text "Pledge was successfully destroyed"
  end
end
