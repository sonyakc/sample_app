require 'twilio-ruby'

class MicropostsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user, only: :destroy

  # put your own credentials here
  ACCOUNT_SID = ''
  AUTH_TOKEN = ''

  # set up a client to talk to the Twilio REST API
  TWILIO_CLIENT = Twilio::REST::Client.new ACCOUNT_SID, AUTH_TOKEN

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      send_sms_message @micropost.content
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  def send_sms_message message
    TWILIO_CLIENT.account.messages.create(
        :from => '+15512265607',
        :to => '',
        :body => "Here is your PostUp: #{message}"
    )
    rescue Twilio::REST::RequestError
  end

  private
    def correct_user
      @micropost = current_user.microposts.find(params[:id])
      rescue
        redirect_to root_url
    end
end
