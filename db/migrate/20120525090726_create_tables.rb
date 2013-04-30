class CreateTables < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string    :email,                :null => false, :default => ""
      t.string    :encrypted_password,   :null => false, :default => ""
      t.string    :reset_password_token
      t.datetime  :reset_password_sent_at
      t.datetime  :remember_created_at
      t.integer   :sign_in_count,        :default => 0
      t.datetime  :current_sign_in_at
      t.datetime  :last_sign_in_at
      t.string    :current_sign_in_ip
      t.string    :last_sign_in_ip
      t.string    :first_name,          :null => false
      t.string    :last_name,           :null => false
      t.string    :gender,              :null => false
      t.string    :address,             :null => false
      t.string    :phone,               :null => false
      t.string    :schedule,            :null => false
      t.string    :notification_method, :null => false
      t.string    :results_token

      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true

    create_table :answers do |t|
      t.integer :user_survey_id
      t.integer :question_id
      t.float   :pick

      t.timestamps
    end

    add_index :answers, :user_survey_id
    add_index :answers, :question_id

    create_table :choices do |t|
      t.integer   :group_id
      t.string    :description
      t.integer   :value

      t.timestamps
    end

    add_index :choices, :group_id

   create_table :questions do |t|
      t.integer :survey_id
      t.string  :title
      t.integer :choice_group_id

      t.timestamps
   end

   add_index :questions, :survey_id
   add_index :questions, :choice_group_id

   create_table :surveys do |t|
     t.string   :title
     t.text     :description

     t.timestamps
   end

   create_table :user_surveys do |t|
     t.integer  :user_id
     t.integer  :survey_id
     t.date     :starting_date
     t.date     :next_schedule
     t.string   :schedule
     t.string   :status
     t.string   :language
     t.string   :version

     t.timestamps
   end

   add_index :user_surveys, :user_id
   add_index :user_surveys, :survey_id

  end

end
