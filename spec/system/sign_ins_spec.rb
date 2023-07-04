require 'rails_helper'

RSpec.describe 'Sign in', type: :system do
  let(:user) { FactoryBot.create(:user, confirmed_at: Time.now) }  

  before do
    driven_by(:rack_test)
  end

  scenario "user signs in with correct credentials" do
    visit new_user_session_path

    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_on 'ログイン'

    expect(page).to have_content 'ログインしました。'
  end

  scenario "user fails to sign in with incorrect credentials" do
    visit new_user_session_path

    fill_in 'メールアドレス', with: 'invalid@example.com'
    fill_in 'パスワード', with: 'wrongpassword'
    click_on 'ログイン'

    expect(page).to have_content 'メールアドレスまたはパスワードが違います'
  end
end
