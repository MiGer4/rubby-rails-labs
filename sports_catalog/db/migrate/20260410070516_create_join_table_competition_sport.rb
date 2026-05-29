class CreateJoinTableCompetitionSport < ActiveRecord::Migration[8.1]
  def change
    create_join_table :competitions, :sports do |t|
      # t.index [:competition_id, :sport_id]
      # t.index [:sport_id, :competition_id]
    end
  end
end
