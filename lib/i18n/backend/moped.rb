module I18n
  module Backend
    class Moped
      attr_reader :collection

      def initialize(collection, options={})
        @collection, @options = collection, options
      end

      def []=(key, value, options = {})
        key = key.to_s
        doc = {:_id => key, :value => value}
        collection.find(:_id => key).remove_all
        collection.insert(doc)
      end

      # alias for read
      def [](key, options=nil)
        if doc = collection.find(:_id => key.to_s).one
          doc["value"].to_s
        end
      end

      def keys
        collection.find.to_a.collect{|h| h["_id"]}
      end

      def del(key)
        collection.find({:_id => key}).remove_all
      end

      # Thankfully borrowed from Jodosha's redis-store
      # https://github.com/jodosha/redis-store/blob/master/lib/i18n/backend/redis.rb
      def available_locales
        locales = self.keys.map { |k| k =~ /\./; $` }
        locales.uniq!
        locales.compact!
        locales.map! { |k| k.to_sym }
        locales
      end
    end
  end
end
