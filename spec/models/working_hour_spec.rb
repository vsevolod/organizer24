# == Schema Information
#
# Table name: working_hours
#
#  id              :integer          not null, primary key
#  week_day        :integer
#  begin_time      :integer
#  end_time        :integer
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  worker_id       :integer
#

require 'spec_helper'

describe WorkingHour do
  context 'Counting' do
    it 'should call fix_time' do
      wh = FactoryGirl.create(:working_hour, begin_hour: 10, begin_minute: 30, end_hour: 12, end_minute: 10)
      wh.send :fix_time
      wh.begin_time.should == 60 * 630
      wh.end_time.should   == 60 * 730
    end
  end
end
