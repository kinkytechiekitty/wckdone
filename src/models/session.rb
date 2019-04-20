class Session
  attr_accessor :token, :user_id

  def initialize(token, user_id)
    @token = token
    @user_id = user_id
  end
  
  def self.create(user_id)
    session = Session.new SecureRandom.hex(64), user_id
    session.save
    session
  end

  def self.find(token)
    user_id = REDIS.with do |conn|
      conn.get("session:#{token}")
    end
    return nil unless user_id
    Session.new token, user_id.to_i
  end

  def save
    REDIS.with do |conn|
      conn.set("session:#{token}", user_id)
    end
  end

  def user
    User.find(id: user_id)
  end

  def delete
    REDIS.with do |conn|
      conn.del(token)
    end
  end
end
