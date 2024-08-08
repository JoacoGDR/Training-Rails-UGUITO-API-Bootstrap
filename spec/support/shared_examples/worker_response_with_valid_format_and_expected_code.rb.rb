shared_examples 'worker response with valid format and expected code' do
  it 'returns status code obtained from the utility service' do
    expect(execute_worker.first).to eq(expected_status_code)
  end

  it 'returns the body obtained from the utility service' do
    expect(execute_worker.second).to eq(expected_response_body)
  end
end
