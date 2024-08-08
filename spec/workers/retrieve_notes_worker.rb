require 'rails_helper'

describe RetrieveNotesWorker do
  describe '#execute' do
    subject(:execute_worker) do
      VCR.use_cassette "retrieve_notes/#{note_type}/valid_params" do
        described_class.new.execute(user.id, params)
      end
    end

    let(author) { 'J.K. Rowling' }
    let(params) { { author: author } }
    let(user) { create(:user, utility: utility) }

    let(expected_notes_keys) do
      %i[title type created_at content user book]
    end

    context 'with utility service' do
      let(:utilities) { %i[north_utility south_utility] }

      include_context 'with utility' do
        let(:utility) { create(utilities.sample) }
      end

      context 'when the request to the utility succeeds' do
        it 'succeeds' do
          expect(execute_worker.first).to eq 200
        end

        it 'returns notes as array' do
          expect(execute_worker.second[:notes]).to be_instance_of(Array)
        end

        it 'returns the expected note keys' do
          expect(execute_worker.second[:notes].first.keys).to contain_exactly(*expected_notes_keys)
        end
      end
    end
  end
end
