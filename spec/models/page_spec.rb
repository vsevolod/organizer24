# == Schema Information
#
# Table name: pages
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  permalink       :string(255)
#  content         :text
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  menu_name       :string(255)
#

require 'spec_helper'

describe Page do
  context 'Page' do
    #
    #
    #
    #
  end
end
