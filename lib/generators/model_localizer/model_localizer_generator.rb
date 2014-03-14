
module ModelLocalizer
  module Generators
    class ModelLocalizerGenerator < Rails::Generators::NamedBase
      Rails::Generators::ResourceHelpers

      source_root File.expand_path('../templates', __FILE__)

      hook_for :orm, :required => true

      desc "Generates a model with the given NAME and a migration file."

      def show_readme
        if behavior == :invoke
          readme "README"
        end
      end
    end
  end
end
