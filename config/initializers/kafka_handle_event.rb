KafkaHandleEvent.register :user do
    topic 'EmploymentHero.AdminProducer'
  
    primary_column :id, :uuid
    map_column :email, :email
    map_column :password, :password
    map_column :authentication_token, :authentication_token
end
