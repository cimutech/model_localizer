require "model_localizer/version"
require 'model_localizer/configure'
require 'model_localizer/railtie'

module ModelLocalizer
  extend Configure

  def localize(*attributes)
    localizer_class_name = 'Localizer'

    if attributes.last.is_a?(Hash)
      options = attributes.pop()
      localizer_class_name = options[:localizer] if options and options.has_key? :localizer
    end

    localizer_table_name = localizer_class_name.tableize.gsub(/\//, "_")
    localizer_class = class_check(localizer_class_name)


    class_eval <<-RUBY, __FILE__, __LINE__+1
      def localizer_list
        @localizer_list ||= {}
      end
    RUBY

    attributes.each do |attribute|
      attr_s = attribute.to_s
      attrs_s = ActiveSupport::Inflector.pluralize(attr_s)

      has_many "#{attrs_s}".to_sym, {conditions: {column_name: attr_s}, as: :localizable, class_name: localizer_class_name, dependent: :destroy, autosave: true}

      define_method "set_#{attr_s}" do |*params|
        unless (1..2).include? params.length
          raise ArgumentError.new("wrong number of arguments (#{params.length} for 1 or 2)")
        end
        value = params[0]
        locale = params[1] || I18n.default_locale.to_s
        localizer_list["#{attr_s}"] ||= {}
        localizer_list["#{attr_s}"]["#{locale}"] = value
      end

      define_method "get_#{attr_s}" do |*params|
        unless params.length <= 1
          raise ArgumentError.new("wrong number of arguments (#{params.length} for 1)")
        end

        locale = params[0] || I18n.default_locale.to_s
        localizer_list["#{attr_s}"] ||= {}

        return localizer_list["#{attr_s}"]["#{locale}"] if localizer_list["#{attr_s}"]["#{locale}"]

        localized_value = localizer_class.where(localizable_id: self.id, localizable_type: self.class.name, column_name: attr_s, locale: locale.to_s).first
        return localizer_list["#{attr_s}"]["#{locale}"] = localized_value.value unless localized_value.nil?
        send("get_#{attr_s}") if localized_value.nil? and locale.to_s != I18n.default_locale.to_s
      end

      define_method "#{attr_s}=" do |*params|
        unless params.length == 1
          raise ArgumentError.new("wrong number of arguments (#{params.length} for 1)")
        end
        send("set_#{attr_s}", params[0], I18n.locale.to_s)
      end

      define_method "#{attr_s}" do
        send("get_#{attr_s}", I18n.locale.to_s)
      end

      ModelLocalizer.locales.each do |locale|
        func_tail = locale_to_tail(locale)
        define_method "#{attr_s}_#{func_tail}" do
          send("get_#{attr_s}", locale)
        end
        define_method "#{attr_s}_#{func_tail}=" do |*params|
          unless params.length == 1
            raise ArgumentError.new("wrong number of arguments (#{params.length} for 1)")
          end
          send("set_#{attr_s}", params[0], locale)
        end
      end
    end

    before_save :localize_all_attributes

    define_method "localize_all_attributes" do
      localizer_list.each do |column_name, locale_data|
        locale_data.each do |locale, value|
          attrs_s = ActiveSupport::Inflector.pluralize(column_name)
          localized_value = send("#{attrs_s}").where(column_name: column_name, locale: locale).first_or_create
          localized_value.value = value
          send("#{attrs_s}") << localized_value
        end
      end
    end
  end

  private

  def class_check(class_name)
    localizer_class = class_name.constantize
    if localizer_class.superclass.to_s == "ActiveRecord::Base" && localizer_table_missing?(localizer_class)
      raise "table '#{class_name}' doesn't exist. Did you run the migration ?"
    end
    localizer_class
  end

  def localizer_table_missing?(localizer_class)
    localizer_class.connected? && !localizer_class.table_exists?
  end

  def locale_to_tail(locale)
    locale.to_s.sub('-', '_').downcase
  end

end
