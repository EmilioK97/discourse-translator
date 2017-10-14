require_relative 'base'
require 'json'

module DiscourseTranslator
  class Deepl < Base
    TRANSLATE_URI = "https://www.deepl.com/jsonrpc".freeze

    SUPPORTED_LANG = {
      en: 'EN',
      de: 'DE',
      es: 'ES',
      fr: 'FR',
      it: 'IT',
      nl: 'NL',
      pl_PL: 'PL',
    }

    def self.detect(post)
      'auto'
    end

    def self.translate(post)
      translated_text = from_custom_fields(post) do
        body = {
          'jobs': [
            {
              'kind': 'default',
              'raw_en_sentence': post.cooked
            }
          ],
          'lang': {
            'user_preferred_langs': [
              'auto',
              locale
            ],
            'source_lang_user_selected': 'auto',
            'target_lang': locale
          },
        }

        res = result(TRANSLATE_URI, body, { 'Content-Type' => "application/json" })

        # TODO Check if exists, just testing
        res['result']['translations'][0]['beams'][0]['postprocessed_sentence']
      end

      ['Auto', translated_text]
    end

    private

    def self.locale
      SUPPORTED_LANG[I18n.locale] || (raise I18n.t("translator.not_supported"))
    end

    def self.post(uri, body, headers = {})
      Excon.post(uri, body: body, headers: headers)
    end

    def self.result(uri, body, headers)
      response = post(uri, body, headers)
      response_body = response.body
      
      response_body
    end
  end
end
