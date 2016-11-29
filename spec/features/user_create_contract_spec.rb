require 'rails_helper'

feature 'User create a contract' do
  scenario 'visiting #new' do
    visit root_path
    click_on 'Painel Administrativo'
    click_on 'Novo Contrato'
    expect(new_contract_path)
  end

  scenario 'successfully' do
    equipment = create(:equipment)
    contract = build(:contract, equipment: [equipment])
    equipment_name = get_equipment_name(equipment)

    visit new_contract_path

    fill_form(contract, equipment)

    click_on 'Gerar Contrato'

    expect(page).not_to have_content('Não foi possível criar contrato')
    expect(page).to have_css('h1', text: contract.customer.name)
    expect(page).to have_content(equipment_name)
    expect(page).to have_content(contract.rental_period)
    expect(page).to have_content(contract.delivery_address)
    expect(page).to have_content(contract.contact)
    expect(page).to have_content(contract.payment_method)
    expect(page).to have_content(contract.amount)
    expect(page).to have_content(contract.discount)
    expect(page).to have_content(contract.total_amount)
  end
  scenario 'unsuccessfully' do
    visit new_contract_path

    click_on 'Gerar Contrato'

    expect(page).to have_current_path(contracts_path)
    expect(page).to have_content('Não foi possível criar contrato')
  end

  scenario 'change equipment status' do
    equipment = create(:equipment, available: true)
    contract = build(:contract, equipment: [equipment])
    equipment_name = get_equipment_name(equipment)

    visit new_contract_path

    fill_form(contract, equipment)

    click_on 'Gerar Contrato'

    visit new_contract_path

    expect(page).to_not have_content(equipment_name)
  end

  private

  def get_equipment_name(equipment)
    "##{equipment.serial_number} -
      #{equipment.category.name}:
      #{equipment.description}"
  end

  def fill_form(contract, equipment)
    select_form(contract, equipment)
    fill_in_form(contract)
  end

  def fill_in_form(contract)
    fill_in 'Endereço de Entrega', with: contract.delivery_address
    fill_in 'Responsável', with: contract.contact
    fill_in 'Preço', with: contract.amount
    fill_in 'Desconto', with: contract.discount
    fill_in 'Preço Final', with: contract.total_amount
  end

  def select_form(contract, equipment)
    select contract.customer.name, from: 'Cliente'
    select equipment.description, from: 'Equipamentos'
    select contract.rental_period, from: 'Prazo de Locação'
    select contract.payment_method, from: 'Formas de Pagamento'
  end
end
