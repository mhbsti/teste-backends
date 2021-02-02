require_relative '../../use_cases/update_warranty'
require_relative '../../domain/proposal'

describe UpdateWarranty do
  context 'atualizar garantia' do
    context "encontrara proposta" do
      context 'encontrar garantia' do
        it 'atualizar garantia' do
          proposal_id = 'proposal_id'
          warranty_id = 'warranty_id'
          warranty_value = 200000.0
          warranty_province = 'SP'
          warranty = instance_spy(Warranty, id: warranty_id)
          proposal = instance_spy(Proposal, warranties: [warranty])
          proposals_repository = instance_spy(ProposalsRepository, get: proposal)

          subject = described_class.new(proposals_repository: proposals_repository).call(
            proposal_id, warranty_id, warranty_value.to_s, warranty_province
          )

          aggregate_failures do
            expect(subject).to be proposal
            expect(proposals_repository).to have_received(:get).with(proposal_id)
            expect(warranty).to have_received(:value=).with(warranty_value)
            expect(warranty).to have_received(:province=).with(warranty_province)
          end
        end
      end

      context 'não encontra garantia' do
        it 'notFound' do
          proposal_id = 'proposal_id'
          warranty_id = 'warranty_id'
          warranty_value = 200000.0
          warranty_province = 'SP'
          proposal = instance_spy(Proposal, warranties: [])
          proposals_repository = instance_spy(ProposalsRepository, get: proposal)

          expect do
            described_class.new(proposals_repository: proposals_repository).call(
              proposal_id, warranty_id, warranty_value.to_s, warranty_province
            )
          end
            .to raise_exception(WarrantyNotFound)
        end
      end
    end

    context "não encontra proposta" do
      it 'exception' do
        proposal_id = 'proposal_id'
        warranty_id = 'warranty_id'
        warranty_value = 200000.0
        warranty_province = 'SP'
        proposals_repository = instance_spy(ProposalsRepository, get: nil)

        expect do
          described_class.new(proposals_repository: proposals_repository).call(
            proposal_id, warranty_id, warranty_value.to_s, warranty_province
          )
        end
          .to raise_exception(ProposalNotFound)
      end
    end
  end
end
