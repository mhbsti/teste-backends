require_relative '../../use_cases/add_warranty'
require_relative '../../domain/proposal'

describe AddWarranty do
  context 'adicionando garantia' do
    context "e econtra proposta" do
      it "cria garantia e adiciona na proposta" do
        proposal_id = 'proposal_id'
        warranty_id = 'warranty_id'
        warranty_value = 300000.0
        warranty_province = 'SP'
        warranty = instance_spy(Warranty)
        warranty_class = class_spy(Warranty, new: warranty)
        proposal = instance_spy(Proposal)
        proposals_repository = instance_spy(ProposalsRepository, get: proposal)

        subject = described_class.new(warranty_class: warranty_class, proposals_repository: proposals_repository).call(
          proposal_id, warranty_id, warranty_value.to_s, warranty_province
        )

        aggregate_failures do
          expect(subject).to be proposal
          expect(proposals_repository).to have_received(:get).with(proposal_id)
          expect(warranty_class).to have_received(:new).with(
            id: warranty_id,
            proposal_id: proposal_id,
            value: warranty_value,
            province: warranty_province
          )
          expect(proposal).to have_received(:add_warranty).with(warranty)
        end
      end
    end

    context "e não econtra proposta" do
      it 'notFound' do
        proposal_id = 'proposal_id'
        warranty_id = 'warranty_id'
        warranty_value = 300000.0
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
