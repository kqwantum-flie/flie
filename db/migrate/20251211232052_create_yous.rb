class CreateYous < ActiveRecord::Migration[8.1]
  def change
    create_table :yous do |t|
      # belongs to is doing this =>add_index :yous, :flie_o_id
      # belongs to is doing this =>add_index :yous, :user_id
      t.belongs_to :flie_o, null: false, foreign_key: true
      t.belongs_to :user, foreign_key: true
      t.string :pwd, null: false

      t.timestamps
    end

    add_index :yous, :pwd
    change_column_default :yous, :pwd, "/"
  end
end
