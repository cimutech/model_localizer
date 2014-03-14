source "https://rubygems.org"

group :test do
  case ENV["ADAPTER"]
  when nil, "active_record"
    gem "sqlite3", :platform => "ruby"
    gem "activerecord", ">= 3.2.0", :require => "active_record"
  else
    raise "Unknown model adapter: #{ENV["ADAPTER"]}"
  end
end

gemspec
