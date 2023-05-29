require 'rails_helper'

RSpec.describe "Searches", type: :system do
  let!(:user1) { create(:user, name: '山田太郎', introduction: 'おはようございます') }
  let!(:user2) { create(:user, name: '田中太郎', introduction: 'こんにちは') }
  let!(:user3) { create(:user, name: '山田花子', introduction: 'こんばんは') }
  let!(:gadget1) { create(:gadget, name: 'iPhone14 Pro Max', reason: 'Appleが好きだからです', usage: 'メインスマホとして使用しています', point: '画面が大きくて使いやすいです', category_list: 'メインスマホ') }
  let!(:gadget2) { create(:gadget, name: 'iPhone13 mini', reason: 'Appleが好きだからです', usage: 'サブスマホとして使用しています', point: '画面が小さくてコンパクトです', category_list: 'サブスマホ') }
  let!(:gadget3) { create(:gadget, name: 'Pixel Fold', reason: 'Googleが好きだからです', usage: 'メインスマホとして使用しています', point: 'カメラが綺麗です', category_list: 'メインスマホ') }

  it '検索キーワードとガジェット名が部分一致するガジェットが”投稿”タブに表示される（一致しないガジェットが表示されていない）' do
    visit searches_path
    fill_in 'q', with: 'iPhone'
    click_button '検索'
    within('#search-result') do
      expect(page).to have_content(gadget1.name)
      expect(page).to have_content(gadget2.name)
      expect(page).not_to have_content(gadget3.name)
    end
  end

  it '検索キーワードとガジェットの選んだ理由が部分一致するガジェットが”投稿”タブに表示される（一致しないガジェットが表示されていない）' do
    visit searches_path
    fill_in 'q', with: 'Apple'
    click_button '検索'
    within('#search-result') do
      expect(page).to have_content(gadget1.name)
      expect(page).to have_content(gadget2.name)
      expect(page).not_to have_content(gadget3.name)
    end
  end

  it '検索キーワードとガジェットの使用用途が部分一致するガジェットが”投稿”タブに表示される（一致しないガジェットが表示されていない）' do
    visit searches_path
    fill_in 'q', with: 'メイン'
    click_button '検索'
    within('#search-result') do
      expect(page).to have_content(gadget1.name)
      expect(page).not_to have_content(gadget2.name)
      expect(page).to have_content(gadget3.name)
    end
  end

  it '検索キーワードとガジェットの推しポイントが部分一致するガジェットが”投稿”タブに表示される（一致しないガジェットが表示されていない）' do
    visit searches_path
    fill_in 'q', with: '大きくて'
    click_button '検索'
    within('#search-result') do
      expect(page).to have_content(gadget1.name)
      expect(page).not_to have_content(gadget2.name)
      expect(page).not_to have_content(gadget3.name)
    end
  end

  it '検索キーワードとカテゴリー名が完全一致するガジェットが”カテゴリー”タブに表示される（一致しないガジェットが表示されていない）', js: true do
    visit searches_path
    fill_in 'q', with: 'メインスマホ'
    click_button '検索'
    click_link 'カテゴリー'
    within('#search-result') do
      expect(page).to have_content(gadget1.name)
      expect(page).not_to have_content(gadget2.name)
      expect(page).to have_content(gadget3.name)
    end
  end

  it '検索キーワードとユーザー名が部分一致するユーザーが”ユーザー”タブに表示される（一致しないユーザーが表示されていない）', js: true do
    visit searches_path
    fill_in 'q', with: '太郎'
    click_button '検索'
    click_link 'ユーザー'
    within('#search-result') do
      expect(page).to have_content(user1.name)
      expect(page).to have_content(user2.name)
      expect(page).not_to have_content(user3.name)
    end
  end

  it '検索キーワードとユーザーの自己紹介が部分一致するユーザーが”ユーザー”タブに表示される（一致しないユーザーが表示されていない）', js: true do
    visit searches_path
    fill_in 'q', with: 'おはようございます'
    click_button '検索'
    click_link 'ユーザー'
    within('#search-result') do
      expect(page).to have_content(user1.name)
      expect(page).not_to have_content(user2.name)
      expect(page).not_to have_content(user3.name)
    end
  end

  it '一致する検索結果がない場合にメッセージを表示する' do
    visit searches_path
    fill_in 'q', with: 'Xperia'
    click_button '検索'
    expect(page).to have_content('条件に一致する検索結果はありません。')
  end

  it 'ユーザータブを選択し新規キーワードにて検索ボタンを押下後、キーワードに一致するユーザーが”ユーザー”タブに表示される（”投稿”タブに戻らない）', js: true do
    visit searches_path
    click_link 'ユーザー'
    fill_in 'q', with: '太郎'
    click_button '検索'
    within('#search-result') do
      expect(page).to have_content(user1.name)
      expect(page).to have_content(user2.name)
      expect(page).not_to have_content(user3.name)
    end
    expect(page).to have_css('#gadget-link.inactive-link')
    expect(page).to have_css('#user-link.active-link')
    expect(page).to have_css('#category-link.inactive-link')
  end

  it 'トップページの検索欄で未入力のまま検索ボタン押下後、検索結果ページにて投稿タブが太字、下線ありの装飾が適用されている' do
    visit root_path
    click_button '検索'
    expect(page).to have_css('#gadget-link.active-link')
    expect(page).to have_css('#user-link.inactive-link')
    expect(page).to have_css('#category-link.inactive-link')
  end

  it 'トップページの新着投稿欄のカテゴリータグをクリックすると検索結果ページのカテゴリータブに遷移し、選択したカテゴリーと同一カテゴリーの投稿一覧が表示される', js: true do
    visit root_path
    click_link 'メインスマホ', match: :first
    expect(page).to have_title('検索結果')
    expect(page).to have_css('#gadget-link.inactive-link')
    expect(page).to have_css('#user-link.inactive-link')
    expect(page).to have_css('#category-link.active-link')
    within('#search-result') do
      expect(page).to have_content(gadget1.name)
      expect(page).not_to have_content(gadget2.name)
      expect(page).to have_content(gadget3.name)
    end
  end
end
