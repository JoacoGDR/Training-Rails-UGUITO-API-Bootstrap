shared_context 'with failed utility request' do
  before do
    allow(utility_service_class).to receive(:new).and_return(utility_service_instance)
    allow(utility_service_instance).to receive(utility_service_method)
      .and_return(instance_double(utility_service_response_class,
                                  code: expected_status_code, body: expected_response_body))
    allow(utility_service_instance).to receive(:utility).and_return(utility)
  end
end
