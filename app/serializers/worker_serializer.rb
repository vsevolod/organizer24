# == Schema Information
#
# Table name: workers
#
#  id                 :integer          not null, primary key
#  organization_id    :integer
#  name               :string(255)
#  is_enabled         :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  phone              :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  profession         :string(255)
#  dative_case        :string(255)
#  push_key           :string(255)
#  finished_date      :date
#  sms_translit       :boolean
#

class WorkerSerializer < ActiveModel::Serializer
  attributes :id, :name, :phone, :photo
  has_many :services

  def photo
    object.photo.url(:normal)
  end
end
