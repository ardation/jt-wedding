# frozen_string_literal: true

class Visitors::InvitesController < VisitorsController
  skip_before_action :load_invite!, only: %i[choose find new create]

  def choose; end

  def find
    code = params.dig(:invite, :code) || params[:code]
    find_invite(code)
    return redirect_to root_path if @invite

    flash[:error] = 'Hmm. That code is not quite right. Try again!' if code
  end

  def new
    build_invite
    @invite.people.build
  end

  def create
    build_invite
    return render 'new' unless save_invite

    flash[:success] =
      'Woohoo! We have received your request for an invite. We will send you an invite in the coming weeks!'
    redirect_to root_path
  end

  def edit; end

  def update
    build_invite
    return render 'edit' unless save_invite

    flash[:success] = 'Woohoo! We have received your RSVP.'
    redirect_to root_path
  end

  protected

  def find_invite(code)
    @invite = Invite.find_by(code: code.upcase) if code.present?
    session[:invite_id] = @invite&.id
  end

  def build_invite
    @invite ||= Invite.new
    @invite.attributes = invite_create_params.merge(rsvp: false) if params[:action] == 'create'
    @invite.attributes = invite_update_params.merge(rsvp: true) if params[:action] == 'update'
  end

  def save_invite
    @invite.save
  end

  def invite_create_params
    return {} unless params[:invite]

    params.require(:invite).permit(
      :style, :email_address, :street, :suburb, :city, :postal_code, :country, :phone,
      people_attributes: %i[first_name last_name gender age]
    )
  end

  def invite_update_params
    return {} unless params[:invite]

    params.require(:invite).permit(:food_type, people_attributes: %i[id coming])
  end
end
