require 'rails_helper'

RSpec.describe User, type: :model do

  describe "User Attributes" do
    user = FactoryGirl.create(:user)
    task = FactoryGirl.create(:task, creator: user)

    it 'should contain a user id' do
      expect(user.id).to be_a(Fixnum)
    end

    it 'should contain a user provider' do
      expect(user.provider).to eq("google")
    end

    it 'should contain a user uid' do
      expect(user.uid).to eq("universal id")
    end

    it 'should contain a user email' do
      expect(user.email).to eq("john.doe@gmail.com")
    end

    it 'should contain a user name' do
      expect(user.name).to eq("John Doe")
    end

    it 'should contain a user oauth_token' do
      expect(user.oauth_token).to eq("oauth token")
    end

    it 'should contain a user oauth_expires_at' do
      expect(user.oauth_expires_at).to be_a(Time)
    end

    it 'should contain a user refresh token' do
      expect(user.refresh_token).to eq("refresh token")
    end

    it 'should contain a default_time_increment' do
      expect(user.default_time_increment).to eq(15)
    end

    it 'should contain a snooze_until Time' do
      expect(user.snooze_until).to be_a(Time)
    end

  end

  describe "User Relationships" do
    user = FactoryGirl.create(:user)
    task = FactoryGirl.create(:task, creator: user)


    it 'should have many tasks' do
      expect(user.tasks[0]).to eq(task)
    end

  end

  describe "User Instance Methods" do
    user = FactoryGirl.create(:user)
    task = FactoryGirl.create(:task, creator: user)


    it 'should return the number of completed tasks' do
      expect(user.total_count).to eq(1)
    end

    it 'should return total of all time boxes' do
      expect(user.total_time_box).to eq(15)
    end

    it 'should return total of all time boxes' do
      expect(user.total_task_time).to eq(0)
    end

    it 'should return total difference between timebox and actual time' do
      expect(user.total_difference).to eq(15)
    end

    it 'should return average priority' do
      expect(user.average_priority).to eq(2)
    end

    it 'should return average difference' do
      expect(user.average_difference).to eq(15)
    end

    it 'should have alerts enabled by default' do
      expect(user.show_alerts).to be true
    end

    it 'should have alerts disabled if show_alerts is set to false' do
      user.alerts_enabled = false
      expect(user.show_alerts).to be false
    end
  end

  describe "testing the sorting of events" do
    user = FactoryGirl.create(:user)
    let!( :event_1 ){OpenStruct.new('start' => OpenStruct.new("dateTime" => DateTime.iso8601('2015-05-12T11:30:00-05:00')), 'end' => OpenStruct.new("dateTime" => DateTime.iso8601('2015-05-12T12:00:00-05:00')))}
    let!( :event_2 ){OpenStruct.new('start' => OpenStruct.new("dateTime" => DateTime.iso8601("2015-05-12T13:30:00-05:00")), 'end' => OpenStruct.new("dateTime" => DateTime.iso8601("2015-05-12T15:30:00-05:00")))}
    let!( :events ){ [event_1, event_2] }

    it 'should return the array count of 2' do
      expect(events.count).to eq(2)
    end

    it 'should return the array count of 4' do
      expect(user.sort_upcoming_events(events).count).to eq(4)
    end

    it 'should return start for first event' do
      expect(user.sort_upcoming_events(events)[0][0]).to eq(:start)
    end

    it 'should return time of the first event' do
      expect(user.sort_upcoming_events(events)[0][2]).to eq(DateTime.iso8601("2015-05-12T11:30:00-05:00").to_i)
    end

    it 'should return end for last event' do
      expect(user.sort_upcoming_events(events)[3][0]).to eq(:end)
    end

    it 'should return time of the last event' do
      expect(user.sort_upcoming_events(events)[3][2]).to eq(DateTime.iso8601("2015-05-12T15:30:00-05:00").to_i)
    end
  end

  describe "User#from_omniauth" do
    user = FactoryGirl.create(:user)
    task = FactoryGirl.create(:task, creator: user)
    let!( :auth ){OpenStruct.new('provider' => 'google', 'uid' => 'uid', 'credentials' => OpenStruct.new('token' => '12345', 'refresh_token' => '111111111a', 'expires_at' => Time.now + 360), 'info' => OpenStruct.new('name' => 'test', 'email' => 'test@test.com'))}

    it 'should return a user' do
      expect(User.from_omniauth(auth)).to be_a(User)
    end

    it 'should return a provider' do
      expect(User.from_omniauth(auth).provider).to eq("google")
    end

    it 'should return a uid' do
      expect(User.from_omniauth(auth).uid).to eq("uid")
    end
  end

  describe "User#pending_tasks" do
    new_user = FactoryGirl.create(:user)
    first_task = FactoryGirl.create(:task, creator: new_user, end_time: nil)
    second_task = FactoryGirl.create(:task, creator: new_user, end_time: nil)
    third = FactoryGirl.create(:task, creator: new_user)
    it "should return an a list of tasks without an end time" do
      expect(new_user.pending_tasks.count).to eq(2)
    end
      it "should not include tasks with end times" do
      expect(new_user.pending_tasks.count).to eq(2)
    end
  end

  describe "User.current_task" do
    user = FactoryGirl.create(:user)
    two_task = FactoryGirl.create(:task, creator: user, end_time: nil)
    task = FactoryGirl.create(:task, creator: user, start_time: nil, end_time: nil)
    three_task = FactoryGirl.create(:task, creator: user, end_time: nil)
    it "should return the first task with a start time and no end time" do
      expect(user.current_task).to eq(two_task)
    end

    it "should only return 1 task" do
      expect(user.current_task).to eq(two_task)
    end
  end
end