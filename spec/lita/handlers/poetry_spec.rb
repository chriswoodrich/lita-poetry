require "spec_helper"

describe Lita::Handlers::Poetry, lita_handler: true do

  it {is_expected.to route_event(:loaded).to(:populate)}
  it {is_expected.to route('a string').to(:process)}


  describe '#process' do
    before {robot.trigger(:loaded)}
    it 'tells Garth or the poetic user that (s)he has written a Haiku' do

      send_message("dainty daffodil")
      send_message("your golden trumpet fanfare")
      send_message("the dawning of spring")

      expect(replies.last).to eq('Garth, that was a haiku!')
    end
  end



end
