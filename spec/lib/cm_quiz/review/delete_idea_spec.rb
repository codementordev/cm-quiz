require 'spec_helper'

RSpec.describe CmQuiz::Review::DeleteIdea do
  describe '#perform' do
    let!(:project_api) do
      api = double
      allow(api).to receive(:request) do |verb, path, opts|
        if path == '/ideas'
          double(success?: true, body: [].to_json, code: 200)
        else
          double(success?: true, body: "", code: 200)
        end
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
      CmQuiz::Review::DeleteIdea.new({
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

      expect(test_result).to eq(["delete /ideas/:idea_id", true, nil])
      options = {
        headers: {
          'x-access-token' => 'jwt'
        }
      }
      args = [:delete, "/ideas/#{idea_id}", options]
      expect(project_api).to have_received(:request).with(*args)
    end
  end
end
