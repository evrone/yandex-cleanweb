# encoding: utf-8
require "test_helper"

describe YandexCleanweb do

  context "without api key" do
    before do
      YandexCleanweb.api_key = nil
    end

    describe "#spam?" do
      it "raise an error" do
        -> {
          YandexCleanweb.spam?("anything")
        }.must_raise YandexCleanweb::NoApiKeyException
      end
    end

    describe "#get_captcha" do
      it "raise an error" do
        -> {
          YandexCleanweb.get_captcha("anything")
        }.must_raise YandexCleanweb::NoApiKeyException
      end
    end

    describe "#valid_captcha?" do
      it "raise an error" do
        -> {
          YandexCleanweb.valid_captcha?("anything", "anything", 123)
        }.must_raise YandexCleanweb::NoApiKeyException
      end
    end

  end

  context "with empty api key" do
    before do
      YandexCleanweb.api_key = ""
    end

    it "raise an error" do
      -> {
        YandexCleanweb.spam?("anything")
      }.must_raise YandexCleanweb::NoApiKeyException
    end
  end

  context "with api key" do

    before do
      YandexCleanweb.api_key = "cw.1.1.20121227T080449Z.51de1ee126e5ced6.f4f417fb55727520d7e39b00cf5393d4b1ca5e78"
    end

    describe "#spam?" do

      describe "simple check" do
        it "works" do
          YandexCleanweb.spam?("фраза").must_equal false
          YandexCleanweb.spam?("недорого увеличение пениса проститутки").must_equal false
        end
      end

      describe "advanced mode" do
        it "works" do
          YandexCleanweb.spam?(:body_plain => "my text", :ip => "80.80.40.3").must_equal false
        end

        it "with some html" do
          result = YandexCleanweb.spam?(:body_html => "some spam <a href='http://spam.com'>spam link</a>")

          result[:id].wont_be_empty
          result[:links].must_be_empty
        end
      end
    end

    describe "#get_captcha + #valid_captcha?" do

      it "works for not valid captchas" do
        result = YandexCleanweb.spam?(:body_html => "some spam <a href='http://spam.com'>spam link</a>")
        captcha = YandexCleanweb.get_captcha(result[:id])

        captcha[:url].wont_be_empty
        captcha[:captcha].wont_be_empty

        valid = YandexCleanweb.valid_captcha?(result[:id], captcha[:captcha], "1234")
        valid.must_equal false
      end
    end
  end
end
