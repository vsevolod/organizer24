namespace :onetime do
  desc 'Fix phones for users'
  task fix_users_phones: :environment do
    failed_users = []

    User.where('phone NOT LIKE ?', '+7%').each do |user|
      phone = user.phone

      new_phone =
        case phone
        when /^7/
          phone.gsub(/^7/, '+7')
        when /^8/
          phone.gsub(/^8/, '+7')
        when /^9/
          '+7' + phone
        else
          failed_users << [user.id, phone].join(', ')
          next
        end
      new_phone.gsub!(/( |-|\(|\))/, '')

      if new_phone.size != 12
        failed_users << [user.id, phone].join(': ')
        next
      end

      existing_user = User.find_by(phone: new_phone)

      if existing_user && existing_user != user
        actual_user = [user, existing_user].max_by{ |u| u.last_sign_in_at || 100.years.ago }
        old_user = ([user, existing_user] - [actual_user]).first

        old_user.appointments.update_all(phone: new_phone, user_id: actual_user.id)
        old_user.services_users.destroy
        old_user.destroy

        actual_user.update(phone: new_phone)
      else
        user.appointments.update_all(phone: new_phone)
        user.services_users.update_all(phone: new_phone)
        user.update(phone: new_phone)
      end

      puts [new_phone, phone].join(', ')
    end
    puts '==== FAILED ===='
    puts failed_users.join("\n")
  end
end
