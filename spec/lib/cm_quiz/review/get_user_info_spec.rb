require 'spec_helper'

RSpec.describe CmQuiz::Review::GetUserInfo do
  describe '#perform' do
    let!(:project_api) do
      api = double
      allow(api).to receive(:request) do |verb, path, opts|
        double(success?: true, body: { email: email, name: name}.to_json, code: 200)
      end
      api
    end
    let(:hex) { '58714e1256' }
    let(:name) { "codementor-test-#{hex}" }
    let(:email) { "#{name}@codementor.io"}
    let(:service) do
      CmQuiz::Review::GetUserInfo.new({
        project_api: project_api
      })
    end
    before :each do
      factory = double(create: ['jwt', 'refresh_token'])
      allow(CmQuiz::Factory::User).to receive(:new).and_return(factory)
      allow(SecureRandom).to receive(:hex).and_return(hex)
    end

    it "should pass test" do
      test_result = service.perform

      assert_test_case(service, test_result)
    end
  end
end