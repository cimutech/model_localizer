require 'rails/generators/active_record'
require 'active_support/core_ext'

module ActiveRecord
  module Generators
    class ModelLocalizerGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def generate_model
        invoke "active_record:model", [ name ], :migration => false
      end

      def inject_model_localizer_class
        inject_into_class(model_path, class_name, model_content)
      end

      def copy_model_localizer_migration
        migration_template "migration.rb", "db/migrate/model_localizer_create_#{table_name}"
      end

      def model_path
        File.join("app", "models", "#{file_path}.rb")
      end

      def model_content
        content = <<RUBY
  belongs_to :localizable, :polymorphic => true
RUBY
      end
    end
  end
end
