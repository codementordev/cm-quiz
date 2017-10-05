require 'spec_helper'

describe CmQuiz::Review::SignUpUser do
  describe '#perform' do
    let!(:project_api) do
      api = double
      allow(api).to receive(:request) do |verb, path, opts|
        double(success?: true, body: { jwt: '', refresh_token: ''}.to_json, code: 200)
      end
      api
    end
    let(:service) do
      CmQuiz::Review::SignUpUser.new({
        project_api: project_api
      })
    end

    it "should pass test" do
      test_result = service.perform

      assert_test_case(service, test_result)
    end
  end
end
