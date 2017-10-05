module AssertTestCase
  def assert_test_case(service, test_result)
    test_case = {
      verb: service.verb,
      path: service.path,
      options: service.options
    }
    expect(test_result).to eq([test_case, true, nil])
    args = [service.verb, service.path, service.options]
    expect(project_api).to have_received(:request).with(*args)
  end
end
