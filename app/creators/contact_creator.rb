class ContactCreator

  def initialize(contact)
      Contact.create(
        name:         contact[:name].capitalize,
        email:        contact[:email],
        phone:        contact[:phone],
        organization: contact[:organization]
      )
    end
  end
end