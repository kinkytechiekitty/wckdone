require 'raven'
require './src/app'

use Rack::Static, :urls => ['/static']

use Raven::Rack
run App
