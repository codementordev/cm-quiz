require 'spec_helper'
require 'date'

RSpec.describe CmQuiz::Review::GetIdeas do
  describe '#perform' do
    let!(:project_api) do
      api = double
      allow(api).to receive(:request) do |verb, path, opts|
          double(success?: true, body: mock_ideas_payload.to_json, code: 200)
      end
      api
    end
    let(:idea_id) { 1 }
    let(:now) { Time.now }
    let(:mock_ideas_payload) do
      3.times.map do |i|
        {
          'id' => i,
          'content' => 'test-content',
          'impact' => 7,
          'ease' => 8,
          'confidence' => 9,
          'average_score' => 8.0,
          'created_at' => now.to_i
        }
      end
    end
    let(:idea_factory) do
      factory = double
      call_time = 0
      allow(factory).to receive(:create) do
        idea = mock_ideas_payload[call_time]
        call_time += 1
        idea
      end
      factory
    end
    let(:service) do
      CmQuiz::Review::GetIdeas.new({
        project_api: project_api
      })
    end
    before :each do
      user_factory = double(create: ['jwt', 'refresh_token'])
      allow(CmQuiz::Factory::User).to receive(:new).and_return(user_factory)
      allow(CmQuiz::Factory::Idea).to receive(:new).and_return(idea_factory)
    end

    it "should pass test" do
      test_result = service.perform

      expect(test_result).to eq(["get /ideas", true, nil])
      options = {
        headers: {
          'x-access-token' => 'jwt'
        },
        query: {
          page: 1
        }
      }
      args = [:get, "/ideas", options]
      expect(project_api).to have_received(:request).with(*args)
    end
  end
end
