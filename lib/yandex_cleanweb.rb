require "yandex_cleanweb/version"
require "yandex_cleanweb/captcha"

require "uri"
require "nokogiri"
require "net/http"

module YandexCleanweb
  API_URL = 'http://cleanweb-api.yandex.ru/1.0/'
  mattr_accessor :api_key

  # Your code goes here...
  def self.spam?(text)
    response = check_text(text)

    doc = Nokogiri::XML(response)
    request_id_tag = doc.xpath('//check-spam-result/id')
    spam_flag_tag = doc.xpath('//check-spam-result/text')

    request_id = request_id_tag[0]
    spam_flag = spam_flag_tag[0].attributes["spam-flag"].content

    if spam_flag == 'yes'
      response = get_captcha(request_id)

      doc = Nokogiri::XML(response)

      url_tag = doc.xpath('//get-captcha-result/url')
      captcha_id_tag = doc.xpath('//get-captcha-result/captcha')

      captcha = Capcha.new
      captcha.id = captcha_id_tag[0].content
      captcha.url = url_tag[0].content

      captcha
    else
      false
    end
  end

  def self.valid_captcha?(captcha_id, user_value)

  end

  private

  def self.get_captcha(request_id)
    get_captcha_url = "#{API_URL}/get-captcha"
    params = {key: api_key, id: request_id}

    uri = URI.parse(get_captcha_url)
    uri.query = URI.encode_www_form(params)

    Net::HTTP.get(uri)
  end

  def self.check_text(text)
    check_spam_url = "#{API_URL}/check-spam"
    params = {'body-plain' => text, 'key' => api_key}

    uri = URI.parse(check_spam_url)
    uri.query = URI.encode_www_form(params)

    Net::HTTP.get(uri)

    response = Net::HTTP.post_form(uri, params)
    response.body
  end
end
