class WordLibrariesController < ApplicationController
  http_basic_authenticate_with name: ENV["user"], password: ENV["pass"]

  before_action :set_word_library, only: %i[ show edit update destroy ]

  # GET /word_libraries or /word_libraries.json
  def index
    @word_libraries = WordLibrary.all
  end

  # GET /word_libraries/1/edit
  def edit
  end

  # PATCH/PUT /word_libraries/1 or /word_libraries/1.json
  def update
    respond_to do |format|
      if @word_library.update(word_library_params)
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(@word_library)
        end
        format.html { redirect_to word_library_url(@word_library), notice: "Word library was successfully updated." }
        format.json { render :show, status: :ok, location: @word_library }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @word_library.errors, status: :unprocessable_entity }
      end
    end
  end


  def create_random_list
    WordLibrary.delete_all
    WordLibrary.reset_pk_sequence
    random_words = File.readlines("app/assets/word_list.txt").sample(365)
    random_words.each do |word|
      word_library = WordLibrary.create!(word: word.gsub(/\s+/, ""))
    end

    redirect_to word_libraries_path
  end

  # # GET /word_libraries/1 or /word_libraries/1.json
  # def show
  # end

  # # GET /word_libraries/new
  # def new
  #   @word_library = WordLibrary.new
  # end

  # # POST /word_libraries or /word_libraries.json
  # def create
  #   @word_library = WordLibrary.new(word_library_params)

  #   respond_to do |format|
  #     if @word_library.save
  #       format.turbo_stream do
  #         render turbo_stream: turbo_stream.append(:word_libraries, partial: "word_libraries/word_library",
  #           locals: { word_library: @word_library })
  #       end
  #       format.html { redirect_to word_libraries_path(@word_library), notice: "Word library was successfully created." }
  #       format.json { render :show, status: :created, location: @word_library }
  #     else
  #       format.html { render :new, status: :unprocessable_entity }
  #       format.json { render json: @word_library.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /word_libraries/1 or /word_libraries/1.json
  # def destroy
  #   @word_library = WordLibrary.find(params[:id])
  #   @word_library.destroy

  #   respond_to do |format|
  #     format.turbo_stream { render turbo_stream: turbo_stream.remove(@word_library) }
  #     format.html { redirect_to word_libraries_url, notice: "Word library was successfully destroyed." }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word_library
      @word_library = WordLibrary.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def word_library_params
      params.require(:word_library).permit(:word)
    end
end
