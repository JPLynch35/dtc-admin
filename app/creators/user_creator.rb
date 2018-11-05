class UserCreator

  def initialize(user)
      User.create(
        email:         user[:email],
        password:      user[:password]
      )
    end
  end
end