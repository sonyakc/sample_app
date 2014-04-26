require 'spec_helper'

describe Micropost do
	let(:user) {
		FactoryGirl.create(:user)
	}

	before do
		# This code is wrong!
    	# @micropost = Micropost.new content: "Lorem ipsum", user_id: user.id
    	@micropost =  user.microposts.build content: "Lorem ipsum"
	end

	subject { @micropost }
	it { should respond_to(:content) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
  	its(:user) { should == user }

	it { should be_valid }

	describe 'accessible attributes' do
		it 'should not allow access to user_id' do
			expect do
				Micropost.new(user_id: user.id)
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

	describe 'when user id is not present' do
		before { @micropost.user_id = nil }
		it { should_not be_valid }
	end

	describe 'with content longer than 140 characters' do
		before { @micropost.content = 'a' * 141 }
		it { should_not be_valid }
	end

	describe 'with nil content' do
		before { @micropost.content = nil }
		it { should_not be_valid }
	end

	describe 'with empty string content' do
		before { @micropost.content = '' }
		it { should_not be_valid }
	end

	describe 'without a user id' do
		before { @micropost.user_id = nil }
		it { should_not be_valid }
	end
end
