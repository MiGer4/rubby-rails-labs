class CreateCompetitions < ActiveRecord::Migration[8.1]
  def change
    create_table :competitions do |t|
      t.string :title
      t.date :start_date
      t.date :end_date
      t.float :prize_fund
      t.integer :status
      t.references :location, null: false, foreign_key: true

      t.timestamps
    end
  end
end
