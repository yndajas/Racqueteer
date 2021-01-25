class CreateRacquets < ActiveRecord::Migration[6.0]
  def change
    create_table :racquets do |t|
      t.integer :frame_brand_id
      t.integer :frame_model_id
      t.integer :string_brand_id
      t.integer :string_model_id
      t.integer :sport_id
      t.integer :user_id
    end

    create_table :frame_brands do |t|
      t.string :name
      t.integer :user_id
    end

    create_table :frame_models do |t|
      t.string :name
      t.integer :user_id
    end

    create_table :string_brands do |t|
      t.string :name
      t.integer :user_id
    end

    create_table :string_models do |t|
      t.string :name
      t.integer :user_id
    end
  end
end
