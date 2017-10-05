require 'spec_helper'

RSpec.describe CmQuiz::Review::CreateIdea do
  describe '#perform' do
    let(:mock_idea) do
      {
        content: 'test-content',
        impact: 7,
        ease: 8,
        confidence: 9,
        average_score: 8.0
      }
    end
    let!(:project_api) do
      api = double
      allow(api).to receive(:request) do |verb, path, opts|
        double(success?: true, body: mock_idea.to_json, code: 200)
      end
      api
    end
    let(:service) do
      CmQuiz::Review::CreateIdea.new({
        project_api: project_api
      })
    end
    before :each do
      factory = double(create: ['jwt', 'refresh_token'])
      allow(CmQuiz::Factory::User).to receive(:new).and_return(factory)
    end

    it "should pass test" do
      test_result = service.perform

      assert_test_case(service, test_result)
    end
  end
end
