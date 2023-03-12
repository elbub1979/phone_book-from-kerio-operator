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
