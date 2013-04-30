module ResultsHelper
  def generate_graph(graph, user)
    data = Hash.new
    user_surveys = UserSurvey.get_current_user_surveys(user.id).group_by{ |t| t.starting_date}
    lastdate = ((user_surveys.keys).last).to_time.to_i * 1000
    user_surveys.each do |day,survey_in_day|
    answers = Array.new
      survey_in_day.each do |survey|
        ans = Answer.find_all_by_user_survey_id(survey.id).map(&:pick)
        ans = ans.inject(0,:+)/10.0
        answers.push(ans)
      end
       sumans = answers.inject(0,:+)/(answers.count + 0.0)
       timestamp = day.to_time.to_i * 1000
       data[timestamp] = sumans
    end

      now = DateTime.now.to_i * 1000
      javascript_tag("timestamp ="+data.to_json+";")+
    if graph.eql? "per_week"
      content_tag :div do
        javascript_tag("per_week("+now.to_json+")")
      end
    elsif graph.eql? "per_month"
      content_tag :div do
        javascript_tag "per_month("+now.to_json+")"
      end
    elsif graph.eql? "all_the_time"
      content_tag :div do
        javascript_tag "all_the_time("+now.to_json+","+lastdate.to_json+")"
      end
    end
  end

  def insert_select_box(type, user)
    dropdown_name = ""
    options = Array.new
    if type.eql? "per_week"
      dropdown_name = :week
      options = evaluate_date(type, user)
    elsif type.eql? "per_month"
      dropdown_name = :month
      options = evaluate_date(type, user)
    end
    unless type.eql? "all_the_time"
      select_tag(dropdown_name, options_for_select(options) ,:style => "width:180px")
    end
  end


  def evaluate_date(kind, user)
      interval = 0
      if kind.eql? "per_week"
        interval = 7
      elsif kind.eql? "per_month"
        interval = 31
      end
      week_gap = Array.new
      user_surveys = UserSurvey.where('user_id =? AND status =?',user.id,'Complete')
                               .map(&:starting_date).sort
      unless user_surveys.empty?
        lastdate = user_surveys.first
      else
        lastdate = DateTime.now.to_date
      end

      currdate = DateTime.now.to_date
      mindate  = currdate - interval.days
      value = 1
      begin
        if kind.eql? "per_week"
          display =" #{mindate.strftime('%b-%d-%a')} -  #{currdate.strftime('%b-%d-%a')}"
        elsif kind.eql? "per_month"
          display =" #{mindate.strftime('%b-%d-%a')} -  #{currdate.strftime('%b-%d-%a')}"
        end
        week_item = Array.new
        week_item.push(display)
        week_item.push(currdate.to_time.to_i * 1000)
        week_gap.push(week_item)
        currdate = mindate;
        mindate = mindate - interval.days
        value+=1
      end while(lastdate < currdate)
      week_gap
  end

  def get_result_print_info
    content_tag(:span) do
      content_tag(:br) +
      content_tag(:div, "Name: #{current_user.first_name} #{current_user.last_name}") +
      content_tag(:div, "Email: #{current_user.email}") +
      content_tag(:div, "Date Printed: #{Time.now.ctime}")
    end

  end

end
