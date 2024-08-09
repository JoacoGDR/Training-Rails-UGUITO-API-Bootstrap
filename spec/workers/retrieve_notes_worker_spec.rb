require 'rails_helper'

describe RetrieveNotesWorker do
  describe '#execute' do
    subject(:execute_worker) do
      VCR.use_cassette "retrieve_notes/#{utility_name}/valid_params" do
        described_class.new.execute(user.id, params)
      end
    end

    context 'with utility service' do
      let(:author) { 'J.K. Rowling' }
      let(:params) { { author: author } }
      let(:user) { create(:user, utility: utility) }
      let(:utilities) { %i[north_utility south_utility] }

      include_context 'with utility' do
        let(:utility) { create(utilities.sample) }
      end

      context 'when the request to the utility succeeds' do
        let(:response_status) { execute_worker.first }
        let(:response_array) { execute_worker.second[:notes] }
        let(:expected_keys) do
          %i[title type created_at content user book]
        end

        before { execute_worker }

        it_behaves_like 'valid worker array response'
      end

      include_context 'with failed utility request' do

        before { execute_worker }

        it_behaves_like 'well formatted worker response'
      end
    end
  end
end
