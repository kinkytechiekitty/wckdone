Sequel.migration do
  up do
    create_table(:messages) do
      primary_key :id
      Bignum   :user_id
      Bignum   :peer_id
      String    :message
      String    :photo
      Datetime :sent_on
      Datetime :read_on
      Boolean   :is_outgoing
      Boolean   :is_incoming
      Boolean   :is_system
      index [:user_id, :peer_id, :sent_on]
    end
  end

  down do
    drop_table :messages
  end
end
