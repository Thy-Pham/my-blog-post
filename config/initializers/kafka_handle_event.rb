KafkaHandleEvent.register :user do
    topic 'EmploymentHero.AdminProducer'
  
    primary_column :id, :uuid
    map_column :email, :email
    map_column :password, :password
    map_column :password_confirmation, :password_confirmation

    on_create do |record, _raw_message|
        p records
        p 'Create new user from kafka'
    end
end
