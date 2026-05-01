class ChangeLocationToTextInCompetitions < ActiveRecord::Migration[8.1]
  def change
    remove_reference :competitions, :location, foreign_key: true

    add_column :competitions, :location_name, :string
  end
end
