# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sign-ups', type: :system do
  include ActiveJob::TestHelper

  before do
    driven_by(:rack_test)
  end

  context 'when a user signs up' do
    before do
      visit new_user_registration_path
      fill_in 'メールアドレス', with: 'test@example.com'
      fill_in '電話番号', with: '233242343'
      fill_in '生年月日', with: '1990-01-01'
      fill_in 'パスワード', with: 'test123'
      fill_in '確認用パスワード', with: 'test123'
      click_on '登録'
    end

    it 'creates a new user' do
      expect(User.count).to eq(1)
    end

    it 'redirects to the login page' do
      expect(page).to have_content 'ログイン'
    end
  end
end
