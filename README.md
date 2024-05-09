##Телефонный справочник Kerio Operator
###Краткое описание

---
Программа предназначена для обновления телефонного справочника.

---

###Скачивание, настрока и запуск программы

---
1. Скачать программу: в терминале перейти в директорию, куда планируется установка программы и выполнить следующую команду -

```
git clone https://github.com/elbub1979/phone_book-from-kerio-operator.git
```
2. Установка гемов: в терминале перейти в директорию, куда установили программу и выполнить следующую команду -
```
bundle install
```
3. Создать файлы в каталоге ./configs/:
  - .env
  - config.yml
4. Заполнить файл .env:
```

```
5. Заполнить файл config.yml
```
# исключение контактов из справочника
prohibited_collection:
  - contacts

# города (ключ / значение)
towns_collection:
  msk: Москва

# путь к файлам 
xls_path: '//192.168.x.x/path/to/folder/'
xml_path: '//192.168.x.x//path/to/folder//'

# точки монтирования
xls_mount: '/mnt/xls/'
xml_mount: '/mnt/xml/'

# имена конечных файлов
phonebook_xls: 'Справочник IP телефонии.xlsx'
phonebook_xml: 'phonebook.xml'
```
6. Монтирование smb хостовую ОС (в примере Ubuntu)
 - открыть файл .etc/fstab
 - добавить следующий код в конец файла:
```
//192.168.x.x/path/to/smb/share/ /mnt/mount/share/ cifs user,rw,username=remote admin,password=remote admin password,iocharset=utf8,,file_mode=0777,dir_mode=0777,uid=1000,gid=1000 0 0 

//192.168.x.x/path/to/smb/share/ /mnt//mount/share/ cifs user,rw,username=remote admin,password=remote admin password,iocharset=utf8,file_mode=0777,dir_mode=0777,uid=1000,gid=1000 0 0
```
где: 
 - username - адммиистратор ххх
 - password - пароль xxx
 - uid – задает владельца каталога. Узнать uid пользователей можно в файле /etc/passwd или ввести команду в терминале: id -u имя_пользовтеля
 - gid – задает группу владельца каталога. Узнать gid групп можно в файле /etc/passwd
 - file_mode=0777 – права на доступ к файлам. 0777 – разрешено запись/чтение всем.
 - dir_mode=0777 – права на доступ к папкам. 0777 – разрешено запись/чтение всем.
 
7. Запуск программы: в терминале перейти в директорию, куда установили программу и выполнить следующую команду -

```
bundle exec ruby main.rb
```
