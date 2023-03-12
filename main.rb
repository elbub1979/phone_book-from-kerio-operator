# frozen_string_literal: true

require 'dotenv'
require 'sqlite3'

Dotenv.load('./configs/.env')

require_relative 'libs/contacts_collection'

# yaml_keys = YamlDriver.read_yml
# yaml_keys.size do |key, value|
#   eval("ENV['#{key}] = #{value}")
# end


external_phones_collection = ContactsCollection.external
internal_phones_collection = ContactsCollection.internal

if external_phones_collection.equal?(internal_phones_collection)
  puts 'equal'
else
  internal_phones_collection.repair(external_phones_collection)
end

# internal_phones_collection = ContactsCollection.internal(external_phones_collection.phones)
# internal_phones_collection = ContactsCollection.new([Contact.new({person: 'Леушкин Илья Александрович', number: '111'} )])

# unless external_phones_collection.equal?(internal_phones_collection)
#   puts 'update phonebook'
# end

# puts external_phones_collection.to_s

# puts external_phones_collection

# operator.Session.logout

# user = User.create_with(fname: fname, lname: lname, pname: pname, email: email).find_or_create_by!(login: username)
# phone = InternalPhone.find_or_create_by!(number: number)

# phone.update_attribute(:user, user)
