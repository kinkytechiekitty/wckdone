Sequel.migration do
  up do
    create_table(:users) do
      primary_key :id
      String :username, null: false, unique: true
      Date :birth_date, null: false
      String :gender, null: false
      Boolean :into_females, null: false
      Boolean :into_males, null: false
      String :password_digest, null: false
      Boolean :is_admin, null: false, default: false
      Boolean :is_super, null: false, default: false
      String :email 
      Boolean :email_notifications
      Boolean :is_email_verified
      String :email_verification_token
      String :review_status
      Bignum :reviewer_id
      Datetime :reviewed_on
      String :review_reason
      String :verified_photo
      Datetime :verified_photo_uploaded_on
      Text :description
      Datetime :last_visit
      String :last_ip
      String :location
      Float :longitude
      Float :latitude
      String :search_id
      index [:review_status, :into_females, :gender, :longitude]
      index [:review_status, :into_males, :gender, :longitude]
      index [:review_status, :into_females, :longitude]
      index [:review_status, :into_males, :longitude]
      index [:review_status, :verified_photo_uploaded_on]
      full_text_index [:description]
    end
  end

  down do
    drop_table :users
  end
end
