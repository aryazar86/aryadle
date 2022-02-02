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
        @timezone = params[:timezone]
        
        if @timezone
            today = Time.now.in_time_zone(@timezone).to_date.yday()
        else
            today = Date.today.yday()
        end

        @current_word = WordLibrary.find(today)
    end
end
