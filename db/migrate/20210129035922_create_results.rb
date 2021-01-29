class CreateResults < ActiveRecord::Migration[6.0]
  def change
    create_table :results do |t|
      t.string :name
      t.integer :order
    end

    Result.create(:name => "Win", :order => 1)
    Result.create(:name => "Tie", :order => 2)
    Result.create(:name => "Loss", :order => 3)
    Result.create(:name => "Unfinished", :order => 4)
  end
end
