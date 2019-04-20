class Action < Sequel::Model
  def self.create_or_update args
    return if args[:source] == args[:destination]
    return unless ['like', 'pass', 'unmatch'].include?(args[:action])
    DB.transaction do 
      action = Action.find(source: args[:source], destination: args[:destination])
      reverse = Action.find(source: args[:destination], destination: args[:source])
      was_match = action&.action == 'like' && reverse&.action == 'like'
      if action.nil?
        action = Action.create args
      elsif action.action == 'unmatch'
        action.errors.add(':action', 'cannot be changed once it is unmatch')
      elsif was_match && args[:action] != 'unmatch'
        action.errors.add(:action, 'cannot be modified')
      else
        action.action = args[:action]
        action.save_changes
      end
      if Action.is_a_match?(args[:source], args[:destination])
        Message.send_system(args[:source], args[:destination], "It's a match!")
      end
    end
  rescue Sequel::Error
  end

  def self.is_a_match?(source, destination)
    filter = Sequel.lit('(source = ? AND destination = ? AND action = ?) OR ' +
                        '(source = ? AND destination = ? AND action = ?)',
                        source, destination, 'like',
                        destination, source, 'like')
    DB[:actions].where(filter).count == 2
  end
end
