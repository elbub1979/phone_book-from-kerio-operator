# frozen_string_literal: true

require 'dotenv'
require 'sqlite3'
require 'logger'

Dotenv.load('./configs/.env')

require_relative 'libs/contacts_collection'
require_relative 'libs/smb_driver'

logger = Logger.new('main.log')
logger.level = Logger::INFO
logger.datetime_format = '%d/%m/%y %H:%M:%S'

# SmbDriver.read_smb

# logging
# logger.debug('debug log message')
# logger.fatal('fatal log message')
# logger.unknown('unknown log message')

begin
  external_phones_collection = ContactsCollection.external
rescue StandardError
  logger.error('main#external_phones_collection: error')
ensure
  logger.info('main#external_phones_collection: success')
end

begin
  internal_phones_collection = ContactsCollection.internal
rescue StandardError
  logger.error('main#internal_phones_collection: error')
ensure
  logger.info('main#inernal_phones_collection: success')
end

exit if external_phones_collection.nil? || internal_phones_collection.nil?

if external_phones_collection.equal?(internal_phones_collection)
  logger.info('comparison of collections was successful')
else
  internal_phones_collection.repair(external_phones_collection)
  internal_phones_collection.remove_unnecessary(external_phones_collection)

  logger.warn('comparison of collections was unsuccessful: fixed')
end
