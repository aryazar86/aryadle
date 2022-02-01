class AddLetterCountToWordLibraries < ActiveRecord::Migration[7.0]
  def change
    add_column :word_libraries, :word_count, :text
  end
end
