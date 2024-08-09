shared_examples 'well formatted worker response' do
  it 'returns status code obtained from the utility service' do
    expect(execute_worker.first).to eq(expected_status_code)
  end

  it 'returns the body obtained from the utility service' do
    expect(execute_worker.second).to eq(expected_response_body)
  end
end
