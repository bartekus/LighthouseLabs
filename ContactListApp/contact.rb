require_relative 'phone_number'
require_relative 'address'

class Contact
  
  attr_writer :first_name, :middle_name, :last_name
  attr_reader :phone_numbers, :addresses

  def initialize
    @phone_numbers = []
    @addresses = []
  end

  def add_phone_number(kind, number)
    phone_number = PhoneNumber.new
    phone_number.kind = kind
    phone_number.number = number
    phone_numbers.push(phone_number)
  end

  def add_address(kind, street_1, street_2, city, province, postal_code)
    address = Address.new
    address.kind = kind
    address.street_1 = street_1
    address.street_2 = street_2
    address.city = city
    address.province = province
    address.postal_code = postal_code
    addresses.push(address)
  end

  def first_name
    @first_name
  end

  def middle_name
    @middle_name
  end

  def last_name
    @last_name
  end

  def first_last
    first_name + ' ' + last_name
  end

  def full_name
    full_name = first_name
    if !@middle_name.nil?
      full_name += ' '
      full_name += middle_name
    end
    full_name += ' '
    full_name += last_name
    full_name
  end

  def last_first
    last_first = last_name
    last_first += ', '
    last_first += first_name
    if !@middle_name.nil?
      last_first += ' '
      last_first += middle_name.slice(0, 1)
      last_first += '.'
    end
    last_first
  end

  def to_s(format = 'full_name')
    case format
    when 'full_name' then full_name
    when 'last_first' then last_first
    when 'first' then first_name
    when 'last' then last_name
    else first_last
    end
  end

  def print_phone_numbers
    puts 'Phone Numbers'
    phone_numbers.each { |phone_number| puts phone_number }
  end

  def phone_numbers_single_line
    phone_numbers.each { |phone_number| phone_number.to_s }
  end

  def print_addresses
    puts 'Addresses'
    addresses.each { |address| puts address.to_s('short') }
  end

  def addresses_single_line
    addresses.each { |address| address.to_s('short') }
  end

  def to_a
    [last_first,phone_numbers_single_line, addresses_single_line]
  end
end


