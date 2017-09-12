require 'spec_helper'

RSpec.describe CmQuiz::Review::UpdateIdea do
  describe '#perform' do
    let(:mock_idea) do
      {
        content: 'test-new-content',
        impact: 6,
        ease: 7,
        confidence: 8,
        average_score: 7.0
      }
    end
    let!(:project_api) do
      api = double
      allow(api).to receive(:request) do |verb, path, opts|
        double(success?: true, body: mock_idea.to_json, code: 200)
      end
      api
    end
    let(:idea_id) { 1 }
    let(:mock_idea_payload) do
      {
        'id' => idea_id
      }
    end
    let(:service) do
      CmQuiz::Review::UpdateIdea.new({
        project_api: project_api
      })
    end
    before :each do
      user_factory = double(create: ['jwt', 'refresh_token'])
      allow(CmQuiz::Factory::User).to receive(:new).and_return(user_factory)
      idea_factory = double(create: mock_idea_payload)
      allow(CmQuiz::Factory::Idea).to receive(:new).and_return(idea_factory)
    end

    it "should pass test" do
      test_result = service.perform

      expect(test_result).to eq(["put /ideas/:idea_id", true, nil])
      options = {
        headers: {
          'x-access-token' => 'jwt'
        },
        body: {
          content: mock_idea[:content],
          impact: mock_idea[:impact],
          ease: mock_idea[:ease],
          confidence: mock_idea[:confidence]
        }
      }
      args = [:put, "/ideas/#{idea_id}", options]
      expect(project_api).to have_received(:request).with(*args)
    end
  end
end