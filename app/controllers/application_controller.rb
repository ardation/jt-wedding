class ApplicationController < ActionController::Base
  class InviteNotFoundError < StandardError; end
  attr_accessor :invite
  before_action :load_invite!
  rescue_from InviteNotFoundError, with: :invite_not_found

  def index; end

  protected

  def load_invite!
    @invite = Invite.find_by(id: session[:invite_id]) unless session[:invite_id]
    raise InviteNotFoundError unless @invite
  end

  def invite_not_found
    redirect_to new_invite_path
  end
end
