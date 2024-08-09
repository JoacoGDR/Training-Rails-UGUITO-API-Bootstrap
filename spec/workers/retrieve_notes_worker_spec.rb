require 'rails_helper'

describe RetrieveNotesWorker do
  describe '#execute' do
    subject(:execute_worker) do
      VCR.use_cassette "retrieve_notes/#{utility_name}/valid_params" do
        described_class.new.execute(user.id, params)
      end
    end

    let(:author) { 'J.K. Rowling' }
    let(:params) { { author: author } }
    let(:user) { create(:user, utility: utility) }

    context 'with utility service' do
      let_it_be(:utilities) do
        %i[north_utility south_utility]
      end

      include_context 'with utility' do
        let_it_be(:utility) { create(utilities.sample) }
      end

      context 'when the request to the utility succeeds' do
        let(:response_status) { execute_worker.first }
        let(:response_array) { execute_worker.second[:notes] }
        let(:expected_keys) do
          %i[title type created_at content user book]
        end

        it_behaves_like 'valid worker array response'
      end

      context 'when the request to the utility fails' do
        subject(:execute_worker) do
          described_class.new.execute(user.id, params)
        end

        let(:expected_status_code) { 500 }
        let(:expected_response_body) { { error: 'message' } }
        let(:utility_service_method) { :retrieve_notes }

        before do
          allow(utility_service_class).to receive(:new).and_return(utility_service_instance)
          allow(utility_service_instance).to receive(utility_service_method)
            .and_return(instance_double(utility_service_response_class,
                                        code: expected_status_code, body: expected_response_body))
          allow(utility_service_instance).to receive(:utility).and_return(utility)
        end

        it_behaves_like 'well formatted worker response'
      end
    end
  end
end
