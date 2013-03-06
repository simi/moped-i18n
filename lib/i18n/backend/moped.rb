require 'i18n/backend/base'

module I18n
  module Backend
    class Moped
      module Implementation
        attr_accessor :collection
        include Base, Flatten

        def initialize(collection, options={})
          @collection, @options = collection, options
        end

        def available_locales
          collection.find.distinct(:locale).map {|l| l.to_sym}
        end

        def store_translations(locale, data, options = {})
          escape = options.fetch(:escape, true)
          flatten_translations(locale, data, escape, false).each do |key, value|
            collection.find(:key => key.to_s, :locale => locale.to_s).remove_all
            doc = {:key => key.to_s, :value => value, :locale => locale.to_s}
            collection.insert(doc)
          end
        end

        protected
        def lookup(locale, key, scope = [], options = {})
          key = normalize_flat_keys(locale, key, scope, options[:separator])
          result = collection.find(:locale => locale.to_s, :key => /^#{Regexp.quote(key)}(\.|$)/).entries

          if result.empty?
            nil
          elsif result.first["key"] == key
            result.first["value"]
          else
            chop_range = (key.size + FLATTEN_SEPARATOR.size)..-1
            result = result.inject({}) do |hash, r|
              hash[r["key"].slice(chop_range)] = r["value"]
              hash
            end
            result.deep_symbolize_keys
          end
        end
      end

      include Implementation
    end
  end
end
