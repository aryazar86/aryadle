class AddLetterCountToWordLibraries < ActiveRecord::Migration[7.0]
  def change
    create_table :word_libraries do |t|
      t.string "word"
      t.text "word_count"
      
      t.timestamps
    end
  end
end
