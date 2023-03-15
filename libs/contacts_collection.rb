# frozen_string_literal: true

require_relative 'contact'
require_relative 'operator'
require_relative 'xls_driver'
require_relative 'sqlite_driver'
require 'psych'
require 'logger'

# этот класс обеспечивает работу с колекцией контактов
class ContactsCollection
  @logger = Logger.new('main.log')
  @logger.level = Logger::INFO
  @logger.datetime_format = '%d/%m/%y %H:%M:%S'

  # константа для хранения контактов, запрещенных для отображения во внешнем справочнике телефонов
  PROHIBITION_COLLECTION = Psych.load_file('./configs/config.yml')['prohibited_collection'].freeze
  TOWNS_COLLECTION = Psych.load_file('./configs/config.yml')['towns_collection'].freeze

  attr_accessor :phones

  class << self
    # метод класса для получения контактов через класс Operator и создания экземпляра класса
    def external
      # получение контактов через с севера ip телефонии
      collection = Operator.contacts_collection
      # парсинг ответа для получения списка контактов
      data = collection.instance_variable_get(:@resp).parsed_response['result']['sipExtensionList']
      # создание массива контактов
      contacts = data.each.with_object([]) do |element, accum|
        next if inadmissible?(element) # следующий элемент, если текущий недопустим

        phone_number = element['telNum'].to_i # получаем номер телефона и присваиваем его соответствующей переменной
        person = element['FULL_NAME'] # получаем имя сотрудника и присваиваем его соответствующей переменной

        # получаем город и присваиваем его соответствующей переменной
        town = case phone_number
               when (100..599) then TOWNS_COLLECTION['msk']
               when (600..699) then TOWNS_COLLECTION['spb']
               when (700..799) then TOWNS_COLLECTION['srt']
               when (950..959) then TOWNS_COLLECTION['ngnsk']
               when (960..969) then TOWNS_COLLECTION['bvzm']
               else 'undefined'
               end

        # создаем экзеипляр класса Contact и добавляем его в массив
        accum << Contact.new(person: person, phone_number: phone_number, town: town)
      end
      # создание экземпляра класса PhoneCollection
      new(contacts)
    end

    def internal
      # получение контактов из локальной базы данных
      array = SqliteDriver.contacts_collection
      # создание массива контактов
      contacts = array.each_with_object([]) do |contact, accum|
        phone_number = contact[1] # получаем номер телефона и присваиваем его соответствующей переменной
        person = contact[2] # получаем имя сотрудника и присваиваем его соответствующей переменной
        town = contact[3] # получаем город и присваиваем его соответствующей переменной

        # создаем экзеипляр класса Contact и добавляем его в массив
        accum << Contact.new(person: person, phone_number: phone_number, town: town)
      end
      # создание экземпляра класса PhoneCollection
      new(contacts)
    end

    private

    # метод проверки допустимости контакта
    def inadmissible?(element)
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
    phones.size == other.phones.size &&
      phones.all? do |phone|
        other.phones.select do |other_phone|
          phone.person == other_phone.person && phone.phone_number == other_phone.phone_number
        end.any?
      end
  rescue StandardError
    @logger.error('ContactCollection#equal?')
  ensure
    # @logger.info('ContactCollection#equal?')
  end

  def repair(other)
    other.phones.each do |external_contact|
      contact = phones.find { |internal_contact| internal_contact.phone_number == external_contact.phone_number }

      next if contact.equal?(external_contact)

      if contact.nil?
        SqliteDriver.create(external_contact)
      else
        SqliteDriver.update(external_contact)
      end
    end
  end

  def remove_unnecessary(other)
    phones.each do |internal_contact|
      contact = other.phones.find { |external_contact| external_contact.phone_number == internal_contact.phone_number }
      SqliteDriver.destroy(internal_contact) if contact.nil?
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
