require "application_system_test_case"

class CoversTest < ApplicationSystemTestCase
  setup do
    @cover = covers(:one)
  end

  test "visiting the index" do
    visit covers_url
    assert_selector "h1", text: "Covers"
  end

  test "creating a Cover" do
    visit covers_url
    click_on "New Cover"

    fill_in "Name", with: @cover.name
    click_on "Create Cover"

    assert_text "Cover was successfully created"
    click_on "Back"
  end

  test "updating a Cover" do
    visit covers_url
    click_on "Edit", match: :first

    fill_in "Name", with: @cover.name
    click_on "Update Cover"

    assert_text "Cover was successfully updated"
    click_on "Back"
  end

  test "destroying a Cover" do
    visit covers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Cover was successfully destroyed"
  end
end
