class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :open_id
      t.belongs_to :city
    end

    create_table :cities do |t|
      t.string :name
    end

  end

  def down
  end
end
