set :output, './cron_log.log'

every 1.minute do
  command 'ruby main.rb'
end
