shared_examples 'valid array response with at least one resource' do
  it 'succeeds' do
    expect(response_status).to eq 200
  end

  it 'returns notes as array' do
    expect(response_array).to be_instance_of(Array)
  end

  it 'responds with a non empty array' do
    expect(response_array).not_to be_empty
  end

  it 'returns the expected note keys' do
    expect(response_array.first.keys).to contain_exactly(*expected_keys)
  end
end
