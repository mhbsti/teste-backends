#Revisar

require 'spec_helper'
require 'securerandom'
require_relative '../../domain/proposal'
require_relative '../../domain/proponent'
require_relative '../../domain/warranty'

describe Proposal do
  describe 'adicionar proponente' do
    context 'proponente tem 17 anos ou menos' do
      it 'não adicionar proponente na proposta' do
        proponent = instance_double(Proponent, age: 17)
        proposal = described_class.new(id: nil, loan_value: nil, number_of_monthly_installments: nil)

        proposal.add_proponent(proponent)

        expect(proposal.proponents).not_to include(proponent)
      end
    end

    context 'proponente mais de 18 anos' do
      it 'adicionar proponente na proposta' do
        proponent = instance_double(Proponent, age: 18)
        proposal = described_class.new(id: nil, loan_value: nil, number_of_monthly_installments: nil)

        subject = proposal.add_proponent(proponent)

        aggregate_failures do
          expect(proposal.proponents).to include(proponent)
          expect(subject).to be proposal
        end
      end
    end
    
  end

  describe 'remover proponente' do
    context 'se encontrar o proponente' do
      it 'remove proponente' do
        proponent = instance_double(Proponent)
        proponents = [proponent]
        proposal = described_class.new(id: nil, loan_value: nil, number_of_monthly_installments: nil, proponents: proponents)

        subject = proposal.remove_proponent(proponent)

        aggregate_failures do
          expect(subject).to be proponent
          expect(proponents).not_to include(proponent)
        end
      end
    end

    context 'se não econtrar o proponente' do
      it 'retorna nulo' do
        proponent = instance_double(Proponent)
        proponents = []
        proposal = described_class.new(id: nil, loan_value: nil, number_of_monthly_installments: nil, proponents: proponents)

        subject = proposal.remove_proponent(proponent)

        expect(subject).to be_nil
      end
    end
  end

  describe 'adicionar garantia' do
    context 'garantia de estado aceito' do
      it 'adicionar garantia a proposta' do
        warranty = instance_double(Warranty, province: 'SP')
        proposal = described_class.new(id: nil, loan_value: nil, number_of_monthly_installments: nil)
        subject = proposal.add_warranty(warranty)
        aggregate_failures do
          expect(proposal.warranties).to include(warranty)
          expect(subject).to be proposal
        end
      end
    end

    context 'garantia de estado que aceito' do
      it 'não adiciona a garantia' do
        warranty_from_rs = instance_double(Warranty, province: 'RS')
        warranty_from_sc = instance_double(Warranty, province: 'SC')
        warranty_from_pr = instance_double(Warranty, province: 'PR')
        proposal = described_class.new(id: nil, loan_value: nil, number_of_monthly_installments: nil)
        proposal.add_warranty(warranty_from_rs)
        proposal.add_warranty(warranty_from_sc)
        proposal.add_warranty(warranty_from_pr)
        aggregate_failures do
          expect(proposal.warranties).not_to include(warranty_from_rs)
          expect(proposal.warranties).not_to include(warranty_from_sc)
          expect(proposal.warranties).not_to include(warranty_from_pr)
        end
      end
    end
  end

  describe 'validar a proposta' do
    context 'valor do empréstimo maior ou igual a R$ 30.000,00 e menor que R$ 3.000.000,00' do
      it 'returns true' do
        loan_value = 30_000
        number_of_monthly_installments = 48
        main_proponent = instance_double(Proponent, main?: true, age: 18, monthly_income_for?: true)
        secondary_proponent = instance_double(Proponent, main?: false, age: 18)
        warranty = instance_double(Warranty, value: 100_000, province: 'SP')
        proposal = described_class.new(
          id: SecureRandom.uuid,
          loan_value: loan_value,
          number_of_monthly_installments: number_of_monthly_installments
        )
        proposal.add_proponent(main_proponent)
        proposal.add_proponent(secondary_proponent)
        proposal.add_warranty(warranty)
        subject = proposal.valid?
        expect(subject).to be true
      end
    end

    context 'valor do empréstimo inferior a R$ 30.000,00' do
      it 'returns false' do
        loan_value = 29_999
        number_of_monthly_installments = 48
        main_proponent = instance_double(Proponent, main?: true, age: 18, monthly_income_for?: true)
        secondary_proponent = instance_double(Proponent, main?: false, age: 18)
        warranty = instance_double(Warranty, value: 100_000, province: 'SP')
        proposal = described_class.new(
          id: SecureRandom.uuid,
          loan_value: loan_value,
          number_of_monthly_installments: number_of_monthly_installments
        )
        proposal.add_proponent(main_proponent)
        proposal.add_proponent(secondary_proponent)
        proposal.add_warranty(warranty)
        subject = proposal.valid?
        expect(subject).to be false
      end
    end

    context 'valor do empréstimo maior que R$ 3.000.000,00' do
      it 'returns false' do
        loan_value = 3_000_000.01
        number_of_monthly_installments = 48
        main_proponent = instance_double(Proponent, main?: true, age: 18, monthly_income_for?: true)
        secondary_proponent = instance_double(Proponent, main?: false, age: 18)
        warranty = instance_double(Warranty, value: 100_000, province: 'SP')
        proposal = described_class.new(
          id: SecureRandom.uuid,
          loan_value: loan_value,
          number_of_monthly_installments: number_of_monthly_installments
        )
        proposal.add_proponent(main_proponent)
        proposal.add_proponent(secondary_proponent)
        proposal.add_warranty(warranty)
        subject = proposal.valid?
        expect(subject).to be false
      end
    end



    context 'Apenas um proponente' do
      it 'returns false' do
        loan_value = 50_000
        number_of_monthly_installments = 48
        main_proponent = instance_double(Proponent, main?: true, age: 18)
        warranty = instance_double(Warranty, value: 100_000, province: 'SP')
        proposal = described_class.new(
          id: SecureRandom.uuid,
          loan_value: loan_value,
          number_of_monthly_installments: number_of_monthly_installments
        )
        proposal.add_proponent(main_proponent)
        proposal.add_warranty(warranty)
        subject = proposal.valid?
        expect(subject).to be false
      end
    end

    context 'dois propornetes' do
      it 'returns false' do
        loan_value = 50_000
        number_of_monthly_installments = 48
        main_proponent = instance_double(Proponent, main?: true, age: 18)
        secondary_proponent = instance_double(Proponent, main?: true, age: 18)
        warranty = instance_double(Warranty, value: 100_000, province: 'SP')
        proposal = described_class.new(
          id: SecureRandom.uuid,
          loan_value: loan_value,
          number_of_monthly_installments: number_of_monthly_installments
        )
        proposal.add_proponent(main_proponent)
        proposal.add_proponent(secondary_proponent)
        proposal.add_warranty(warranty)
        subject = proposal.valid?
        expect(subject).to be false
      end
    end

    context 'não existe proponente' do
      it 'returns false' do
        loan_value = 50_000
        number_of_monthly_installments = 48
        main_proponent = instance_double(Proponent, main?: false, age: 18)
        secondary_proponent = instance_double(Proponent, main?: false, age: 18)
        warranty = instance_double(Warranty, value: 100_000, province: 'SP')
        proposal = described_class.new(
          id: SecureRandom.uuid,
          loan_value: loan_value,
          number_of_monthly_installments: number_of_monthly_installments
        )
        proposal.add_proponent(main_proponent)
        proposal.add_proponent(secondary_proponent)
        proposal.add_warranty(warranty)
        subject = proposal.valid?
        expect(subject).to be false
      end
    end



    context 'exite garantia' do
      context "valor da garantia é o dobro do empréstimo" do
        it 'returns true' do
          loan_value = 50_000
          number_of_monthly_installments = 48
          main_proponent = instance_double(Proponent, main?: true, age: 18, monthly_income_for?: true)
          secondary_proponent = instance_double(Proponent, main?: false, age: 18)
          warranty = instance_double(Warranty, value: 100_000, province: 'SP')
          proposal = described_class.new(
            id: SecureRandom.uuid,
            loan_value: loan_value,
            number_of_monthly_installments: number_of_monthly_installments
          )
          proposal.add_proponent(main_proponent)
          proposal.add_proponent(secondary_proponent)
          proposal.add_warranty(warranty)
          subject = proposal.valid?
          expect(subject).to be true
        end
      end

      context "valor da garantia não é o dobro do emprestimo" do
        it 'returns false' do
          loan_value = 50_000
          number_of_monthly_installments = 48
          main_proponent = instance_double(Proponent, main?: true, age: 18, monthly_income_for?: true)
          secondary_proponent = instance_double(Proponent, main?: false, age: 18)
          warranty = instance_double(Warranty, value: 99_999, province: 'SP')
          proposal = described_class.new(
            id: SecureRandom.uuid,
            loan_value: loan_value,
            number_of_monthly_installments: number_of_monthly_installments
          )
          proposal.add_proponent(main_proponent)
          proposal.add_proponent(secondary_proponent)
          proposal.add_warranty(warranty)
          subject = proposal.valid?
          expect(subject).to be false
        end
      end
    end

    context 'duas ou mais garantias' do
      context "valor total é o dobro do valor do empréstimo" do
        it 'returns true' do
          loan_value = 50_000
          number_of_monthly_installments = 48
          main_proponent = instance_double(Proponent, main?: true, age: 18, monthly_income_for?: true)
          secondary_proponent = instance_double(Proponent, main?: false, age: 18)
          warranty = instance_double(Warranty, value: 50_000, province: 'SP')
          second_warranty = instance_double(Warranty, value: 50_000, province: 'SP')
          proposal = described_class.new(
            id: SecureRandom.uuid,
            loan_value: loan_value,
            number_of_monthly_installments: number_of_monthly_installments
          )
          proposal.add_proponent(main_proponent)
          proposal.add_proponent(secondary_proponent)
          proposal.add_warranty(warranty)
          proposal.add_warranty(second_warranty)
          subject = proposal.valid?
          expect(subject).to be true
        end
      end

      context "valor total não é o dobro do valor do empréstimo" do
        it 'returns false' do
          loan_value = 50_000
          number_of_monthly_installments = 48
          main_proponent = instance_double(Proponent, main?: true, age: 18, monthly_income_for?: true)
          secondary_proponent = instance_double(Proponent, main?: false, age: 18)
          warranty = instance_double(Warranty, value: 50_000, province: 'SP')
          second_warranty = instance_double(Warranty, value: 49_999, province: 'SP')
          proposal = described_class.new(
            id: SecureRandom.uuid,
            loan_value: loan_value,
            number_of_monthly_installments: number_of_monthly_installments
          )
          proposal.add_proponent(main_proponent)
          proposal.add_proponent(secondary_proponent)
          proposal.add_warranty(warranty)
          proposal.add_warranty(second_warranty)
          subject = proposal.valid?
          expect(subject).to be false
        end
      end
    end

    context 'sem garantia' do
      it 'returns false' do
        loan_value = 50_000
        number_of_monthly_installments = 48
        main_proponent = instance_double(Proponent, main?: true, age: 18, monthly_income_for?: true)
        secondary_proponent = instance_double(Proponent, main?: false, age: 18)
        proposal = described_class.new(
          id: SecureRandom.uuid,
          loan_value: loan_value,
          number_of_monthly_installments: number_of_monthly_installments
        )
        proposal.add_proponent(main_proponent)
        proposal.add_proponent(secondary_proponent)
        subject = proposal.valid?
        expect(subject).to be false
      end
    end
  end
end
