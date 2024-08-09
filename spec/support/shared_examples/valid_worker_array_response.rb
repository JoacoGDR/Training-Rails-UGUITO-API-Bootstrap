shared_examples 'valid worker array response' do
  it 'succeeds' do
    expect(response_status).to eq 200
  end

  it 'returns notes as array' do
    expect(response_array).to be_instance_of(Array)
  end

  it 'returns the expected note keys' do
    expect(response_array.first.keys).to contain_exactly(*expected_keys)
  end
end