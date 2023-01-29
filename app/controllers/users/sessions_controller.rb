class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted? 
      user_details = {
        :id => current_user.id,
        :email => current_user.email 
      }
      render json: { :success => true, :user => user_details }
    else
      render json: { :success => false, :error => "Invalid credentials!" }
    end
  end

  def respond_to_on_destroy
    # head :no_content
    current_user ? log_out_success : log_out_failure
  end

  def log_out_success
    render json: { message: "Logged out." }, status: :ok
  end

  def log_out_failure
    render json: { message: "Logged out failure."}, status: :unauthorized
  end
end