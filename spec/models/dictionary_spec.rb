# == Schema Information
#
# Table name: dictionaries
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  tag               :string(255)
#  ancestry          :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  names_depth_cache :string(255)
#  organization_id   :integer
#  dictionary_id     :integer
#

require 'spec_helper'

describe Dictionary do
  context 'new Dictionary' do
    it 'should be have cache_ancestry on save' do
      parent = FactoryGirl.create :dictionary, name: 'Parent'
      child  = FactoryGirl.build  :dictionary, parent: parent
      child.save
      child.names_depth_cache.should match(parent.name)
    end
  end
end
