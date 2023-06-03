require 'rails_helper'

RSpec.describe "Gadgets", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
    visit new_gadget_path
    allow(RakutenWebService::Ichiba::Item).to receive(:search).and_return(
      [
        double("RakutenItem", name: "iphone14 128GB", url: "http://test1.com", small_image_urls: ["http://image_url1"]),
        double("RakutenItem", name: "iphone14 256GB", url: "http://test2.com", small_image_urls: ["http://image_url2"]),
      ]
    )
  end

  describe "rakuten_url" do
    it "”楽天のリンクを追加する”リンクをクリックするとモーダルウィンドウが表示される", js: true do
      expect(page).not_to have_selector('.modal-open')
      find('#rakuten-link-button').click
      expect(page).to have_selector('.modal-open')
    end

    it "検索結果の各商品のリンクをクリックすると別タブにて楽天市場の商品購入ページに遷移する", js: true do
      find('#rakuten-link-button').click
      fill_in 'q', with: 'iphone14'
      click_on '検索'
      click_link(href: 'http://test1.com')
      switch_to_window(windows.last)
      expect(current_url).to eq 'http://test1.com/'
    end

    it "検索結果の各商品の”選択”ボタンをクリックすると、モーダルが閉じ、その商品のURLが”選択された楽天リンク”欄に表示され、hidden_fieldにも代入される", js: true do
      find('#rakuten-link-button').click
      fill_in 'q', with: 'iphone14'
      click_on '検索'
      sleep 1
      find('.rakuten-add-button', match: :first).click
      expect(page).not_to have_css("#rakuten-modal.show")
      expect(page).to have_selector("#rakuten_url_text", text: "http://test1.com")
      expect(page).to have_field('gadget_rakuten_url', with: 'http://test1.com', type: 'hidden')
    end

    it "モダール内のキャンセルボタンをクリックすると、モーダルが閉じる", js: true do
      find('#rakuten-link-button').click
      sleep 1
      click_on 'キャンセル'
      expect(page).not_to have_css("#rakuten-modal.show")
    end

    it "選択された楽天リンク欄の削除ボタンをクリックすると、”選択された楽天リンク”欄が”なし”という表記に変わり、hidden_fieldからも削除される", js: true do
      find('#rakuten-link-button').click
      fill_in 'q', with: 'iphone14'
      click_on '検索'
      sleep 1
      find('.rakuten-add-button', match: :first).click
      expect(page).to have_selector("#rakuten_url_text", text: "http://test1.com")
      expect(page).to have_field('gadget_rakuten_url', with: 'http://test1.com', type: 'hidden')
      find('#remove_rakuten_url_button').click
      expect(page).to have_selector("#rakuten_url_text", text: "なし")
      expect(page).to have_field('gadget_rakuten_url', with: "", type: 'hidden')
    end

    it "選択された楽天リンク欄に選択したURLが表示された状態で登録ボタンをクリックするとgadgetsモデルのrakuten_urlカラムにデータが保存される（その他必須項目は入力されている状態）", js: true do
      find('#rakuten-link-button').click
      fill_in 'q', with: 'iphone14'
      click_on '検索'
      sleep 1
      find('.rakuten-add-button', match: :first).click
      fill_in 'gadget_name', with: 'iphone14'
      fill_in 'gadget_category_list', with: 'スマホ'
      fill_in 'gadget_point', with: 'This is a great gadget.'
      click_button '登録'
      expect(Gadget.last.rakuten_url).to eq 'http://test1.com'
    end

    it "楽天リンクを選択した状態で、再度楽天のリンクを追加するボタンをクリックし、異なる商品を選択した場合その選択した商品のURLに選択された楽天リンク欄もhidden_fieldも入れ替わる", js: true do
      find('#rakuten-link-button').click
      fill_in 'q', with: 'iphone14'
      click_on '検索'
      sleep 1
      find('.rakuten-add-button', match: :first).click
      expect(page).to have_selector("#rakuten_url_text", text: "http://test1.com")
      expect(page).to have_field('gadget_rakuten_url', with: 'http://test1.com', type: 'hidden')
      find('#rakuten-link-button').click
      fill_in 'q', with: 'iphone14'
      click_on '検索'
      sleep 1
      all('.rakuten-add-button')[1].click
      expect(page).to have_selector("#rakuten_url_text", text: "http://test2.com")
      expect(page).to have_field('gadget_rakuten_url', with: 'http://test2.com', type: 'hidden')
    end

    it "モーダル内の検索入力欄を空欄の状態で検索ボタンをクリックすると”条件に一致する検索結果はありません。”が表示される", js: true do
      find('#rakuten-link-button').click
      click_on '検索'
      expect(page).to have_content("条件に一致する検索結果はありません。")
    end
  end
end
