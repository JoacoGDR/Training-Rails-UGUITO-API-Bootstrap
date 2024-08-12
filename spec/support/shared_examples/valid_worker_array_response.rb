shared_examples 'valid worker array response' do
  it 'succeeds' do
    expect(execute_worker.first).to eq 200
  end

  it 'returns notes as array' do
    expect(execute_worker.second[root_key]).to be_instance_of(Array)
  end

  it 'returns the expected note keys' do
    expect(execute_worker.second[root_key].first.keys).to contain_exactly(*expected_keys)
  end
end
