# frozen_string_literal: true

require_relative 'phone'
require_relative 'operator'
require_relative 'xls_driver'
require_relative 'sqlite_driver'
require 'psych'


# этот класс обеспечивает работу с колекцией контактов
class PhonesCollection
  # константа для хранения контактов, запрещенных для отображения во внешнем справочнике телефонов
  PROHIBITION_COLLECTION = Psych.load_file('./configs/config.yml')['prohibited_collection'].freeze
  TOWNS_COLLECTION = Psych.load_file('./configs/config.yml')['towns_collection'].freeze

  attr_accessor :phones

  class << self
    # метод класса для получения контактов через класс Operator и создания экземпляра класса
    def external
      # получения контактов через класс Operator
      collection = Operator.contacts_collection
      # парсинг ответа для получения списка контактов
      data = collection.instance_variable_get(:@resp).parsed_response['result']['sipExtensionList']
      # создание массива контактов
      data.each.with_object([]) do |element, array|
        next if permissible?(element)

        person = element['FULL_NAME']
        number = element['telNum']

        town = case number.to_i
               when (100..699) then TOWNS_COLLECTION['msk']
               when (700..799) then TOWNS_COLLECTION['spb']
               when (800..899) then TOWNS_COLLECTION['srt']
               when (900..999) then TOWNS_COLLECTION['rnd']
               else 'undefined'
               end

        array << Phone.new(person: person, number: number, town: town)
      end
      # создание экземпляра класса PhoneCollection
      new(phones)
    end

    def internal
      # phones = SqliteDriver.contacts_collection

      # new(phones)
    end

    private

    # метод проверки допустимости контакта
    def permissible?(element)
      element['FULL_NAME'].empty? || prohibition?(element) || element['telNum'].to_i > 1000
    end

    # метод для проверки наличия контакта в списке запрещенных для отображения
    def prohibition?(element)
      PROHIBITION_COLLECTION.include?(element['FULL_NAME'])
    end
  end

  def initialize(phones)
    @phones = phones
  end

  # метод для сравнения коллекций контактов, полученных с сервера ip телефонии и сохранных ранее
  def equal?(other)
    @phones.size == other.phones.size &&
      @phones.any? do |phone|
        other.phones.each do |other_phone|
          return true if phone.person == other_phone.person && phone.number == other_phone.number
        end
      end
  end

  # строковое представление коллекии контактов
  def to_s
    <<~PHONECOLLECTION
        #{
        phones.group_by(&:town).map do |key, value|
          "#{key.to_s.capitalize}\n#{value.map(&:to_s).join("\n")}"
        end.join("\n")
      }
    PHONECOLLECTION
  end
end
