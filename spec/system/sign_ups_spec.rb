require 'rails_helper'

RSpec.describe 'Sign-ups', type: :system do
  include ActiveJob::TestHelper

  before do
    driven_by(:rack_test)
  end

  scenario "user successfully signs up" do
    visit new_user_registration_path

    expect {
      fill_in 'メールアドレス', with: "test@example.com"
      fill_in '電話番号', with: "233242343"
      fill_in '生年月日', with: "1990-01-01"
      fill_in 'パスワード', with: "test123"
      fill_in '確認用パスワード', with: "test123"
      click_on '登録'
    }.to change(User, :count).by(1)

    expect(page).to have_content 'ログイン'
  end
end
