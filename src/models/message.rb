class Message < Sequel::Model
  def before_create
    if self.message && self.message.length > 0
      self.message = sanitize(self.message)
    end
    self.sent_on ||= DateTime.now
    super
  end

  def self.send_system(src, dst, msg)
    sent_on = DateTime.now
    Message.create(user_id: src, peer_id: dst, message: msg,
                   is_outgoing: false, is_incoming: true, is_system: true,
                   sent_on: sent_on)
    Message.create(user_id: dst, peer_id: src, message: msg,
                   is_outgoing: false, is_incoming: true, is_system: true,
                   sent_on: sent_on)
  end
  
  def self.send(src, dst, msg, photo = nil)
    return if photo == nil && (msg.nil? || msg.length == 0)
    sent_on = DateTime.now
    Message.create(user_id: src.id, peer_id: dst.id, message: msg, photo: photo,
                   is_outgoing: true, is_incoming: false, is_system: false,
                   sent_on: sent_on)
    Message.create(user_id: dst.id, peer_id: src.id, message: msg, photo: photo,
                   is_outgoing: false, is_incoming: true, is_system: false,
                   sent_on: sent_on)
  end

  def self.mark_read(messages)
    read_on = DateTime.now
    to_update = messages.select{ |m| m.read_on.nil? }.map{ |m| m.id }
    return if to_update.empty?
    DB[:messages].where(id: to_update).update(read_on: read_on)
  end
  
  def self.get_between(user_a, user_b)
    Message.where(user_id: user_a.id, peer_id: user_b.id).order(:sent_on).all
  end

  def self.get_latest(user, matches)
    ids = matches.map { |m| m.id }
    filter = Sequel.lit(
      'id IN (SELECT max(id) FROM messages WHERE user_id = ? AND peer_id IN ? GROUP BY peer_id)',
      user.id, ids)
    Message.where(filter).reverse(:sent_on).to_h { |m| [m.peer_id, m] }
  end

  def self.count_unread_for(user)
    Message.where(user_id: user.id, is_incoming: true, read_on: nil).count()
  end
end
