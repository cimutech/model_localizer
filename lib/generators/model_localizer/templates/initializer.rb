Rolify.configure<%= "(\"#{class_name.camelize.to_s}\")" if class_name != "Localizer" %> do |config|
  # set the locales support by application
  # config.locales = [:en, :zh-CN]
end