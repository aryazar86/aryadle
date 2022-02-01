require "test_helper"

class WordLibraryTest < ActiveSupport::TestCase
  test "should not save Word Library without word" do
    word_library = WordLibrary.new
    assert_not word_library.save
  end

  test "should not save Word Library if word is not English" do
    word_library = WordLibrary.new(word: "abcdef")
    assert_not word_library.save
  end

  test "should not save Word Library if word is not 6 characters" do
    word_library = WordLibrary.new(word: "word")
    assert_not word_library.save
  end

  test "should save if word library is 6 characters long and is an actual word" do
    word_library = WordLibrary.new(word: "puzzle")
    assert word_library.save
  end

  test "should save lowercase" do
    word_library = WordLibrary.new(word: "MuZzLe")
    word_library.save
    assert_equal('muzzle', word_library.word)
  end

  test "should not save if word library not unique" do
    word_library = WordLibrary.new(word: "puzzle")
    word_library.save
    word_library2 = WordLibrary.new(word: "puzzle")
    assert_not word_library2.save
  end

  test "should return array of incorrect letters in word" do 
    word_library = WordLibrary.new(word: "puzzle")
    word_library.save
    expected_reponse = [
      {letter: "p", check: "success"}, 
      {letter: "u", check: "success"},
      {letter: "d", check: "danger"},
      {letter: "d", check: "danger"},
      {letter: "l", check: "success"},
      {letter: "e", check: "success"}]
    actual_response = word_library.check("puddle")
    assert_equal(expected_reponse, actual_response)
  end

  test "should return word error" do 
    word_library = WordLibrary.new(word: "puzzle")
    word_library.save
    assert_equal(false, word_library.check("abcdef"))
  end

  test "should discount too many letters" do
    word_library = WordLibrary.new(word: "dabble")
    word_library.save
    expected_reponse = [
      {letter: "b", check:"danger"},
      {letter: "a", check:"success"},
      {letter: "b", check:"success"},
      {letter: "b", check:"success"},
      {letter: "l", check:"success"},
      {letter: "e", check:"success"}]
    actual_response = word_library.check('babble')
    assert_equal(expected_reponse, actual_response)
  end
end
