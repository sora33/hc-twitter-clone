# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tweets', type: :system do
  let(:user) { FactoryBot.create(:user, confirmed_at: Time.zone.now) }

  before do
    driven_by(:rack_test)
    sign_in user
    visit root_path
  end

  context 'when a user creates tweets' do
    before do
      fill_in 'いまどうしてる？', with: '最初のツイートです。'
      click_button 'ツイートする'
      fill_in 'いまどうしてる？', with: '2個目のツイートです。'
      click_button 'ツイートする'
    end

    it 'increases the tweet count' do
      expect(user.tweets.count).to eq(2)
    end

    it 'shows the success message' do
      expect(page).to have_content 'ツイートできました'
    end

    it 'shows the user name' do
      expect(page).to have_content user.name
    end
  end

  context 'when a user fails to create a tweet' do
    before do
      fill_in 'いまどうしてる？', with: ''
      click_button 'ツイートする'
    end

    it 'does not increase the tweet count' do
      expect(user.tweets.count).to eq(0)
    end

    it 'shows the failure message' do
      expect(page).to have_content '失敗しました'
    end
  end
end
