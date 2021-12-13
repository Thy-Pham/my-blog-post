KafkaHandleEvent.register :user do
    topic 'EmploymentHero.AdminProducer'
  
    primary_column :id, :uuid
    map_column :email, :email
    map_column :password, :password
    map_column :authentication_token, :authentication_token

    # After create
    do_create do |record, message|
        p "Record do_create: #{record}"
        p "Created"
    end
end
