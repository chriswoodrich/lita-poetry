module Lita
  module Handlers
    class Poetry < Handler

      class << self
        attr_reader :lock
      end

      @lock = Mutex.new

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

        return unless one['id'] == two['id'] && two['id'] == three['id']
        if one['count'] == 5 && two['count'] == 7 && three['count'] == 5
          request.reply('Garth, that was a haiku!')
        end
      end

      def process_sentence(sentence)

        words = sentence.split(' ')

        return words.map{|word| count_syllables(word)}.inject(:+)

      end


      def count_syllables(word)

        tokenizer = /([aeiouy]{1,3})/
        len = 0

        if word[-3..-1] == 'ing' then
          len += 1
          word = word[0...-3]
        end

        got = word.scan(tokenizer)
        len += got.size()

        if got.size() > 1 and got[-1] == ['e'] and
            word[-1].chr() == 'e' and
            word[-2].chr() != 'l' then
          len -= 1
        end

        return len

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
