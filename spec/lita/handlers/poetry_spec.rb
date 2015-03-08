require "spec_helper"

describe Lita::Handlers::Poetry, lita_handler: true do

  it {is_expected.to route_event(:loaded).to(:populate)}
  it {is_expected.to route('a string').to(:process)}


  describe '#process' do
    before {robot.trigger(:loaded)}
    it 'tells Garth or the poetic user that (s)he has written a Haiku' do
      send_message("dainty daffodil")
      send_message("your golden trumpet fanfares")
      send_message("the dawning of spring")
      expect(replies.last).to eq('Garth, that was a haiku!')
    end

    it 'does nothing when 3 consective lines do not have a 5-7-5 pattern' do

      send_message("Friends, Romans, countrymen, lend me your ears;")
      send_message("I come to bury Caesar, not to praise him.")
      send_message("The evil that men do lives after them;")
      send_message("The good is oft interred with their bones;")
      send_message("So let it be with Caesar. The noble Brutus")
      send_message("Hath told you Caesar was ambitious:")
      send_message("If it were so, it was a grievous fault,")
      send_message("And grievously hath Caesar answer’d it.")

      expect(replies.size).to eq(0)
    end

    it 'handles a varierty of different ways to get to 5-7-5' do

      send_message("Amongst these are the")
      send_message("Haiku Hating Haiku Bros")
      send_message("Oh the irony.")

      send_message("To spread their evil")
      send_message("They hate haiku through Hiakus")
      send_message("Here is their worst deeds.")

      send_message("haiku are easy")
      send_message("But some times they dont make sense")
      send_message("Refrigerator")

      send_message("In the ponds cool depths")
      send_message("the happy frog plays in spring")
      send_message("his life, a slow game")

      send_message("Summer's arid heat")
      send_message("the dry parched earth welcomes me")
      send_message("my blood nourishing.")

      expect(replies.size).to eq(5)
    end




  end



end
