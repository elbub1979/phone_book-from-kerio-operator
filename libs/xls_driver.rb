# frozen_string_literal: true

require 'rubyXL'
require 'rubyXL/convenience_methods'

# этот класс обеспечивает взаимодействие с xls документом
class XlsDriver
  class << self
    def read_xsl
      # RubyXL::Workbook.new
      workbook = RubyXL::Parser.parse('test.xlsx')
      worksheet = workbook[0]
      p worksheet.sheet_data[0]
      # worksheet.insert_row(1)
      # worksheet.add_cell(1, 0, 'Yakovlev Evgeniy Nikolaevich')
      # worksheet.add_cell(1, 1, '102')
      # worksheet.add_cell(0, 0, 'Имя')
      # worksheet.add_cell(0, 1, 'Номер')
      # workbook.write('test.xlsx')
    end

    def write_xsl(collection)
      # RubyXL::Workbook.new
      workbook = RubyXL::Parser.parse('test.xlsx')
      worksheet = workbook[0]
      worksheet.sheet_data[0]
      worksheet.sheet_name = 'Phones'

      worksheet.delete_column(0)
      worksheet.delete_column(1)

      worksheet.change_column_width(0, 41)
      worksheet.change_column_width(1, 10)

      # worksheet.sheet_data[0][0].change_font_bold(true) # Makes A1 bold

      worksheet.merge_cells(0, 0, 0, 1)
      worksheet.change_column_horizontal_alignment(0, 'center')

      worksheet.add_cell(0, 0, 'Москва')

      collection.with_index(1) do |phone, index|
        worksheet.add_cell(index, 0, phone.person)
        worksheet.add_cell(index, 1, phone.number)
      end

      worksheet.change_column_bold(0, true) # Makes A1 bold
      worksheet.change_column_italics(0, true) # Makes first row italicized
      worksheet.change_column_font_name(0, 'Courier') # Makes first column have font Courier

      # worksheet.insert_row(1)
      # worksheet.add_cell(1, 0, 'Yakovlev Evgeniy Nikolaevich')
      # worksheet.add_cell(1, 1, '102')
      # worksheet.add_cell(0, 0, 'Имя')
      # worksheet.add_cell(0, 1, 'Номер')
      workbook.write('test.xlsx')

      workbook = RubyXL::Workbook.new
      worksheet = workbook[0]
      worksheet.sheet_name = 'Phones'

      worksheet.merge_cells(0, 0, 1, 1)
      workbook.write('test2.xlsx')
    end
  end
end
