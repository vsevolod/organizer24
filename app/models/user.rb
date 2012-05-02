class User < ActiveRecord::Base

  ROLES = %w{admin client}

  has_one :my_organization, :class_name => "Organization", :foreign_key => :owner_id, :dependent => :destroy, :validate => false
  has_many :organization
  accepts_nested_attributes_for :my_organization

  validates_presence_of :email, :if => :first_step?
  validates_uniqueness_of :email, :allow_blank => true, :if => lambda{|u| u.email_changed? && u.first_step? }
  validates_format_of :email, :with => /\A[^@]+@[^@]+\z/, :allow_blank => true, :if => lambda{|u| u.email_changed? && u.first_step? }

  validates_format_of :phone, :with => /^[\d\W]+$/, :allow_blank => true, :if => lambda{|u| u.phone_changed? && u.first_step? }

  validates_presence_of :password, :if => :first_step?
  validates_confirmation_of :password, :if => :first_step?
  validates_length_of :password, :within => 3..100, :allow_blank => true, :if => :first_step?

  validates_associated :my_organization, :if => lambda{ |u| u.steps.index(u.current_step) >= 2 }
  

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :validatable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :my_organization_attributes, :name, :phone

  attr_writer :current_step

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

end
