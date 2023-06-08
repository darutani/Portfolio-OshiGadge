require 'rails_helper'

RSpec.describe "Gadgets", type: :system do
  let!(:user) { create(:user) }

  context "ページネーションなし" do
    let!(:gadgets) do
      [
        create(:gadget, created_at: 3.hours.ago, likes_count: 5, name: "c_gadget", category_list: ["スマホ", "メインスマホ"]),
        create(:gadget, created_at: 2.hours.ago, likes_count: 3, name: "D_gadget", category_list: ["タブレット", "サブタブレット"]),
        create(:gadget, created_at: 1.hour.ago, likes_count: 10, name: "f_gadget", category_list: ["メインPC", "PC"]),
      ]
    end

    before do
      sign_in user
      visit gadgets_path
    end

    it "並び替えボタンをクリックするとドロップダウンが展開し”新着順”に背景色が設定されている", js: true do
      find('#dropdownMenuButton1').click
      within("#dropdown_menu") do
        expect(page).to have_css("#new_order.active")
      end
    end

    it "投稿一覧ページ遷移時は、新着順に投稿が表示されている", js: true do
      displayed_gadgets = all('.post-container')
      expect(displayed_gadgets.first).to have_content gadgets.last.name
      expect(displayed_gadgets.last).to have_content gadgets.first.name
    end

    it "”人気順”から”新着順”を選択すると新着順に表示される", js: true do
      find('#dropdownMenuButton1').click
      click_on '人気順'
      wait_for_ajax
      find('#dropdownMenuButton1').click
      click_on '新着順'
      wait_for_ajax
      find('#dropdownMenuButton1').click
      within("#dropdown_menu") do
        expect(page).to have_css("#new_order.active")
      end
      wait_for_ajax
      find('#dropdownMenuButton1').click
      wait_for_ajax

      displayed_gadgets = all('.post-container')
      expect(displayed_gadgets.first).to have_content gadgets.last.name
      expect(displayed_gadgets.last).to have_content gadgets.first.name
    end

    it "”古い順を選択すると古い順に表示される”", js: true do
      find('#dropdownMenuButton1').click
      click_on '古い順'
      wait_for_ajax
      find('#dropdownMenuButton1').click
      within("#dropdown_menu") do
        expect(page).to have_css("#older_order.active")
      end
      wait_for_ajax
      find('#dropdownMenuButton1').click
      wait_for_ajax

      displayed_gadgets = all('.post-container')
      expect(displayed_gadgets.first).to have_content gadgets.first.name
      expect(displayed_gadgets.last).to have_content gadgets.last.name
    end

    it "”人気順”を選択するといいね数が多い順に並び替えられ、新着順の背景色がなくなり、選択した人気順に背景色が適用される。", js: true do
      find('#dropdownMenuButton1').click
      click_on '人気順'
      wait_for_ajax
      find('#dropdownMenuButton1').click
      within("#dropdown_menu") do
        expect(page).to have_css("#ranking_order.active")
      end
      wait_for_ajax
      find('#dropdownMenuButton1').click
      wait_for_ajax

      displayed_gadgets = all('.post-container')
      expect(displayed_gadgets.first).to have_content gadgets[2].name
      expect(displayed_gadgets.last).to have_content gadgets[1].name
    end

    it "昇順（ガジェット名）を選択すると、大小文字関係なくアルファベット順に表示される", js: true do
      find('#dropdownMenuButton1').click
      click_on '昇順(ガジェット名)'
      wait_for_ajax
      find('#dropdownMenuButton1').click
      within("#dropdown_menu") do
        expect(page).to have_css("#name_asc_order.active")
      end
      wait_for_ajax
      find('#dropdownMenuButton1').click
      wait_for_ajax

      displayed_gadgets = all('.post-container')
      expect(displayed_gadgets.first).to have_content gadgets[0].name
      expect(displayed_gadgets.last).to have_content gadgets[2].name
    end

    it "降順（ガジェット名）を選択すると、大小文字関係なくアルファベット逆順に表示される", js: true do
      find('#dropdownMenuButton1').click
      click_on '降順(ガジェット名)'
      wait_for_ajax
      find('#dropdownMenuButton1').click
      within("#dropdown_menu") do
        expect(page).to have_css("#name_desc_order.active")
      end
      wait_for_ajax
      find('#dropdownMenuButton1').click
      wait_for_ajax

      displayed_gadgets = all('.post-container')
      expect(displayed_gadgets.first).to have_content gadgets[2].name
      expect(displayed_gadgets.last).to have_content gadgets[0].name
    end

  end

  context "ページネーションあり" do
    let!(:gadgets) { create_list(:gadget, 26, user: user) }

    before do
      sign_in user
      visit gadgets_path
    end

    it "投稿数が25以上の場合、ページネーションが表示され２ページ目をクリックすると、新着順のまま２ページ目へ遷移する", js: true do
      wait_for_ajax
      expect(page).to have_css('.pagination')

      # １ページ目の最後のガジェットを取得
      first_page_last_gadget = all('.post-container').last
      new_gadget = first_page_last_gadget.find('.gadget-name').text
      first_page_last_gadget_created_at = Gadget.find_by(name: new_gadget).created_at # １ページ目の最後のガジェットの作成日時を取得

      element = find('.pagination .page-item:nth-child(2) a')
      page.execute_script("arguments[0].scrollIntoView(true)", element.native)
      element.click
      wait_for_ajax
      expect(page).not_to have_content(first_page_last_gadget.text)

      # ２ページ目の最後のガジェットを取得
      second_page_first_gadget = all('.post-container').first
      older_gadget = second_page_first_gadget.find('.gadget-name').text
      second_page_first_gadget_created_at = Gadget.find_by(name: older_gadget).created_at # １ページ目の最後のガジェットの作成日時を取得
      expect(second_page_first_gadget_created_at).to be < first_page_last_gadget_created_at
      find('#dropdownMenuButton1').click
      within("#dropdown_menu") do
        expect(page).to have_css("#new_order.active")
      end
    end

    it "投稿数が25以上の場合、昇順（ガジェット名）を選択し2ページ目をクリックすると、昇順（ガジェット名）のまま2ページ目へ遷移する", js: true do
      wait_for_ajax
      expect(page).to have_css('.pagination')
      find('#dropdownMenuButton1').click
      click_on '昇順(ガジェット名)'
      wait_for_ajax
      find('#dropdownMenuButton1').click
      within("#dropdown_menu") do
        expect(page).to have_css("#name_asc_order.active")
      end
      wait_for_ajax
      find('#dropdownMenuButton1').click
      wait_for_ajax

      # １ページ目の最後のガジェットを取得
      first_page_last_gadget = all('.post-container').last
      new_gadget = first_page_last_gadget.find('.gadget-name').text

      element = find('.pagination .page-item:nth-child(2) a')
      page.execute_script("arguments[0].scrollIntoView(true)", element.native)
      element.click
      wait_for_ajax
      expect(page).not_to have_content(new_gadget)

      # ２ページ目の最後のガジェットを取得
      second_page_first_gadget = all('.post-container').first
      older_gadget = second_page_first_gadget.find('.gadget-name').text

      expect(older_gadget).to be > new_gadget
      find('#dropdownMenuButton1').click
      within("#dropdown_menu") do
        expect(page).to have_css("#name_asc_order.active")
      end
    end

  end
end
