class CreateFlieOs < ActiveRecord::Migration[8.1]
  def change
    create_table :flie_os do |t|
      t.integer :width, default: Aro::Mancy::O, null: false
      t.timestamps
    end
  end
end
