class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email_address, null: false
      t.string :password_digest, null: false
      t.integer :status, default: Aro::Mancy::O
      t.string :verification_token, index: true

      t.timestamps
    end
    add_index :users, :email_address, unique: true
  end
end
