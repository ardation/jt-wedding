class VisitorsController < ApplicationController
  class InviteNotFoundError < StandardError; end
  decorates_assigned :invite
  before_action :load_invite!
  rescue_from InviteNotFoundError, with: :redirect_to_new_invite_path

  def index; end

  protected

  def load_invite!
    @invite = Invite.find_by(id: session[:invite_id]) if session[:invite_id]
    raise InviteNotFoundError unless @invite
  end

  def redirect_to_new_invite_path
    redirect_to new_invite_path
  end
end
