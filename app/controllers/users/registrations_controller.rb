class Users::RegistrationsController < Devise::RegistrationsController
  before_action :ensure_normal_user, only: %i[update destroy]

  def update
    super do |resource|
      if resource.errors.empty?
        case params[:form_type]
        when 'profile_edit' then redirect_to mygadgets_user_path(current_user.id) and return
        when 'account_edit' then redirect_to account_user_path(current_user.id) and return
        end
      end
    end
  end

  private

  def ensure_normal_user
    if resource.email == 'guest@example.com'
      redirect_to root_path, alert: 'ゲストユーザーの更新・削除はできません。'
    end
  end

  def update_resource(resource, params)
    resource.update_without_current_password(params)
  end
end
