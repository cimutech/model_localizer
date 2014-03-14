require 'generators_helper'

# Generators are not automatically loaded by Rails
require 'generators/model_localizer/model_localizer_generator'

describe ModelLocalizer::Generators::ModelLocalizerGenerator, :if => ENV['ADAPTER'] == 'active_record' do
  # Tell the generator where to put its output (what it thinks of as Rails.root)
  destination File.expand_path("../../../../tmp", __FILE__)
  teardown :cleanup_destination_root

  before {
    prepare_destination
  }

  def cleanup_destination_root
    FileUtils.rm_rf destination_root
  end

  describe 'specifying only Localizer class name' do
    before(:all) { arguments %w(Localizer) }

    before {
      run_generator
    }

    describe 'app/models/localizer.rb' do
      subject { file('app/models/localizer.rb') }
      it { should exist }
      it { should contain "class Localizer < ActiveRecord::Base" }
      it { should contain "belongs_to :localizable, :polymorphic => true" }
    end

    describe 'migration file' do
      subject { migration_file('db/migrate/model_localizer_create_localizers.rb') }

      it { should be_a_migration }
      it { should contain "create_table(:localizers) do" }
    end
  end

end
