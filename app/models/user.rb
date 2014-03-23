#coding: utf-8
class User < ActiveRecord::Base
  include ActiveModel::Validations

  ROLES = %w{admin client}

  has_one :my_organization, :class_name => "Organization", :foreign_key => :owner_id, :dependent => :destroy, :validate => false
  has_many :workers, :primary_key => 'phone', :foreign_key => 'phone'
  has_many :organizations
  has_many :appointments
  has_many :appointments_by_phone, :class_name => "Appointment", :foreign_key => :phone, :primary_key => :phone
  has_many :services_users, :foreign_key => :phone, :primary_key => :phone
  accepts_nested_attributes_for :my_organization

  validates_presence_of :phone, :firstname, :lastname
  validates_uniqueness_of :phone
  validates :email, :presence => { :if => :is_admin? }, :format => {:with => /\A[^@]+@[^@]+\z/, :if => :is_admin?}

  validates_format_of :phone, :with => /^[\d\W]+$/

  validates_presence_of :password
  validates_confirmation_of :password
  validates_length_of :password, :within => 3..100, :allow_blank => true
  before_save :check_phone

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :validatable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable, :authentication_keys => [:phone]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :my_organization_attributes, :firstname, :lastname, :phone, :role

  attr_writer :current_step

  def name
    [firstname, lastname]*' '
  end

  def current_step
    @current_step || steps.first
  end

  def steps
    %w[ user activity organization working_hours confirmation ]
  end

  def next_step
    self.current_step = steps[steps.index(current_step)+1]
  end

  def previous_step
    self.current_step = steps[steps.index(current_step)-1]
  end

  def all_valid?
    steps.all? do |step|
      self.current_step = step
      valid?
    end
  end

  def owner?( organization )
    self.my_organization == organization
  end

  def find_organization
    self.my_organization || (self.worker || self.appointments.first).try(:organization)
  end

  def worker(organization = nil)
    if organization
      self.workers.where(organization_id: organization.id).first
    else
      self.workers.first
    end
  end

  def worker?( organization )
    self.worker(organization)
  end

  def owner_or_worker?(organization)
    self.owner?(organization) || self.worker?(organization)
  end

  def recount_appointments_by_organization_for_services_users!( organization )
    self.appointments_by_phone.joins(:services).where(:services => { :id => self.services_users.where( :organization_id => organization.id ).pluck(:service_id).uniq } ).pluck("appointments.id").uniq.each do |appointment_id|
      appointment = Appointment.find( appointment_id )
      appointment.cost_time_by_services!
      appointment.save
    end
  end

  def is_admin?
    self.role == 'admin'
  end

  def self.send_reset_password_instructions_by_phone(options)
    if user = self.find_by_phone(options[:phone])
      user.reset_password_token = Random.new.rand(100000..999999)
      user.reset_password_sent_at = Time.now.utc
      user.save(:validate => false)
      Delayed::Job.enqueue SmsJob.new({:text => "Номер для восстановления пароля: #{user.reset_password_token}", :phone => user.phone}, 'simple_notify' ), :run_at => Time.zone.now
      user
    else
      User.new(options)
    end
  end

  private

    def check_phone
      if self.phone.size == 10
        self.phone = "+7#{self.phone}"
      end
    end

end
