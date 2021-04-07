class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.string :payer
      t.integer :points
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
