class GamesController < ApplicationController
    before_action :set_todays_word, only: %i[ guess ]
    
    def index
    end

    def guess
        @attempt = params[:attempt]
        @isDone = @attempt.eql?(@current_word.word)
        @response = @current_word.check( @attempt )
        respond_to do |format|
            # format.html { render :guess, layout: false }
            format.json { render :guess }
        end
    end

    private
    
    def set_todays_word
      @current_word = WordLibrary.find(Date.today.yday())
    end
end
