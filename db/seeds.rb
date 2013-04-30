# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ccq_data = YAML.load(File.open("db/data.yml"))
ccq_data["survey"].each do |survey|
  Survey.create(:title => survey["survey_title"],
                :description => survey["survey_description"])
  survey["questions"].each do |group|
    questions = group["titles"]
    questions.each do |question|
      survey_id = Survey.find_by_title(survey["survey_title"]).id
      q = Question.find_or_initialize_by_choice_group_id_and_survey_id_and_title(group["group_id"], survey_id, question["title"])
      q.save
    end
  end
  survey["groups"].each do |group|
    choices = group["choices"]
    choices.each do |choice|
      c = Choice.find_or_initialize_by_group_id_and_value_and_description(group["id"], choice["value"], choice["description"])
      c.save
    end
  end
end



