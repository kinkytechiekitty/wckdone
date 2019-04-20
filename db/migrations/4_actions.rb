Sequel.migration do
  up do
    create_table(:actions) do
      primary_key :id
      Bignum :source
      Bignum :destination
      String  :action
      index [:source, :destination], unique: true
      index [:source, :destination, :action]
      index [:destination, :source, :action]
    end
  end

  down do
    drop_table :actions
  end
end
