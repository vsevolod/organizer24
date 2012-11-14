require "spec_helper"

describe WorkingHour do
  context 'Counting' do
    it 'should call fix_time' do
      wh = FactoryGirl.create(:working_hour, :begin_hour => 10, :begin_minute => 30, :end_hour => 12, :end_minute => 10 )
      wh.send :fix_time
      wh.begin_time.should == 60*630
      wh.end_time.should   == 60*730
    end
  end
end
