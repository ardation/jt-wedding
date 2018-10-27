class InvitesController < ApplicationController
  skip_before_action :load_invite!, only: %i[new create]

  def new; end

  def create
    load_invite
    return redirect_to root_path if @invite

    flash[:error] = 'Hmm. That code is not quite right. Try again!'
    render 'new'
  end

  def edit; end

  def update
    build_invite
    return render 'edit' unless save_invite

    flash[:success] = 'Woohoo! We have received your RSVP.'
    redirect_to root_path
  end

  def destroy
    reset_session
    redirect_to root_path
    flash[:success] = 'Thanks for visiting! Hopefully we will see you soon.'
  end

  protected

  def load_invite
    @invite = Invite.find_by(code: params[:invite][:code].upcase)
    session[:invite_id] = @invite&.id
  end

  def build_invite
    @invite.attributes = invite_params.merge(rsvp: true)
  end

  def save_invite
    @invite.save
  end

  def invite_params
    return {} unless params[:invite]
    params.require(:invite).permit(:food_type, people_attributes: %i[id coming])
  end
end
