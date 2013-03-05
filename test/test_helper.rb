
# Do not load the i18n gem from libraries like active_support.
#
# This is required for testing against Rails 2.3 because active_support/vendor.rb#24 tries
# to load I18n using the gem method. Instead, we want to test the local library of course.
require 'bundler/setup'
require 'i18n'
require 'moped/i18n'
require 'test_declarative'
require 'test/unit'
require 'mocha/setup'


def database_id
  "moped_i18n_test"
end

@@session = Moped::Session.new(["127.0.0.1:27017"])
@@session.use(database_id)

COLLECTION = @@session["i18n"]

class Test::Unit::TestCase

  # TODO poor's man moped DB cleaner
  def truncate_test_db
    collections = @@session['system.namespaces'].find(:name => { '$not' => /system|\$/ }).to_a.map do |collection|
      _, name = collection['name'].split('.', 2)
      name
    end
    collections.each { |c| @@session[c].find.remove_all }
  end

  def setup
    truncate_test_db
  end

  def teardown
    I18n.locale = nil
    I18n.default_locale = :en
    I18n.load_path = []
    I18n.available_locales = nil
    I18n.backend = nil
    truncate_test_db
  end

  def translations
    I18n.backend.instance_variable_get(:@translations)
  end

  def store_translations(*args)
    data   = args.pop
    locale = args.pop || :en
    I18n.backend.store_translations(locale, data)
  end
end

Object.class_eval do
  def meta_class
    class << self; self; end
  end
end unless Object.method_defined?(:meta_class)
