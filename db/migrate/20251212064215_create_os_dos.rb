class CreateOsDos < ActiveRecord::Migration[8.1]
  def change
    create_table :os_dos do |t|
      t.belongs_to :flie_o, null: false, foreign_key: true
      t.belongs_to :os_cmd, null: false, foreign_key: true
      t.belongs_to :os_get, null: false, foreign_key: true
      t.belongs_to :aos_pxy, null: false, foreign_key: true
      t.integer :status, default: Aro::Mancy::O
      t.string :input
      t.boolean :doing, default: false

      t.timestamps
    end
  end
end
