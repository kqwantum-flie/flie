class CreateAosPxies < ActiveRecord::Migration[8.1]
  def change
    create_table :aos_pxies do |t|
      t.string :name, null: false, index: true
      t.timestamps
    end
  end
end
