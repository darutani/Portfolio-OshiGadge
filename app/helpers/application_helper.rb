module ApplicationHelper
  def user_avatar_image_tag(user, options = {})
    if user.avatar.attached?
      image_tag user.avatar, options
    else
      image_tag "default_icon_image.png", options
    end
  end

  def default_meta_tags
    {
      site: 'OshiGadge −推しガジェ−',
      title: '自分の所有するガジェットの”推しポイント”を共有できるサービス',
      reverse: true,
      separator: '|',
      description: '「OshiGadge −推しガジェ−」は、自分の所有するガジェットの”推しポイント”を共有できるサービスです。あなたの推しガジェを投稿して、みんなに共有しよう！また、みんなのこだわりの推しポイントに共感してガジェット好きで交流しよう！',
      keywords: 'OshiGadge, 推しガジェ, ガジェット',
      charset: 'UTF-8',
      canonical: request.original_url,
      noindex: !Rails.env.production?,
      icon: [
        { href: image_url('favicon.png'), sizes: '32x32' },
        { href: image_url('icon_logo.png'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/png' },
      ],
      og: {
        site_name: 'OshiGadge −推しガジェ−',
        title: '自分の所有するガジェットの”推しポイント”を共有できるサービス',
        description: '「OshiGadge −推しガジェ−」は、自分の所有するガジェットの”推しポイント”を共有できるサービスです。あなたの推しガジェを投稿して、みんなに共有しよう！また、みんなのこだわりの推しポイントに共感してガジェット好きで交流しよう！',
        type: 'website',
        url: request.original_url,
        image: image_url('ogp.png'),
        locale: 'ja_JP',
      },
      twitter: {
        card: 'summary_large_image',
        site: '@darutani0913',
      },
    }
  end
end
