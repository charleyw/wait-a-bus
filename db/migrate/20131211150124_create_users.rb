class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :open_id
      t.string :city
    end
  end

  def down
    drop :users
  end
end
