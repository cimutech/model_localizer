module ModelLocalizer
  module Configure
    @@locales = {}
    @@orm = "active_record"

    def configure(*localizer_cnames)
      return if !sanity_check(localizer_cnames)
      yield self if block_given?
    end

    def orm
      @@orm
    end

    def orm=(orm)
      @@orm = orm
    end

    def locales
      @@locales
    end

    def locales=(locales)
      @@locales = locales || {}
    end

    private

    def class_check(localizer_cnames)
      localizer_cnames = [ "Localizer" ] if localizer_cnames.empty?
      localizer_cnames.each do |class_name|
        localizer_class = class_name.constantize
        if localizer_class.superclass.to_s == "ActiveRecord::Base" && localizer_table_missing?(localizer_class)
          raise "table '#{class_name}' doesn't exist. Did you run the migration ?"
        end
      end
    end

    def localizer_table_missing?(localizer_class)
      localizer_class.connected? && !localizer_class.table_exists?
    end
  end
end
