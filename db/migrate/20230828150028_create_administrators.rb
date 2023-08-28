class CreateAdministrators < ActiveRecord::Migration[7.0]
  def change
    create_table :administrators, id: :uuid do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end
