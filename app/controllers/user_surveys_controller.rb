class UserSurveysController < ApplicationController
  before_filter :authenticate_user!

  def new
    @survey = Survey.find(params[:survey_id])
    @user_survey = UserSurvey.new
    @questions = Question.by_survey_id(params[:survey_id]).sort.group_by(&:choice_group_id)
    @ans = params[:ans]
  end

  def create
    @user = User.find(current_user.id)
    starting_date = Date.parse(params[:starting_date])
    schedule = @user.schedule.eql?("weekly") ? starting_date + 1.week : starting_date + 1.month
    generate_ccq(starting_date, schedule, params[:ans])
    while schedule <= Time.now.to_date
      starting_date = schedule
      schedule = @user.schedule.eql?("weekly") ? schedule + 1.week : schedule + 1.month
      generate_ccq(starting_date, schedule, nil)
    end
    redirect_to home_path, :notice => "CCQ saved! You will be notified #{@user.schedule}."
  end

  def generate_ccq(starting_date, schedule, ans)
    @user_survey = @user.user_surveys.create(:language => params[:language],
                                             :schedule => @user.schedule,
                                             :version => params[:version],
                                             :starting_date => starting_date.to_s,
                                             :next_schedule => schedule,
                                             :survey_id => params[:survey_id])
    status = 0
    Question.by_survey_id(params[:survey_id]).count.times do |x|
      if ans
        pick = ans["#{x+1}"]
        if pick
          pick.each do |p|
            @user_survey.answers.create(:question_id => x+1 , :pick => p)
          end
          status += 1
        else
          @user_survey.answers.create(:question_id => x+1 , :pick => nil)
        end
      else
        @user_survey.answers.create(:question_id => x+1 , :pick => nil)
      end
    end
    @user_survey.set_status(status)
  end

  def destroy
  end

  def index
  end

  def show
    @user_survey = UserSurvey.find(params[:id])
    @survey = @user_survey.survey
    @questions = Question.by_survey_id(@survey.id).group_by(&:choice_group_id)
    @ans = @user_survey.answers
    @ccq_total_score = 0.0
    @symptom = 0.0
    @functional_state = 0.0
    @mental_state = 0.0
    @ans.each do |a|
      unless a.pick.nil?
        @ccq_total_score += a.pick
        q_id = a.question_id
        if q_id == 1 || q_id == 2 || q_id == 5 || q_id == 6
          @symptom += a.pick
        elsif q_id >= 7 && q_id <= 10
          @functional_state += a.pick
        else
          @mental_state += a.pick
        end
      end
    end
    @ccq_total_score /= 10
    @symptom /= 4
    @functional_state /= 4
    @mental_state /= 2
    render :layout => false
  end

  def edit
    @user_survey = UserSurvey.find(params[:id])
    @survey = @user_survey.survey
    @questions = Question.by_survey_id(@survey.id).group_by(&:choice_group_id)
    @ans = @user_survey.answers
  end

  def update
    @user_survey = UserSurvey.find(params[:id])
    ans = params[:ans]
    params[:ans].each do |question_id, answer_value|
      answer_value.each do |pick|
        @user_survey.answers.find_by_question_id(question_id).update_attribute(:pick, pick)
      end
    end
    status = 0
    @user_survey.answers.each do |a|
      (a.pick.nil?)? status : status += 1
    end
    @user_survey.set_status(status)
    redirect_to root_path, :notice => "CCQ has been updated!"
  end

end
