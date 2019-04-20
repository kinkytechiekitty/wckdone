require 'bcrypt'
require 'logger'
require 'sanitize'
require 'sequel'

SANITIZECONFIG = Sanitize::Config.freeze_config(
  :elements => [],
  :attributes => {
  },
  :protocols => {
  })

DB = Sequel.connect("#{ENV['DATABASE_URL']}/wckdone", max_connections: 10,
                   loggers: [Logger.new($stdout)])

Dir['./src/models/*.rb'].each{ |f| require f }
Dir['./src/workers/*.rb'].each{ |f| require f }

def sanitize(html)
  Sanitize.fragment(html, SANITIZECONFIG)
end
