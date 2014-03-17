require 'model_localizer'
require 'rails'

module ModelLocalizer
  class Railtie < Rails::Railtie
    initializer 'model_localizer.initialize' do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.send :extend, ModelLocalizer
      end
    end
  end
end