Sequel.migration do
  up do
    create_table(:sessions) do
      primary_key :id
      String :token, null: false, unique: true
      Bignum :user_id, null: false
    end
  end

  down do
    drop_table :sessions
  end
end
