class CreateMatches < ActiveRecord::Migration[6.0]
  def change
    create_table :matches do |t|
      t.integer :sport_id
      t.integer :opponent_id
      t.integer :location_id
      t.datetime :start_date
      t.datetime :end_date
      t.string :score
      t.string :result
      t.integer :user_id
    end

    create_table :match_racquets do |t|
      t.integer :match_id
      t.integer :racquet_id
    end
  end
end
