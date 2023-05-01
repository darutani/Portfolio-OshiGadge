module ApplicationHelper
  def user_avatar_image_tag(user, options = {})
    if user.avatar.attached?
      image_tag user.avatar, options
    else
      image_tag "default_icon_image.png", options
    end
  end
end
