# frozen_string_literal: true

require 'kerio-api'
require 'uri'

# этот класс обеспечивает взаимодействие с сервером ip телефонии
class Operator
  class << self
    # метод класса для чтения данных с сервером ip телефонии
    def contacts_collection
      # создаём новое подключение
      operator = Kerio::Api::Client.new(url: URI.parse(ENV['kerio_operator_url']),
                                        insecure: true)
      # авторизация на сервере ip телефонии
      operator.Session.login(userName: ENV['kerio_operator_user'], password: ENV['kerio_operator_password'],
                             application: { name: 'operator', vendor: 'kerio', version: 'current' })
      # получение списка контактов
      operator.Extensions.get("query": { "start": 0, "limit": -1,
                                         "orderBy": [{ "columnName": 'FULL_NAME', "direction": 'Asc' }] })

    end
  end
end
