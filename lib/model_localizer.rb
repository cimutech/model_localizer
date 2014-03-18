require "model_localizer/version"
require 'model_localizer/configure'
require 'model_localizer/railtie'

module ModelLocalizer
  extend Configure

  def localize(*attributes)
    localizer_class_name = 'Localizer'

    if attributes.last.is_a?(Hash)
      options = attributes.pop()
      localizer_class_name = options[:class_name] if options and options.has_key? :class_name
    end

    localizer_table_name = localizer_class_name.tableize.gsub(/\//, "_")
    localizer_class = class_check(localizer_class_name)

    attributes.each do |attribute|
      attr_s = attribute.to_s
      attrs_s = ActiveSupport::Inflector.pluralize(attr_s)

      has_many "#{attrs_s}".to_sym, {conditions: {column_name: attrs_s}, as: :localizable, class_name: localizer_class_name, dependent: :destroy, autosave: true}

      define_method "set_#{attr_s}" do |*params|
        unless (1..2).include? params.length
          raise ArgumentError.new("wrong number of arguments (#{params.length} for 1 or 2)")
        end
        value = params[0]
        locale = params[1] || I18n.default_locale.to_s
        localized_value = send("#{attrs_s}").where(column_name: attr_s, locale: locale.to_s).first
        localized_value ||= send("#{attrs_s}").build(column_name: attr_s, locale: locale.to_s)
        localized_value.value = value
        localized_value.save
      end

      define_method "get_#{attr_s}" do |*params|
        unless params.length <= 1
          raise ArgumentError.new("wrong number of arguments (#{params.length} for 1)")
        end

        locale = params[0] || I18n.default_locale.to_s

        localized_value = localizer_class.where(localizable_id: self.id, localizable_type: self.class.name, column_name: attr_s, locale: locale.to_s).first
        return localized_value.value unless localized_value.nil?
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
        define_method "#{attr_s}_#{locale.to_s}" do
          send("get_#{attr_s}", locale)
        end
        define_method "#{attr_s}_#{locale.to_s}=" do |*params|
          unless params.length == 1
            raise ArgumentError.new("wrong number of arguments (#{params.length} for 1)")
          end
          send("set_#{attr_s}", params[0], locale)
        end
      end

    end
  end

  # def validates_default_locale(*attributes)
  #   attributes.each do |attribute|
  #     attr_s = attribute.to_s
  #     attrs_s = ActiveSupport::Inflector.pluralize(attr_s)

  #     validates_each "#{attrs_s}".to_sym do |model, attr, value|
  #       valid = false
  #       value.each do |ls|
  #         valid = true if ls.locale == I18n.default_locale.to_s and !ls.value.empty?
  #       end
  #       model.errors.add(attr, "is missing a value for the default locale (#{I18n.default_locale})") unless valid
  #     end
  #   end
  # end

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

end
