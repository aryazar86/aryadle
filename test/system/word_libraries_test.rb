require "application_system_test_case"

class WordLibrariesTest < ApplicationSystemTestCase
  setup do
    @word_library = word_libraries(:one)
  end

  test "visiting the index" do
    visit word_libraries_url
    assert_selector "h1", text: "Word libraries"
  end

  test "should create word library" do
    visit word_libraries_url
    click_on "New word library"

    click_on "Create Word library"

    assert_text "Word library was successfully created"
    click_on "Back"
  end

  test "should update Word library" do
    visit word_library_url(@word_library)
    click_on "Edit this word library", match: :first

    click_on "Update Word library"

    assert_text "Word library was successfully updated"
    click_on "Back"
  end

  test "should destroy Word library" do
    visit word_library_url(@word_library)
    click_on "Destroy this word library", match: :first

    assert_text "Word library was successfully destroyed"
  end
end
