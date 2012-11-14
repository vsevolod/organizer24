# coding:utf-8
require "spec_helper"

describe Appointment do

  fixtures :services
  appointment = FactoryGirl.build( :valid_appointment )

  it 'should not be valid appointment' do
    appointment.should be_valid
  end

  it 'should return cost and time by services' do
    appointment.cost_time_by_services!
    appointment.cost.should equal( appointment.services.map(&:cost).sum )
    appointment.showing_time.should equal( appointment.services.map(&:showing_time).sum )
  end

  context 'validates' do

    it 'should have-not save with same time and organization' do
      appointment1 = FactoryGirl.create( :valid_appointment, :status => 'offer' )
      appointment2 = FactoryGirl.build(  :valid_appointment, :status => 'offer' )
      appointment2.valid?

      appointment2.should_not be_valid
      (appointment2.errors.values * ' ').should match( 'время уже занято' )

    end

  end


end
