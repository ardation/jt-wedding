class InvitesController < ApplicationController
  skip_before_action :load_invite!, on: %i[new create]

  def new; end

  def create
    load_invite
    return redirect_to root_path if @invite
    render 'new'
  end

  protected

  def load_invite
    @invite = Invite.find_by(code: params[:invite][:code].upcase)
    session[:invite_id] = @invite&.id
  end
end
