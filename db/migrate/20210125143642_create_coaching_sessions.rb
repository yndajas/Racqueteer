class CreateCoachingSessions < ActiveRecord::Migration[6.0]
  def change
    create_table :coaching_sessions do |t|
      t.integer :sport_id
      t.integer :location_id
      t.datetime :date
      t.string :focus
      t.string :notes
      t.integer :user_id
    end

    create_table :coaching_session_coaches do |t|
      t.integer :coaching_session_id
      t.integer :coach_id
    end
  end
end
