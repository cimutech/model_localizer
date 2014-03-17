
module ModelLocalizer
  module Generators
    class ModelLocalizerGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __FILE__)

      hook_for :orm, :required => true

      desc "Generates a model with the given NAME and a migration file."

      def copy_initializer_file
        template "initializer.rb", "config/initializers/model_localizer.rb"
      end
    end
  end
end
