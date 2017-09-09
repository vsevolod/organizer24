module ConnectService
  extend self

  def generate!(telegram_user, user)
    return if telegram_user.confirmed

    telegram_user.phone = user.phone
    telegram_user.confirmation_number = confirmation_number
    telegram_user.save!
  end

  def connect!(telegram_user, user)
    telegram_user.update!(confirmed: true)
  end

  def confirmation_number
    SecureRandom.rand(100_000..999_999)
  end
end
