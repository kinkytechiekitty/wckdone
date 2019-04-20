#!/bin/sh

export DATABASE_URL="mysql2://wckdone:password@127.0.0.1"
export APP_ENV="development"

ruby db/create_database.rb && sequel -m db/migrations $DATABASE_URL/wckdone && ruby test/create_users.rb

rerun 'rackup --host 0.0.0.0 -p 4567'
