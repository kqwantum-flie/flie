class CreateOsCmds < ActiveRecord::Migration[8.1]
  def change
    create_table :os_cmds do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.integer :access, default: Aro::Mancy::O

      t.timestamps
    end
  end
end
