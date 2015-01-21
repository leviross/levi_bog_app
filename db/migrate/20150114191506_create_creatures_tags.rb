class CreateCreaturesTags < ActiveRecord::Migration
  def change
    create_table :creatures_tags do |t|
      t.references :creature, index: true
      t.references :tag, index: true

      t.timestamps null: false
    end
    add_foreign_key :creatures_tags, :creatures
    add_foreign_key :creatures_tags, :tags
  end
end
