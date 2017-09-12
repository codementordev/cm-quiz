require 'spec_helper'

RSpec.describe CmQuiz::Factory::User do
  describe '#create' do
    let(:jwt) { 'jwt' }
    let(:refresh_token) { 'refresh_token' }
    let!(:project_api) do
      api = double
      allow(api).to receive(:request) do |verb, path, opts|
        double(success?: true, body: { jwt: jwt, refresh_token: refresh_token}.to_json, code: 200)
      end
      api
    end
    let(:factory) do
      CmQuiz::Factory::User.new({
        project_api: project_api
      })
    end

    it "should create user" do
      res = factory.create

      expect(res[0]).to eq(jwt)
      expect(res[1]).to eq(refresh_token)
    end
  end
end
