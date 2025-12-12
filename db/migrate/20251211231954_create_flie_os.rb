class CreateFlieOs < ActiveRecord::Migration[8.1]
  def change
    create_table :flie_os do |t|
      t.timestamps
    end
  end
end
