class CreateOuts < ActiveRecord::Migration[6.0]
  def change
    create_table :outs do |t|
      t.string :name
      t.integer :number
      t.boolean :active
      t.string :typeof
      t.string :string

      t.timestamps
    end
  end
end
