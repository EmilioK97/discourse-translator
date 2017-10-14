require 'rails_helper'

RSpec.describe DiscourseTranslator::Deepl do
  let(:mock_response) { Struct.new(:status, :body) }

  describe '.translate' do
    let(:post) { Fabricate(:post) }

    it 'raises an error on failure' do
      Excon.expects(:get).returns(mock_response.new(
        400,
        { error: 'something went wrong', error_description: 'you passed in a wrong param' }.to_json
      ))

      expect { described_class.translate(post) }.to raise_error DiscourseTranslator::TranslatorError
    end
  end
end
