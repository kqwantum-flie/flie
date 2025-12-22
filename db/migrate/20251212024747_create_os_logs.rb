class CreateOsLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :os_logs do |t|
      t.belongs_to :flie_o, null: false, foreign_key: true
      t.string :in

      t.timestamps
    end
  end
end
