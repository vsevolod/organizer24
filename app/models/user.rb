class User < ActiveRecord::Base

  ROLES = %w{admin client}

  has_one :my_organization, :class_name => "Organization", :foreign_key => :owner_id, :dependent => :destroy, :validate => false
  has_many :organization
  has_many :appointments
  has_many :appointments_by_phone, :class_name => "Appointment", :foreign_key => :phone, :primary_key => :phone
  has_many :services_users, :foreign_key => :phone, :primary_key => :phone
  accepts_nested_attributes_for :my_organization

  validates_presence_of :phone, :firstname, :lastname, :if => :first_step?
  validates_uniqueness_of :phone
  validates :email, :presence => { :if => :email_changed_and_first_admin_step? }, :format => { :with => /\A[^@]+@[^@]+\z/, :if => :email_changed_and_first_admin_step? }

  validates_format_of :phone, :with => /^[\d\W]+$/, :allow_blank => true, :if => lambda{|u| u.phone_changed? && u.first_step? }

  validates_presence_of :password, :if => :first_step?
  validates_confirmation_of :password, :if => :first_step?
  validates_length_of :password, :within => 3..100, :allow_blank => true, :if => :first_step?

  validates_associated :my_organization, :if => lambda{ |u| u.steps.index(u.current_step) >= 2 }
  before_save :check_phone

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :validatable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable

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

  def first_step?
    self.current_step == steps.first
  end

  # FIXME надо проверять на == admin, а не != client
  def first_admin_step?
    self.role != 'client' && self.current_step == steps.first
  end

  def email_changed_and_first_admin_step?
    email_changed? && first_admin_step?
  end

  def last_step?
    self.current_step == steps.last
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

  def recount_appointments_by_organization_for_services_users!( organization )
    self.appointments_by_phone.joins(:services).where(:services => { :id => self.services_users.where( :organization_id => organization.id ).pluck(:service_id).uniq } ).pluck("appointments.id").uniq.each do |appointment_id|
      appointment = Appointment.find( appointment_id )
      appointment.cost_time_by_services!
      appointment.save
    end
  end

  private

    def check_phone
      if self.phone.size == 10
        self.phone = "+7#{self.phone}"
      end
    end

end
