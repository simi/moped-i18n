require File.expand_path('../test_helper', __FILE__)

class I18nMopedApiTest < Test::Unit::TestCase
  def setup
    I18n.backend = I18n::Backend::Moped.new(COLLECTION)
    super
  end

  def self.can_store_procs?
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

  test "make sure we use an Moped backend" do
    assert_equal I18n::Backend::Moped, I18n.backend.class
  end

  test "return only on full hash match" do
    I18n.backend.store_translations(:en, :short_text => 'ABC you know ME')
    assert_raises(I18n::MissingTranslationData) {I18n.translate!(:sh)}
  end

  test "changing current locale" do
    I18n.backend.store_translations(:en, :text => 'Hi')
    I18n.backend.store_translations(:cs, :text => 'Zdary')

    original = I18n.locale

    I18n.locale = :en
    assert_equal 'Hi', I18n.t(:text)

    I18n.locale = :cs
    assert_equal 'Zdary', I18n.t(:text)

    I18n.locale = original
  end
end
