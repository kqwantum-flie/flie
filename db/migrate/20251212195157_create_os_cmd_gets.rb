class CreateOsCmdGets < ActiveRecord::Migration[8.1]
  def change
    create_table :os_cmd_gets do |t|
      t.belongs_to :os_cmd, null: false, foreign_key: true
      t.belongs_to :os_get, null: false, foreign_key: true
      t.integer :step

      t.timestamps
    end
  end
end
