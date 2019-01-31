# PLEASE NOTE, THIS PROJECT IS NO LONGER BEING MAINTAINED
# Yandex Cleanweb

[![Build Status](https://travis-ci.org/evrone/yandex-cleanweb.png?branch=master)](https://travis-ci.org/evrone/yandex-cleanweb)

Ruby wrapper for [Yandex Cleanweb](https://tech.yandex.ru/cleanweb/) spam detector.

Unfortunatelly, this gem *is not capable with MRI 1.8.7* because of MRI 1.8.7 doesn't have `URI.encode_www_form` method.

<a href="https://evrone.com/?utm_source=github.com">
  <img src="https://evrone.com/logo/evrone-sponsored-logo.png"
       alt="Sponsored by Evrone" width="231">
</a>

## Getting Started
### Installation

Add this line to your application's Gemfile:

    gem 'yandex_cleanweb', '~> 0.0.7'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yandex_cleanweb

### Usage

Get the api key: [https://tech.yandex.ru/keys/get/?service=cw](https://tech.yandex.ru/keys/get/?service=cw)

```ruby
YandexCleanweb.api_key = "your_key"
YandexCleanweb.spam?("just phrase")
  => false

YandexCleanweb.spam?(body_plain: "my text", ip: "80.80.40.3")
  => false

YandexCleanweb.spam?(body_html: "some spam <a href='http://spam.com'>spam link</a>")
  => { id: "request id", links: [ ['http://spam.com', true] ] }
```

Tell Cleanweb API that message is spam:

```ruby
YandexCleanweb.api_key = "your_key"
YandexCleanweb.spam!("some spam here")
YandexCleanweb.spam!(body_html: "some spam <a href='http://spam.com'>spam link</a>")
```

More complex example:

```ruby

user_input = "download free porn <a>...</a>"
if spam_check = YandexCleanweb.spam?(user_input, ip: current_user.ip)
  captcha = YandexCleanweb.get_captcha(spam_check[:id])

  # now you can show captcha[:url] to user
  # but remember to write captcha[:captcha] to session

  # to check is captcha enterred by user is valid:
  captcha_valid = YandexCleanweb.valid_captcha?(result[:id], captcha[:captcha], user_captcha)
end
```

If you use Yandex Cleanweb in Rails app, we recommend to set up the api key in `config/initializers/yandex_cleanweb.rb`

## Contributing

Please read [Code of Conduct](CODE-OF-CONDUCT.md) and [Contributing Guidelines](CONTRIBUTING.md) for submitting pull requests to us.

## Authors

* [Kir Shatrov](https://github.com/kirs) - *Initial work*

See also the list of [contributors](https://github.com/evrone/yandex-cleanweb/graphs/contributors) who participated in this project.

## License

This project is licensed under the [MIT License](LICENSE).
