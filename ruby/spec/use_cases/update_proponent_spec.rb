require_relative '../../use_cases/update_proponent'
require_relative '../../domain/proposal'

describe UpdateProponent do
  context 'atualizar um proponente' do
    context "e encontra proposta" do
      context 'e encontra proponente' do
        it 'atualiza proponente' do
          proposal_id = 'proposal_id'
          proponent_id = 'proponent_id'
          proponent_name = 'Carlos'
          proponent_age = 18
          proponent_monthly_income = 5500.0
          proponent_is_main = true
          proponent = instance_spy(Proponent, id: proponent_id)
          proposal = instance_spy(Proposal, proponents: [proponent])
          proposals_repository = instance_spy(ProposalsRepository, get: proposal)

          subject = described_class.new(proposals_repository: proposals_repository).call(
            proposal_id, proponent_id, proponent_name, proponent_age.to_s, proponent_monthly_income.to_s, proponent_is_main.to_s
          )

          aggregate_failures do
            expect(subject).to be proposal
            expect(proposals_repository).to have_received(:get).with(proposal_id)
            expect(proponent).to have_received(:name=).with(proponent_name)
            expect(proponent).to have_received(:age=).with(proponent_age)
            expect(proponent).to have_received(:monthly_income=).with(proponent_monthly_income)
            expect(proponent).to have_received(:main=).with(proponent_is_main)
          end
        end
      end

      context 'e não econtra proponente' do
        it 'notFound' do
          proposal_id = 'proposal_id'
          proponent_id = 'proponent_id'
          proponent_name = 'Carlos'
          proponent_age = 18
          proponent_monthly_income = 5500.0
          proponent_is_main = true
          proposal = instance_spy(Proposal, proponents: [])
          proposals_repository = instance_spy(ProposalsRepository, get: proposal)

          expect do
            described_class.new(proposals_repository: proposals_repository).call(
              proposal_id, proponent_id, proponent_name, proponent_age.to_s, proponent_monthly_income.to_s, proponent_is_main.to_s
            )
          end
            .to raise_exception(ProponentNotFound)
        end
      end
    end

    context "e não econtra proposta" do
      it 'notFound' do
        proposal_id = 'proposal_id'
        proponent_id = 'proponent_id'
        proponent_name = 'José'
        proponent_age = 18
        proponent_monthly_income = 5500.0
        proponent_is_main = true
        proposals_repository = instance_spy(ProposalsRepository, get: nil)

        expect do
          described_class.new(proposals_repository: proposals_repository).call(
            proposal_id, proponent_id, proponent_name, proponent_age.to_s, proponent_monthly_income.to_s, proponent_is_main.to_s
          )
        end
          .to raise_exception(ProposalNotFound)
      end
    end
  end
end
