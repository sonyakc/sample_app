require 'twilio-ruby'

class MicropostsController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user, only: :destroy

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

  # put your own credentials here
  account_sid = 'ACec6c58fed976f6ee496ab92bcf782794'
  auth_token = '77069e5d6491966ec9095604414e0040'

  # set up a client to talk to the Twilio REST API
  @@client = Twilio::REST::Client.new account_sid, auth_token

  def send_sms_message message_to_post
    @@client.account.messages.create(
        :from => '+15512265607',
        :to => '+12019180627',
        :body => message_to_post
    )
  end

  private
    def correct_user
      @micropost = current_user.microposts.find(params[:id])
      rescue
        redirect_to root_url
    end
end
