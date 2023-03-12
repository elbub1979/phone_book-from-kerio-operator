# frozen_string_literal: true
require 'psych'

# этот класс обеспечивает работу с yaml файлами
class YmlDriver
  class << self
    def def_def
      Psych.safe_load('--- foo') # => 'foo'
    end
  end
end
