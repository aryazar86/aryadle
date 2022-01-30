class WordLibrary < ApplicationRecord
    include ActiveModel::Validations

    validates :word, uniqueness: true
    validates :word, length: { is: 6 }
    validate :is_actual_word
    before_save :downcase_fields

    def check(attempt) 
        dictionary = Dictionary.from_file('app/assets/word_list.txt')
        if dictionary.exists?(attempt)
            response = []
            attempt.split('').each_with_index { |a, index|
                if a == self.word[index]
                    check = 'success'
                elsif self.word.include? a
                    check = 'warning'
                else
                    check = 'danger'
                end
                response[index] = {letter: a, check: check}
            }
        else
            response = false
        end
        
        return response
    end
    
    def is_actual_word
        dictionary = Dictionary.from_file('app/assets/word_list.txt')
        errors.add(:base, 'Must be an English word, please') unless dictionary.exists?(word)
    end
    
    def downcase_fields
        self.word.downcase!
    end

end
