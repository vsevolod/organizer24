# coding:utf-8
require "spec_helper"

describe Appointment do

  appointment = FactoryGirl.build( :valid_appointment )
  organization = appointment.organization

  it 'should not be valid appointment' do
    appointment.should be_valid
  end

  context 'count cost and time by services' do

    it 'should return cost and time by services after create' do
      appointment.cost_time_by_services!
      appointment.cost.should equal( appointment.services.map(&:cost).sum )
      appointment.showing_time.should equal( appointment.services.map(&:showing_time).sum )
    end

    it 'should not change cost after update time of service' do
      appointment.cost = -1
      appointment.start += 1.hour
      appointment.cost_time_by_services!
      appointment.cost.should equal( -1 )
    end

    it 'should find multi services' do
      multi_services_appointment = FactoryGirl.build(:multi_services_appointment)
      multi_services_appointment.cost_time_by_services!
      multi_services_appointment.cost.should equal( multi_services_appointment.organization.services.where(:is_collection => true).sum(:cost) )
    end

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

  context 'editable by user' do

    before(:all) do
      appointment.first_owner_view
    end

    it 'should be editable by owner of organization' do
      appointment.editable_by?(organization.owner).should be_true
    end

    it 'should be editable by appointment user' do
      appointment.editable_by?(appointment.user).should be_true
    end

    it 'should not be editable by user with same phone' do
      user_with_phone = User.new( :phone => appointment.phone )
      appointment.editable_by?(user_with_phone).should be_false
    end

    it 'should be editable by user with same phone if owner create appointment' do
      appointment.user = organization.owner
      user_with_phone = User.new( :phone => appointment.phone )
      appointment.editable_by?(user_with_phone).should be_true
    end

  end

  context 'notify users' do
    before :all do
      appointment.can_not_notify_owner = false
    end

    it 'should send 2 notify when appointment saved' do
      lambda{ appointment.save }.should change(Delayed::Job, :count).by(2)
    end

    it 'should not create notification when send to owner number' do
      appointment.phone = organization.owner.phone
      lambda{ appointment.save }.should_not change(Delayed::Job, :count)
    end

  end

end
