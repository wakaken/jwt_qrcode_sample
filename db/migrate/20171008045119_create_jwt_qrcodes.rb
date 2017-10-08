class CreateJwtQrcodes < ActiveRecord::Migration[5.1]
  def change
    create_table :jwt_qrcodes do |t|
      t.string :jwt
      t.string :data
      t.string :user_id

      t.timestamps
    end
  end
end
