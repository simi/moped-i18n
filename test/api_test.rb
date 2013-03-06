require File.expand_path('../test_helper', __FILE__)

class I18nMopedApiTest < Test::Unit::TestCase
  def setup
    I18n.backend = I18n::Backend::Moped.new(COLLECTION)
    super
  end

  def self.can_store_procs?
    # I18n::Backend::ActiveRecord.included_modules.include?(I18n::Backend::ActiveRecord::StoreProcs)
    false
  end

  include I18n::Tests::Basics
  include I18n::Tests::Defaults
  include I18n::Tests::Interpolation
  include I18n::Tests::Link
  include I18n::Tests::Lookup
  include I18n::Tests::Pluralization
  include I18n::Tests::Procs if can_store_procs?

  include I18n::Tests::Localization::Date
  include I18n::Tests::Localization::DateTime
  include I18n::Tests::Localization::Time
  include I18n::Tests::Localization::Procs if can_store_procs?

  test "make sure we use an ActiveRecord backend" do
    assert_equal I18n::Backend::Moped, I18n.backend.class
  end
end
