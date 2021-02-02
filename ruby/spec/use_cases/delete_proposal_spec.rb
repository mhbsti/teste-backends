require_relative '../../use_cases/delete_proposal'
require_relative '../../domain/proposal'


describe DeleteProposal do
  context 'removendo uma proposta' do
    context 'e econtra proposta' do
      it 'remove a proposta' do
        proposal_id = 'proposal_id'
        proposal = instance_spy(Proposal)
        proposals_repository = instance_spy(ProposalsRepository, get: proposal, remove: proposal)

        subject = described_class.new(proposals_repository: proposals_repository).call(proposal_id)

        aggregate_failures do
          expect(subject).to be proposal
          expect(proposals_repository).to have_received(:get).with(proposal_id)
          expect(proposals_repository).to have_received(:remove).with(proposal)
        end
      end
    end

    context 'e não econtra proposta' do
      it 'notFound' do
        proposal_id = 'proposal_id'
        proposals_repository = instance_spy(ProposalsRepository, get: nil)

        expect { described_class.new(proposals_repository: proposals_repository).call(proposal_id) }
          .to raise_exception(ProposalNotFound)
      end
    end
  end
end
