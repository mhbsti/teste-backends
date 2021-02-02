require 'spec_helper'
require_relative '../../domain/proponent'

describe Proponent do
  describe 'é o proponente principal ' do
    context 'proponente' do
      it 'returns true' do
        main = true

        subject = described_class.new(id: nil, proposal_id: nil, name: nil, age: nil, monthly_income: nil, main: main)

        expect(subject).to be_main
      end
    end

    context 'não é um proponente principal' do
      it 'returns false' do
        main = false

        subject = described_class.new(id: nil, proposal_id: nil, name: nil, age: nil, monthly_income: nil, main: main)

        expect(subject).not_to be_main
      end
    end
  end

  describe 'renda mensal parcelamento' do
    context "idade de 18 a 24 anos" do
      context "renda mensal do proponente é de no mínimo 4 vezes o valor da parcela" do
        it 'returns true' do
          age = 18
          monthly_income = 4_000
          installment = 1_000

          subject = described_class.new(
            id: nil, proposal_id: nil, name: nil, age: age, monthly_income: monthly_income, main: nil
          ).monthly_income_for?(installment)

          expect(subject).to be true
        end
      end

      context "renda mensal do proponente é inferior a 4 vezes o valor da parcela" do
        it 'returns false' do
          age = 18
          monthly_income = 3_999
          installment = 1_000

          subject = described_class.new(
            id: nil, proposal_id: nil, name: nil, age: age, monthly_income: monthly_income, main: nil
          ).monthly_income_for?(installment)

          expect(subject).to be false
        end
      end
    end

    context "idade de 24 a 50 anos" do
      context "renda mensal do proponente é de no mínimo 3 vezes o valor da parcela" do
        it 'returns true' do
          age = 24
          monthly_income = 3_000
          installment = 1_000

          subject = described_class.new(
            id: nil, proposal_id: nil, name: nil, age: age, monthly_income: monthly_income, main: nil
          ).monthly_income_for?(installment)

          expect(subject).to be true
        end
      end

      context "renda mensal do proponente é inferior a 3 vezes o valor da parcela" do
        it 'returns false' do
          age = 24
          monthly_income = 2_999
          installment = 1_000

          subject = described_class.new(
            id: nil, proposal_id: nil, name: nil, age: age, monthly_income: monthly_income, main: nil
          ).monthly_income_for?(installment)

          expect(subject).to be false
        end
      end
    end
    
  end
end
