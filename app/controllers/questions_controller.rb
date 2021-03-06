class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user,  only: [:index, :show, :new, :edit, :create, :update, :destroy]
  before_action :user_creator,  only: [:index, :show, :new, :edit, :create, :update, :destroy]
  include SessionHelper

  # GET /questions
  # GET /questions.json
  def index
    @questions = Question.all
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
  end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(question_params)
    categories = params[:question][:category_ids]
    if !categories.nil? && !categories.empty?
      categories.each do |category_id|
        category = Category.find(category_id)
        if !category.nil?
          @question.categories << category
        end
      end
    end

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_url, notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:question, :answer_correct, :answer_wrong_1, :answer_wrong_2, :answer_wrong_3, :rating, :category_ids => [])
    end

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        flash[:negative] = "Please log in."
        redirect_to login_url
      end
    end

    def user_creator
      redirect_to root_url unless current_user.creator?
    end
end
