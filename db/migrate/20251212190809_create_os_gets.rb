class CreateOsGets < ActiveRecord::Migration[8.1]
  def change
    create_table :os_gets do |t|
      t.string :name
      t.string :prompt
      t.integer :input_type, default: Aro::Mancy::O

      t.timestamps
    end
  end
end
