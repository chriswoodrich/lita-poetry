[![Gem Version](https://badge.fury.io/rb/lita-poetry.svg)](http://badge.fury.io/rb/lita-poetry) [![Coverage Status](https://coveralls.io/repos/chriswoodrich/lita-poetry/badge.svg?branch=v0.0.1)](https://coveralls.io/r/chriswoodrich/lita-poetry?branch=v0.0.1) [![Build Status](https://travis-ci.org/chriswoodrich/lita-poetry.svg?branch=v0.0.1)](https://travis-ci.org/chriswoodrich/lita-poetry)

# lita-poetry

Lita-poetry passively listens for haikus (accidental or not) and alerts the channel when a haiku has formed.

```
Jimmy > Flash of steel stills me
Jimmy > calmness mirrors the ocean
Jimmy > I await the waves
Lita > Garth, that was a haiku!
```

![](http://28.media.tumblr.com/tumblr_l92fudoiME1qas5kdo1_500.png)


## Installation

Add lita-poetry to your Lita instance's Gemfile:

``` ruby
gem "lita-poetry"
```

## Configuration

strict_mode (defaults to false) will only allow haikus by a single user, whereas disabling strict_mode will allow multi-user haikus.
```
Lita.configure do |config|
  config.handlers.poetry.strict_mode = true || false
end
```

## License

[MIT](http://opensource.org/licenses/MIT)
