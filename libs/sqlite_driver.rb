# frozen_string_literal: true

require 'sqlite3'

# этот класс обеспечивает работу с базой даных
class SqliteDriver
  class << self
    def contacts_collection
      db = SQLite3::Database.new 'test.db'

      db.empty?

      phoned = db.execute('select * from phones')
    end
  end
end
