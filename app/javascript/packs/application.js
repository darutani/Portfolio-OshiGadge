// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import 'jquery/dist/jquery.js'
import "bootstrap";
import "../stylesheets/application.scss";

Rails.start()
Turbolinks.start()
ActiveStorage.start()


// コメント一覧ページにてガジェット詳細を開く・閉じる
document.addEventListener('DOMContentLoaded', () => {
  const collapseButton = document.querySelector('[data-bs-toggle="collapse"]');
  const collapseText = collapseButton.querySelector('.collapse-text');

  collapseButton.addEventListener('click', () => {
    if (collapseButton.getAttribute('aria-expanded') === 'true') {
      console.log('開く');
      collapseText.textContent = '▼ ガジェット詳細を閉じる';
    } else {
      console.log('閉じる');
      collapseText.textContent = '▲ ガジェット詳細を見る';
    }
  });
});


