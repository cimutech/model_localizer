require 'active_record'

RSpec::Matchers::OperatorMatcher.register(ActiveRecord::Relation, '=~', RSpec::Matchers::BuiltIn::MatchArray)
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Base.extend ModelLocalizer

load File.dirname(__FILE__) + '/../schema.rb'

class Localizer < ActiveRecord::Base
  belongs_to :localizable, :polymorphic => true
end

class Translation < ActiveRecord::Base
  belongs_to :localizable, :polymorphic => true
end

class User < ActiveRecord::Base
  localize :name
end

class Customer < ActiveRecord::Base
  localize :name, {localizer: "Translation"}
end

class Task < ActiveRecord::Base
  localize :title, :description, {localizer: "Translation"}
end