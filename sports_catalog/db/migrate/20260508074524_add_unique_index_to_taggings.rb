class AddUniqueIndexToTaggings < ActiveRecord::Migration[8.1]
  def change
    add_index :taggings, [ :competition_id, :tag_id ], unique: true
  end
end
