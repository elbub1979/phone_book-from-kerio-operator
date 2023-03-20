# frozen_string_literal: true

require 'rexml'

# этот класс обеспечивает взаимодействие с xls документом
class XmlDriver
  class << self
    def write_xml(contacts_collection, path)
      file = File.new("#{path}phonebook.xml", 'r:UTF-8')

      begin
        doc = REXML::Document.new(file)
      rescue REXML::ParseException => e # если парсер ошибся при чтении файла, придется закрыть прогу :(
        puts 'XML файл похоже битый :('
        abort e.message
      end

      file.close

      doc.elements.delete_all('YealinkIPPhoneBook/Menu/Unit')

      menu = doc.elements['YealinkIPPhoneBook'].elements['Menu']

      contacts_collection.each do |contact|
        menu.add_element 'Unit',
                         {
                           'Name' => contact.person,
                           'Phone1' => contact.phone_number,
                           'Phone2' => '',
                           'Phone3' => '',
                           'default_photo' => 'Resource:'
                         }
      end

      file = File.new("#{path}phonebook.xml", 'w:UTF-8')
      doc.write(file, 2)
      file.close

    end
  end
end
