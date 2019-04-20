Sequel.migration do
  up do
    create_table(:photos) do
      primary_key :id
      Bignum :user_id
      String :filename
    end
  end

  down do
    drop_table :photos
  end
end
