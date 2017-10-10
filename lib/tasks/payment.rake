namespace :payment do
  desc 'Create new payment'
  task create: :environment do
    organization = Organization.find_by!(domain: ENV['SUBDOMAIN'])
    organization.payments.create(
      date_from: Time.now,
      date_till: 1.month.from_now,
      amount: 0
    )
  end
end
