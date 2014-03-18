ActiveRecord::Schema.define do
  self.verbose = false

  [ :localizers, :translations ].each do |table|
    create_table(table) do |t|
      t.references :localizable, :polymorphic => true
      t.string :column_name
      t.string :locale
      t.string :value

      t.timestamps
    end
  end

  [ :users, :tasks, :customers ].each do |table|
    create_table(table) do |t|
      t.timestamps
    end
  end

end
