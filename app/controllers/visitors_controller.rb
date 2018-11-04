class VisitorsController < ApplicationController
  class InviteNotFoundError < StandardError; end
  decorates_assigned :invite
  before_action :load_invite!
  rescue_from InviteNotFoundError, with: :invite_not_found

  def index; end

  def reset
    reset_session
    redirect_to root_path
    flash[:success] = 'Thanks for visiting! Hopefully we will see you soon.'
  end

  protected

  def load_invite!
    @invite = Invite.find_by(id: session[:invite_id]) if session[:invite_id]
    raise InviteNotFoundError unless @invite
  end

  def invite_not_found
    redirect_to choose_invite_path
  end
end
