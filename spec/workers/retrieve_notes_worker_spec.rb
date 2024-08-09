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
        let(:root_key) { :notes }
        let(:expected_keys) do
          %i[title type created_at content user book]
        end
        let(:user_keys) do
          %i[email first_name last_name]
        end
        let(:book_keys) do
          %i[title author genre]
        end

        it_behaves_like 'valid worker array response'

        it('returns the expected user keys') do
          expect(execute_worker.second[root_key].first[:user].keys).to contain_exactly(*user_keys)
        end

        it('returns the expected book keys') do
          expect(execute_worker.second[root_key].first[:book].keys).to contain_exactly(*book_keys)
        end
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

        it_behaves_like 'successful worker response'
      end
    end
  end
end
