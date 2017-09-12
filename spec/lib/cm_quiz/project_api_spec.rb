require 'spec_helper'

describe 'ProjectAPI' do
  describe '#request' do
    let(:endpoint) { "https://my-awesome-api.com" }
    let(:verb) { :post }
    let(:path) { '/greeting' }
    let(:options) do
      {
        body: { foo: 'bar' },
        headers: { 'X-Access-Token' => 'secret-token' }
      }
    end
    let(:api) do
      api = CmQuiz::ProjectAPI.new(endpoint)
    end

    it "should request clearbit" do
      stub_request(verb, "#{endpoint}#{path}")

      api.request(verb, path, options)

      assert_requested(verb, "#{endpoint}#{path}") do |req|
        body = JSON.parse(req.body)
        expect(body['foo']).to eq('bar')
        expect(req.headers['X-Access-Token']).to eq(options[:headers]['X-Access-Token'])
      end
    end

    context "when response is not success" do
      it "should raise exception" do
        res_body = 'error_message'
        stub_request(verb, "#{endpoint}#{path}").to_return(status: 404, body: res_body)

        expect {
          api.request(verb, path, options)
        }.to raise_error(CmQuiz::ProjectAPI::PerformFailed)
      end
    end
  end
end
