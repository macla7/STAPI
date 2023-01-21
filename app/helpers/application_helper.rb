module ApplicationHelper
  def is_admin?
    return if current_user&.admin?

    respond_to do |format|
      format.json { render json: { error: 'You are not authorised to access this page, my friend.'}, status: :unauthorized }
      format.html { redirect_to new_user_session_path, notice: 'You are not authorised to access this page, my friend.' }
    end
  end
end
