class CreateTbufs < ActiveRecord::Migration[8.1]
  def change
    create_table :tbufs do |t|
      t.belongs_to :flie_o, null: false
      t.integer :status, default: Aro::Mancy::O
      t.string :real_path
      t.string :ted_path

      t.timestamps
    end
  end
end
