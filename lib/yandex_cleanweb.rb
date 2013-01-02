require "yandex_cleanweb/version"

require "uri"
require "nokogiri"
require "net/http"

module YandexCleanweb
  API_URL = 'http://cleanweb-api.yandex.ru/1.0/'

  class << self
    attr_accessor :api_key

    def spam?(*options)
      response = api_check_spam(options)
      doc = Nokogiri::XML(response)

      request_id_tag = doc.xpath('//check-spam-result/id')
      spam_flag_tag = doc.xpath('//check-spam-result/text')

      request_id = request_id_tag[0]
      spam_flag = spam_flag_tag[0].attributes["spam-flag"].content

      if spam_flag == 'yes'
        links = doc.xpath('//check-spam-result/links').map { |el|
          [attributes["url"], attributes["spam_flag"] == 'yes']
        }

        { id: request_id, links: links }
      else
        false
      end
    end

    def get_captcha(request_id)
      response = api_get_captcha(request_id)
      doc = Nokogiri::XML(response)

      url = doc.xpath('//get-captcha-result/url').text
      captcha_id = doc.xpath('//get-captcha-result/captcha').text

      {
        url: url,
        captcha: captcha_id
      }
    end

    def valid_captcha?(request_id, captcha_id, value)
      response = api_check_captcha(request_id, captcha_id, value)
      doc = Nokogiri::XML(response)
      doc.xpath('//check-captcha-result/ok').any?
    end

    private

    def api_check_captcha(request_id, captcha_id, value)
      check_captcha_url = "#{API_URL}/check-captcha"
      params = {
        key: api_key,
        id: request_id,
        captcha: captcha_id,
        value: value
      }

      uri = URI.parse(check_captcha_url)
      uri.query = URI.encode_www_form(params)

      Net::HTTP.get(uri)
    end

    def api_get_captcha(request_id)
      get_captcha_url = "#{API_URL}/get-captcha"
      params = {key: api_key, id: request_id}

      uri = URI.parse(get_captcha_url)
      uri.query = URI.encode_www_form(params)

      Net::HTTP.get(uri)
    end

    def api_check_spam(*options)
      cleanweb_options = {}

      if options[0].is_a?(String) # quick check
        cleanweb_options[:body_plain] = options[0]
      else
        options = options[0][0]

        cleanweb_options.merge!({
          "key" => api_key,

          "body-plain" => options[:body_plain],
          "body-html" => options[:body_html],
          "body-bbcode" => options[:body_bbcode],

          "subject-html" => options[:subject_html],
          "subject-plain" => options[:subject_plain],
          "subject-bbcode" => options[:subject_bbcode],

          "ip" => options[:ip],
          "email" => options[:email],
          "name" => options[:name],
          "login" => options[:login],
          "realname" => options[:realname]
        })
      end

      check_spam_url = "#{API_URL}/check-spam"
      uri = URI.parse(check_spam_url)
      response = Net::HTTP.post_form(uri, cleanweb_options)
      response.body
    end
  end
end
