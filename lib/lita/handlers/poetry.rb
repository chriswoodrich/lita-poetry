module Lita
  module Handlers
    class Poetry < Handler

      class << self
        attr_reader :lock
      end

      @lock = Mutex.new

      config :strict_mode, types: [TrueClass, FalseClass], default: false

      route(/.+/, :process)

      route %r{^haiku last}i, :get_last_haiku, help: {
        "litabot: haiku last" => "Retreives last saved Haiku"
      }

      route %r{^haiku total}i, :get_total_haikus, help: {
        "litabot: haiku total" => "Retreives total number of saved haikus"
      }

      route %r{^(haiku get) (\d)}i, :get_specific_haiku, help: {
        "litabot: haiku get 5" => "Retreives the 5th saved haiku"
      }

      on(:loaded, :populate)


      def process(request)
        one = two = three = nil

        self.class.lock.synchronize do
          three = {
            'id' => request.message.user.id,
            'count' => process_sentence(request.message.body),
            'text' => request.message.body
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
          save_last_haiku(one, two, three)
          request.reply('Garth, that was a haiku!')
        end
      end

      def save_last_haiku(one, two, three)
        redis.rpush('saved_haikus', one['text'] + "; " + two['text'] + "; " + three['text'])
      end

      def process_sentence(sentence)
        return false if is_uri?(sentence)
        processed_sentence = sentence.gsub("'", "").gsub(",","").gsub(".","")
        words = processed_sentence.split(' ')
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

      def get_last_haiku(request)
        number = redis.llen('saved_haikus')
        if number == 0
          request.reply('Rain falls softly now; it is a sad day when you; have no saved haikus')
        else
          request.reply(redis.lrange('saved_haikus', number - 1, 1).first)
        end
      end

      def get_specific_haiku(request)
        which, extra = request.matches.first.last.to_i, 0
        if which == redis.llen('saved_haikus')
          extra += 1
        elsif which > redis.llen('saved_haikus')
          return
        end
        request.reply(redis.lrange('saved_haikus', which - 1, 1 + extra).first)
      end

      def get_total_haikus(request)
        request.reply("#{redis.llen('saved_haikus')} haikus total")
      end

      def is_uri?(string)
        uri = URI.parse(string)
        %w(http https).include?(uri.scheme) || uri.to_s.include?('www')
      rescue URI::BadURIError
        false
      rescue URI::InvalidURIError
        false
      end

    end
    Lita.register_handler(Poetry)
  end
end
