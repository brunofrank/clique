class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.references :owner, index: true, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
