# coding: utf-8
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  phone                  :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :string(255)
#  firstname              :string(255)
#  lastname               :string(255)
#  confirmation_number    :integer
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#

class User < ApplicationRecord
  include ActiveModel::Validations

  ROLES = %w(admin client).freeze

  has_one :my_organization, class_name: 'Organization', foreign_key: :owner_id, dependent: :destroy, validate: false
  has_one :telegram_user, -> { where(confirmed: true) }, foreign_key: :phone, primary_key: :phone
  has_many :workers, primary_key: 'phone', foreign_key: 'phone'
  has_many :organizations
  has_many :appointments
  has_many :appointments_by_phone, class_name: 'Appointment', foreign_key: :phone, primary_key: :phone
  has_many :addresses
  has_many :services_users, foreign_key: :phone, primary_key: :phone

  accepts_nested_attributes_for :addresses
  accepts_nested_attributes_for :my_organization

  validates :phone, :firstname, :lastname, presence: true
  validates :phone, uniqueness: true
  validates :email, presence: { if: :is_admin? }, format: { with: /\A[^@]+@[^@]+\z/, if: :is_admin? }
  validates :phone, format: { with: /\A[\d\W]+\z/ }
  validates :password, presence: { if: proc { |u| u.new_record? } }
  validates :password, confirmation: { if: proc { |u| !u.blank? } }
  validates :password, length: { within: 3..100, allow_blank: true }

  before_save :check_phone
  before_save :update_appointments

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :validatable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable, authentication_keys: [:phone]

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me, :my_organization_attributes, :firstname, :lastname, :phone, :role

  attr_writer :current_step

  def name
    [firstname, lastname].join(' ')
  end

  def current_step
    @current_step || steps.first
  end

  def steps
    %w(user activity organization working_hours confirmation)
  end

  def next_step
    self.current_step = steps[steps.index(current_step) + 1]
  end

  def previous_step
    self.current_step = steps[steps.index(current_step) - 1]
  end

  def all_valid?
    steps.all? do |step|
      self.current_step = step
      valid?
    end
  end

  def owner?(organization)
    my_organization == organization
  end

  def find_organization
    my_organization || (worker || appointments.first).try(:organization)
  end

  def worker(organization = nil)
    if organization
      workers.find_by(organization_id: organization.id)
    else
      workers.first
    end
  end

  def worker?(organization)
    worker(organization)
  end

  def owner_or_worker?(organization)
    !!(owner?(organization) || worker?(organization))
  end

  def recount_appointments_by_organization_for_services_users!(organization)
    appointments_by_phone.joins(:services).where(services: { id: services_users.where(organization_id: organization.id).pluck(:service_id).uniq }).pluck('appointments.id').uniq.each do |appointment_id|
      appointment = Appointment.find(appointment_id)
      appointment.cost_time_by_services!
      appointment.save
    end
  end

  def is_admin?
    role == 'admin'
  end

  def self.send_reset_password_instructions_by_phone(options)
    user = find_by(phone: options[:phone])

    return User.new(options) unless user

    user.confirmation_number = Random.new.rand(100_000..999_999)
    user.reset_password_token = Devise.token_generator.digest(self, :reset_password_token, user.confirmation_number)
    user.reset_password_sent_at = Time.now.utc
    user.save(validate: false)
    SmsJob.perform_later({ text: "Номер для восстановления пароля: #{user.confirmation_number}", phone: user.phone }, 'simple_notify')
    user
  end

  private

  def check_phone
    self.phone = "+7#{phone}" if phone.size == 10
  end

  def update_appointments
    phone_appointments = Appointment.where(phone: phone_was)

    %w(phone firstname lastname).each do |field|
      if send("#{field}_changed?")
        phone_appointments.update_all(field => send(field))
      end
    end
  end
end
