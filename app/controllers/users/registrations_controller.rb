class Users::RegistrationsController < Devise::RegistrationsController
  before_action :ensure_normal_user, only: %i[update destroy]

  def update
    success = update_resource_without_redirect

    if success
      case params[:form_type]
      when 'profile_edit'
        redirect_to mygadgets_user_path(current_user.id) and return
      when 'account_edit'
        bypass_sign_in(resource) if sign_in_after_change_password?
        redirect_to account_user_path(current_user.id) and return
      end
    else
      case params[:form_type]
      when 'profile_edit'
        render 'users/edit_profile' and return
      when 'account_edit'
        render :edit and return
      end
    end
  end

  def destroy
    resource.destroy
    if resource.destroyed?
      flash[:notice] = "お客様のアカウントは正常に削除されました。"
      redirect_to root_path
    else
      flash[:alert] = "アカウントの削除にエラーが発生しました。"
      redirect_back(fallback_location: root_path)
    end
  end

  private

  # ゲストユーザーの場合は編集・削除できないようにする
  def ensure_normal_user
    if resource.email == 'guest@example.com'
      redirect_to root_path, alert: 'ゲストユーザーの更新・削除はできません。'
    end
  end

  # ユーザー情報の項目により変更時のパスワードの有無を判断する
  def update_resource(resource, params)
    if params[:email].present? || params[:password].present?
      # メールアドレス/パスワードの更新の場合には現在のパスワードが必要
      resource.update_with_password(params)
    else
      # ユーザー名/自己紹介/アバター画像の更新の場合には現在のパスワードは不要
      resource.update_without_current_password(params)
    end
  end

  # 更新を試みて成功・失敗をブール値で返す（リダイレクトなし）
  def update_resource_without_redirect
    update_resource(resource, account_update_params)
  end
end
