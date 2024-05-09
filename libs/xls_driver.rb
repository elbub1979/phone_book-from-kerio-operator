# frozen_string_literal: true

require 'rubyXL'
require 'rubyXL/convenience_methods'

# этот класс обеспечивает взаимодействие с xls документом
class XlsDriver
  class << self
    def write_xsl(collection, path, file_name)
      # открываем телефонный справочник xlsx
      workbook = RubyXL::Parser.parse("#{path}#{file_name}")
      worksheet = workbook[0]
      worksheet.sheet_data[0]
      # переименовываем вкладку
      worksheet.sheet_name = 'Телефонный справочник'
      # удаляем содержимое
      worksheet.delete_column(0)
      worksheet.delete_column(1)

      # форматируем таблицу
      # worksheet.change_column_bold(0, true) # Makes A1 bold
      # worksheet.change_column_italics(0, true) # Makes first row italicized
      # worksheet.change_column_font_name(0, 'Courier') # Makes first column have font Courier

      worksheet.change_column_width(0, 41) # изменяем ширину столбца А
      worksheet.change_column_width(1, 25) # изменяем ширину столбца B
      worksheet.change_column_horizontal_alignment(0, 'center') # выравнимаем по центру горизонтали содержимое столбца А
      worksheet.change_column_horizontal_alignment(1, 'center') # выравнимаем центру горизонтали содержимое столбца B
      worksheet.change_column_vertical_alignment(0, 'center') # выравнимаем по центру вертикали содержимое столбца А
      worksheet.change_column_vertical_alignment(1, 'center') # выравнимаем центру вертикали содержимое столбца B

      worksheet.add_cell(0, 0, 'Сотрудник')
      worksheet.add_cell(0, 1, 'Номер телефона')
      worksheet.change_row_height(0, 20)
      worksheet.change_row_horizontal_alignment(0, 'center')
      worksheet.change_row_vertical_alignment(0, 'center')

      row_to_merge = []
      collection.group_by(&:town).flatten(2).each.with_index(1) do |element, index|
        if element.is_a?(String)
          worksheet.add_cell(index, 0, element)
          row_to_merge << index
          worksheet.change_row_height(index, 20)
        else
          worksheet.add_cell(index, 0, element.person)
          worksheet.add_cell(index, 1, element.phone_number)
          worksheet.change_row_height(index, 20)
        end
      end

      row_to_merge.each do |element|
        worksheet.merge_cells(element, 0, element, 1)
        worksheet.sheet_data[element][0].change_font_bold(true)
        worksheet.change_row_horizontal_alignment(element, 'center')
        worksheet.change_row_vertical_alignment(element, 'center')
      end

      workbook.write("#{path}#{file_name}")
    end
  end
end
