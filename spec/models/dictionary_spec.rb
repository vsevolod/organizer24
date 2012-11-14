require "spec_helper"

describe Dictionary do

  context 'new Dictionary' do

    it 'should be have cache_ancestry on save' do
      parent = FactoryGirl.create :dictionary, :name => 'Parent'
      child  = FactoryGirl.build  :dictionary, :parent => parent
      child.save
      child.names_depth_cache.should match( parent.name )
    end

  end

end
