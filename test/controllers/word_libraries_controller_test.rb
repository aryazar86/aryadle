require "test_helper"

class WordLibrariesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @word_library = word_libraries(:one)
  end

  test "should get index" do
    get word_libraries_url
    assert_response :success
  end

  test "should get new" do
    get new_word_library_url
    assert_response :success
  end

  test "should create word_library" do
    assert_difference("WordLibrary.count") do
      post word_libraries_url, params: { word_library: {  } }
    end

    assert_redirected_to word_library_url(WordLibrary.last)
  end

  test "should show word_library" do
    get word_library_url(@word_library)
    assert_response :success
  end

  test "should get edit" do
    get edit_word_library_url(@word_library)
    assert_response :success
  end

  test "should update word_library" do
    patch word_library_url(@word_library), params: { word_library: {  } }
    assert_redirected_to word_library_url(@word_library)
  end

  test "should destroy word_library" do
    assert_difference("WordLibrary.count", -1) do
      delete word_library_url(@word_library)
    end

    assert_redirected_to word_libraries_url
  end
end
