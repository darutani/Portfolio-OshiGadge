require 'rails_helper'

RSpec.describe 'gadgets#top', type: :system do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:gadget) { create(:gadget, user: user) }
  let!(:gadgets) { create_list(:gadget, 3, user: user) }
  let!(:users) { create_list(:user, 3) }

  context "ログイン前" do
    before do
      visit root_path
    end

    it 'いいねアイコンをクリックするとログイン画面へ遷移する' do
      within("#likes-#{gadget.id}") do
        find('.like-button').click
        expect(current_path).to eq new_user_session_path
      end
    end

    it 'コメントアイコンをクリックするとログイン画面へ遷移する' do
      find('.comment-button', match: :first).click
      expect(current_path).to eq new_user_session_path
    end

    it 'ユーザー一覧の各ユーザー名の横にフォローボタンが表示されない' do
      expect(page).not_to have_selector('.following-btn')
      expect(page).not_to have_selector('.follow-btn')
    end

  end

  context "ログイン後" do
    before do
      sign_in user
      visit root_path
    end

    it 'いいねアイコンをクリックするといいねアイコンが紺色に変化しいいね数が+1される、さらにいいねアイコンをクリックするとアイコンが白色に戻りいいね数が-1される', js: true do

      within("#likes-#{gadget.id}") do
        expect(find('.like-button i')['class']).to include('far')
        expect(find('.like-button i')['class']).not_to include('fas')
        expect(find('.like-button').text.to_i).to eq 0

        find('.like-button').click
        wait_for_ajax

        expect(find('.like-button i')['class']).to include('fas')
        expect(find('.like-button i')['class']).not_to include('far')
        expect(find('.like-button').text.to_i).to eq 1

        find('.like-button').click
        wait_for_ajax

        # find('.like-button i.far')
        expect(page).to have_css('.like-button i.far')
        expect(find('.like-button i')['class']).to include('far')
        expect(find('.like-button i')['class']).not_to include('fas')
        expect(find('.like-button').text.to_i).to eq 0
      end
    end

    it 'いいねアイコンをクリックすると、その投稿のいいねしたユーザー一覧ページにいいねしたユーザーが追加されている', js: true do
      within("#likes-#{gadget.id}") do
        find('.like-button').click
      end
        visit liked_users_gadget_path(gadget)
        expect(page).to have_content(user.name)
    end

    it 'いいね済みのいいねアイコンをクリックすると、その投稿のいいねしたユーザー一覧ページからいいねを解除したユーザーが削除されている', js: true do
      within("#likes-#{gadget.id}") do
        find('.like-button').click
        wait_for_ajax

        find('.like-button').click
        wait_for_ajax
      end
        visit liked_users_gadget_path(gadget)
        expect(page).not_to have_content(user.name)
    end

    it 'コメントアイコンをクリックすると、コメント一覧ページへ遷移する' do
      within("#comments-#{gadget.id}") do
        find('.comment-button').click
        expect(current_path).to eq gadget_comments_path(gadget)
      end
    end

    it 'ユーザー一覧の各ユーザー名の横にフォローボタンが表示される' do
      within("#follow-form-#{user2.id}") do
        expect(page).to have_selector('.follow-btn')
      end
    end

    it 'フォローボタンをクリックすると、フォローボタンがフォロー中へ変わる' do

    end

    it 'フォロー中のユーザーのフォローボタンをクリックすると、フォローボタンがフォローへ変わる' do

    end

    it 'フォローボタンをクリックすると、フォローされたユーザーのフォロワー一覧ページにフォローしたユーザーが追加される' do

    end

    it 'フォロー中のユーザーのフォローボタンをクリックすると、フォローされたユーザーのフォロワー一覧ページからフォローしたユーザーが削除される' do

    end

    it '未フォローユーザーをフォローすると、自分のフォロー一覧ページにそのユーザーが追加される' do

    end

    it 'フォロー中のユーザーをフォロー解除すると、自分のフォロー一覧ページからそのユーザーが削除される' do

    end
  end
end




#     it 'タイトルと説明文を表示する' do
#       expect(page).to have_content 'OshiGadge'
#       expect(page).to have_content '−推しガジェ−'
#       expect(page).to have_content '自分の推しのガジェットを共有しよう'
#       expect(page).to have_content 'あの人が使っている推しガジェットをチェックしよう'
#     end

#     it 'ユーザーがログインしていない場合、登録ボタンとログインボタンを表示する' do
#       expect(page).to have_link '新規登録', href: new_user_registration_path
#       expect(page).to have_link 'ログイン', href: new_user_session_path
#       expect(page).to have_link 'ゲストログイン', href: users_guest_sign_in_path
#     end

#     it '新規登録ボタンを押すと、新規登録ページに遷移する' do
#       within('.registration-login-btn') do
#         click_link '新規登録'
#       end
#       expect(current_path).to eq new_user_registration_path
#     end

#     it 'ログインボタンを押すと、ログインページに遷移する' do
#       within('.registration-login-btn') do
#         click_link 'ログイン'
#       end
#       expect(current_path).to eq new_user_session_path
#     end

#     it 'ゲストログインボタンを押すと、ゲストユーザーとしてログインする' do
#       within('.registration-login-btn') do
#         click_link 'ゲストログイン'
#       end
#       expect(current_path).to eq root_path
#       expect(page).to have_content 'ゲストユーザーとしてログインしました。'
#     end

#     it '"新着投稿一覧はこちら"のリンクを押すと、新着一覧ページへ遷移する' do
#       within('.lists-title:first-child') do
#         click_link '新着投稿一覧はこちら'
#       end
#       expect(current_path).to eq gadgets_path
#     end

#     it '最大１０個の新着ガジェットを表示する' do
#       create_list(:gadget, 11, user: user) # 11個目以上のガジェットを作成する
#       within('.lists:first-child') do
#         gadgets[0..9].each do |gadget|
#           expect(page).to have_content gadget.name
#           expect(page).to have_content gadget.category
#         end
#         expect(page).not_to have_content gadgets[10].name
#         expect(page).not_to have_content gadgets[10].category
#       end
#     end

#     it '新着投稿欄のユーザー名をクリックすると、そのユーザーの詳細ページへ遷移する' do
#       within(".list-item:first-child") do
#         find(".user-name-sm").click
#       end

#       expect(current_path).to eq(mygadgets_user_path(user))
#     end

#     it 'いいねアイコンをクリックすると、ログインページへ遷移する' do
#       within("#likes-and-comments-#{gadget.id}") do
#         find('.like-button').click
#       end
#       expect(current_path).to eq(new_user_session_path)
#     end

#     it 'コメントアイコンをクリックすると、ログインページへ遷移する' do
#       find('.fa-regular:first-child').click
#       expect(current_path).to eq(new_user_session_path)
#     end

#     it '"＞ 投稿詳細へ"ボタンをクリックすると、ガジェット詳細ページへ遷移する' do
#       click_link '＞ 投稿詳細へ', match: :first
#       expect(current_path).to eq gadget_path(gadget)
#     end

#     it '"新着投稿一覧はこちら"のリンクを押すと、新着一覧ページへ遷移する' do
#       within('.list-link-container:first-child') do
#         click_link '新着投稿一覧はこちら'
#       end
#       expect(current_path).to eq gadgets_path
#     end

#     it '"ユーザー一覧はこちら"のリンクを押すと、ユーザー一覧ページへ遷移する' do
#       within('.lists-title:nth-child(2)') do
#         click_link 'ユーザー一覧はこちら'
#       end
#       expect(current_path).to eq users_path
#     end

#     it '最大１０人のユーザーを表示する' do
#       create_list(:user, 11)
#       within('.lists:nth-child(2)') do
#         users[0..9].each do |user|
#           expect(page).to have_content user.name
#         end
#         expect(page).not_to have_content users[10].name
#       end
#     end

#     it 'ユーザー欄のユーザー名をクリックすると、そのユーザーの詳細ページへ遷移する' do
#       within('.user-name-only:first-child') do
#         click_link user.name
#       end
#       expect(current_path).to eq mygadgets_user_path(user)
#     end

#     it '未ログインの場合、ユーザー名横のフォローボタンが表示されない' do
#       within("#follow-form-<%= user.id %>") do
#         expect(page).not_to have_button('.follow-btn')
#       end
#     end

#     it 'フォロー数をクリックすると、そのユーザーのフォロー一覧ページへ遷移する' do

#     end

#     it 'フォロワー数をクリックすると、そのユーザーのフォロワー一覧ページへ遷移する' do

#     end
  
#     it '"＞ ユーザー詳細へ"ボタンをクリックすると、そのユーザーのユーザー詳細ページへ遷移する' do

#     end

#     it 'ユーザーの投稿したガジェット画像が最大４枚まで表示される' do

#     end

#     it '"ユーザー一覧はこちら"のリンクを押すと、ユーザー一覧ページへ遷移する' do

#     end

#   end
  
#   context "ログイン後" do

#     before do
#       sign_in user
#       visit root_path
#     end
    
#     it 'ユーザーがログインしている場合、登録ボタンとログインボタンを表示しない' do
#       within('.registration-login-btn') do
#         expect(page).not_to have_link '新規登録', href: new_user_registration_path
#         expect(page).not_to have_link 'ログイン', href: new_user_session_path
#         expect(page).not_to have_link 'ゲストログイン', href: users_guest_sign_in_path
#       end
#     end

#     it 'いいねアイコンをクリックすると、いいね数が１増える' do
#       within("#likes-and-comments-#{gadget.id}") do
#         expect { find('.like-button').click }.to change { gadget.likes.count }.by(1)
#       end
#     end

#     it '未いいねの状態で、いいねアイコンをクリックすると、いいね済みのアイコンに変わる' do
#       within("#likes-and-comments-#{gadget.id}") do
#         find('.like-button').click
#         expect(page).to have_css('.fas.fa-thumbs-up')
#       end
#     end

#     it 'いいね済みの状態で、いいねアイコンをクリックすると、いいねの解除ができる' do
#       within("#likes-and-comments-#{gadget.id}") do
#         find('.like-button').click
#         expect(page).to have_css('.far fa-thumbs-up')
#       end
#     end

#     it '未フォローユーザーの場合にはフォローボタンの表示内容が”フォロー”になっている' do

#     end

#     it 'フォローユーザーの場合にはフォローボタンの表示内容が”フォロー中”になっている' do

#     end

#     it '未フォローの状態でフォローボタンをクリックすると、フォローボタンが”フォロー中”の表示に変わる' do

#     end

#     it 'フォローしている状態でフォローボタンをクリックすると、フォローボタンが”フォロー”の表示に変わる' do

#     end

#   end

# end





