class Service < ActiveRecord::Base

  scope :not_collections, where( "is_collection != 't' OR is_collection IS NULL" )

  belongs_to :organization
  has_and_belongs_to_many :appointments

  has_many :collections_services, :foreign_key => :collection_id
  has_many :services, :through => :collections_services
  has_many :services_workers
  has_many :workers, :through => :services_workers

  accepts_nested_attributes_for :collections_services

  validates :name, :presence => true, :uniqueness => { :scope => [:organization_id] }
  validates :showing_time, :presence => true

  def full_info( joins = ' / ' )
    [self.name, self.showing_time.show_time, self.cost].join(joins)
  end

end
