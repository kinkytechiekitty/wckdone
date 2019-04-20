require 'sequel'
require 'logger'
require 'bcrypt'

DB = Sequel.connect("#{ENV['DATABASE_URL']}/wckdone",
                    max_connections: 10, loggers: [Logger.new($stdout)])

DB[:users].insert(
  username: 'admin',
  password_digest: BCrypt::Password.create('test123'),
  gender: 'male',
  into_males: true,
  into_females: true,
  birth_date: '1978-1-1',
  review_status: 'approved',
  is_super: true,
  is_admin: true,
  longitude: -121.8846,
  latitude: 37.3512)

(2..10000).each do |i|
  DB[:users].insert(
    id: i,
    username: rand(36**12).to_s(36),
    password_digest: 'dummy',
    gender: ['male', 'female'].sample,
    into_males: [true, false].sample,
    into_females: [true, false].sample,
    birth_date: Random.rand(Date.today.next_year(-60)...Date.today.next_year(-18)),
    verified_photo: 'image.jpg',
    review_status: ['pending', 'approved', 'rejected'].sample,
    longitude: -66.0 - Random.rand * 60.0,
    latitude: 25.0 + Random.rand * 23.0,
  )
  DB[:photos].insert(
    id: i,
    user_id: i,
    filename: 'image.jpg',
  )
end

