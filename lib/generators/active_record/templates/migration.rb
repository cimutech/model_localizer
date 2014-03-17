class ModelLocalizerCreate<%= table_name.camelize %> < ActiveRecord::Migration
  def change
    create_table(:<%= table_name %>) do |t|
      t.references :localizable, :polymorphic => true
      t.string :collum_name
      t.string :locale
      t.string :value

      t.timestamps
    end

    add_index :<%= table_name %>,
              [ :resource_type, :resource_id, :column_name, :locale ],
              :unique => true,
              :name => "localizer_ref_index"
  end
end