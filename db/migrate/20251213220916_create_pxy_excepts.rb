class CreatePxyExcepts < ActiveRecord::Migration[8.1]
  def change
    create_table :pxy_excepts do |t|
      t.belongs_to :aos_pxy, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      t.string :cmd

      t.timestamps
    end
  end
end
