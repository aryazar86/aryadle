class WordLibrary < ApplicationRecord
    include ActiveModel::Validations
    serialize :word_count

    validates :word, uniqueness: true
    validates :word, length: { is: 6 }
    validate :is_actual_word
    before_save :downcase_fields
    before_save :create_word_count

    def check(attempt) 
        dictionary = Dictionary.from_file('app/assets/word_list.txt')
        if dictionary.exists?(attempt)
            response = []
            attempt_count = Hash.new(0)
            attempt.split('').each_with_index { |a, index|
                if a == self.word[index]
                    check = 'success'
                elsif self.word.include? a
                    check = 'warning'
                else
                    check = 'danger'
                end
                response[index] = {letter: a, check: check}
                attempt_count[a] += 1
            }

            self.word_count.each do |letter, count|
                if attempt_count[letter] && attempt_count[letter] > count
                    temp_count = attempt_count[letter]
                    response.each do |r, index|
                        if temp_count > count
                            if r[:letter] == letter && r[:check] != "success"
                                r[:check] = 'danger'
                                temp_count -= 1
                            end
                        end
                    end
                end
            end

        else
            response = false
        end
      
        return response
    end
    
    def is_actual_word
        if word 
            dictionary = Dictionary.from_file('app/assets/word_list.txt')
            errors.add(:base, 'Must be an English word, please') unless dictionary.exists?(word)
        else
            errors.add(:base, "There's no word...")
        end
    end
    
    def downcase_fields
        self.word.downcase!
    end

    def create_word_count
        word_count = Hash.new(0)
        self.word.chars.each do |v|
            word_count[v] += 1
        end
        self.word_count = word_count
    end

end
