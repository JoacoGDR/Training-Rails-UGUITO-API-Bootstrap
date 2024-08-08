require 'rails_helper'

describe RetrieveNotesWorker do
  describe '#execute' do
    subject(:execute_worker) do
      VCR.use_cassette "retrieve_notes/#{note_type}/valid_params" do
        described_class.new.execute(user.id, params)
      end
    end

    context 'with utility service' do
      let(author) { 'J.K. Rowling' }
      let(params) { { author: author } }
      let(user) { create(:user, utility: utility) }
      let(:utilities) { %i[north_utility south_utility] }

      include_context 'with utility' do
        let(:utility) { create(utilities.sample) }
      end

      context 'when the request to the utility succeeds' do
        let(:response_status) { execute_worker.first }
        let(:response_array) { execute_worker.second[:notes] }
        let(expected_keys) do
          %i[title type created_at content user book]
        end

        it_behaves_like 'valid array response with at least one resource'
      end
    end

    include_context 'without utility service' do
      it_behaves_like 'worker response with valid format and expected code'
    end
  end
end
