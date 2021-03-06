require 'rails_helper'

RSpec.describe Contract, type: :model do
  it 'should be valid' do
    contract = Contract.create
    expect(contract.errors[:customer]).to include('deve existir')
  end
  it { should validate_presence_of(:equipment) }
  it { should validate_presence_of(:rental_period) }
  it { should validate_presence_of(:delivery_address) }
  it { should validate_presence_of(:payment_method) }
  it { should validate_presence_of(:delivery_address) }

  describe '#contract_code' do
    before do
      @contract = create(:contract)
    end

    it 'should return correct contract code' do
      expect(@contract.contract_code).to eq(
        @contract.created_at.to_i + @contract.id
      )
    end
  end

  describe 'validate equipment' do
    it 'should not save with invalid equipment' do
      equipment = create(:equipment, available: false)

      contract = build(:contract, equipment: [equipment])

      expect(contract.valid?).to be_falsey
    end
  end

  describe 'amount' do
    it 'should return sum of equipment prices' do
      equipment = create_list(:equipment, 2)
      contract = create(:contract, equipment: equipment)
      equipment.each do |equip|
        create(
          :rental_equipment,
          contract: contract,
          equipment: equip,
          amount: 50
        )
      end

      expect(contract.amount).to eq(100)
    end
  end
end
