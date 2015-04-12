module Lita
  module Handlers
    class Poetry < Handler

      class << self
        attr_reader :lock
      end

      @lock = Mutex.new

      config :strict_mode, types: [TrueClass, FalseClass], default: false

      route(/.+/, :process)
      on(:loaded, :populate)


      def process(request)
        one = two = three = nil

        self.class.lock.synchronize do
          three = {
            'id' => request.message.user.id,
            'count' => process_sentence(request.message.body)
          }

          redis.lpop('data')
          one, two = redis.lrange('data', 0, 2)
          redis.rpush('data', MultiJson.dump(three))
        end


        return if one.nil? || two.nil?

        one = MultiJson.load(one)
        two = MultiJson.load(two)

        if config.strict_mode == true
          return unless one['id'] == two['id'] && two['id'] == three['id']
        end

        if one['count'] == 5 && two['count'] == 7 && three['count'] == 5
          request.reply('Garth, that was a haiku!')
        end
      end

      def process_sentence(sentence)
        sentence.gsub!("'", "")
        sentence.gsub!(",","")
        sentence.gsub!(".","")
        words = sentence.split(' ')
        return words.map{|word| count_syllables(word)}.inject(:+)
      end


      def count_syllables(word)

        word.downcase!
        return 1 if word.length <= 3
        word.sub!(/(?:[^laeiouy]es|ed|[^laeiouy]e)$/, '')
        word.sub!(/^y/, '')
        word.scan(/[aeiouy]{1,2}/).size

      end

      def populate payload

        self.class.lock.synchronize do
          length = redis.llen('data')

          (3 - length).times do
            redis.rpush('data', MultiJson.dump({'id' => 0, 'count' => 0 }))
          end
        end
      end
    end
    Lita.register_handler(Poetry)
  end
end
