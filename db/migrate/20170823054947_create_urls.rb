class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :original_url
      t.string :shortened_url
      t.integer :visit_count

      t.timestamps null: false
    end
  end
end
