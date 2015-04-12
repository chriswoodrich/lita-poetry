require "spec_helper"

describe Lita::Handlers::Poetry, lita_handler: true do

  it {is_expected.to route_event(:loaded).to(:populate)}
  it {is_expected.to route('a string').to(:process)}

  before do
    registry.config.handlers.poetry.strict_mode = true;
  end



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
      send_message("And grievously hath Caesar answer\’d it.")

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
      send_message("his life, a slow game.")

      send_message("Summer’s arid heat")
      send_message("the dry parched earth welcomes me")
      send_message("my blood nourishing.")

      send_message("Sheltering cherry")
      send_message("my last breath stirs your blossom")
      send_message("my soul ascends. Meh.")

      send_message("Autumn maple leaves")
      send_message("their colours, like the harvest")
      send_message("remind me of home.")

      send_message("A soul ship finds me")
      send_message("crystal waters call my name")
      send_message("I am dragged below.")

      send_message("Noble enemy")
      send_message("I mourn your loss as I mourned")
      send_message("for my first-born son.")

      send_message("The old carp is wise")
      send_message("he whispers his dark secrets")
      send_message("only the wind hears.")

      send_message("The dark tiger stalks")
      send_message("my soul quivers in the air")
      send_message("just for a moment.")

      send_message("Raindrops on the lake")
      send_message("a universe of ripples")
      send_message("center touching all.")

      send_message("Leaves turn green to gold")
      send_message("not to end but to transform")
      send_message("as flesh rots to dust.")

      expect(replies.size).to eq(13)
    end

    xit "Handles special situations and special vowel rules" do
      send_message("The Boa from Goa")
      send_message("Weighed nearly eight hundred tonnes")
      send_message("He loved his deer pie")
      expect(replies.last).to eq('Garth, that was a haiku!')

    end

  end



end
