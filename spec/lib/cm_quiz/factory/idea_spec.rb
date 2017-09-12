require 'spec_helper'

RSpec.describe CmQuiz::Factory::Idea do
  describe '#create' do
    let(:jwt) { 'jwt' }
    let(:mock_idea) do
      {
        content: 'the-content',
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
    let(:factory) do
      CmQuiz::Factory::Idea.new({
        project_api: project_api,
        jwt: jwt
      })
    end
    before :each do
      user_factory = double(create: [jwt, 'refresh_token'])
      allow(CmQuiz::Factory::User).to receive(:new).and_return(user_factory)
    end

    it "should create idea" do
      res = factory.create

      expect(res['content']).to eq(mock_idea[:content])
      expect(res['impact']).to eq(mock_idea[:impact])
      expect(res['ease']).to eq(mock_idea[:ease])
      options = {
        headers: {
          'x-access-token' => jwt
        },
        body: {
          content: mock_idea[:content],
          impact: mock_idea[:impact],
          ease: mock_idea[:ease],
          confidence: mock_idea[:confidence]
        }
      }
      args = [:post, '/ideas', options]
      expect(project_api).to have_received(:request).with(*args)
    end
  end
end
