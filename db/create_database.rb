require 'logger'
require 'redis'
require 'sequel'

REDIS = Redis.new

url = if ENV['DATABASE_URL'].include? 'postgresql'
        "#{ENV['DATABASE_URL']}/postgres"
      else
        ENV['DATABASE_URL']
      end
DB = Sequel.connect(url,
                    max_connections: 10, loggers: [Logger.new($stdout)])

DB.execute('DROP DATABASE IF EXISTS wckdone')
DB.execute('CREATE DATABASE wckdone')

REDIS.flushall
