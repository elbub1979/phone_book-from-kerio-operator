# frozen_string_literal: true

require 'sqlite3'

# этот класс обеспечивает работу с базой даных
class SqliteDriver
  class << self
    def contacts_collection
      db = SQLite3::Database.new 'test.db'

      db.execute <<-SQL
         CREATE TABLE IF NOT EXISTS contacts (
         id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
         phone_number INTEGER UNIQUE NOT NULL DEFAULT 0,
         person VARCHAR NOT NULL DEFAULT '',
         town VARCHAR NOT NULL DEFAULT ''
      )
      SQL

      db.execute('select * from Contacts')
    end

    def create(contact)
      db = SQLite3::Database.new 'test.db'

      db.execute "INSERT INTO contacts (phone_number, person, town)
                      VALUES (?, ?, ?)",
                 %W[#{contact.phone_number} #{contact.person} #{contact.town}]
    end

    def update(contact)
      db = SQLite3::Database.new 'test.db'

      db.execute 'UPDATE contacts SET person=?, town=? WHERE phone_number=?',
                 %W[#{contact.person} #{contact.town} #{contact.phone_number}]
    end

    def destroy(contact)
      db = SQLite3::Database.new 'test.db'

      db.execute 'DELETE FROM contacts WHERE phone_number=?',
                 contact.phone_number
    end
  end
end
