require 'rails_helper'

RSpec.describe "Tweets", type: :system do
  let(:user) { FactoryBot.create(:user, confirmed_at: Time.now) }  
  
  before do
    driven_by(:rack_test)
    sign_in user
    visit root_path
  end

  scenario "user creates a new tweet" do

    expect {
      fill_in 'いまどうしてる？', with: '最初のツイートです。'
      click_button 'ツイートする'
      fill_in 'いまどうしてる？', with: '2個目のツイートです。'
      click_button 'ツイートする'

      aggregate_failures do
        expect(page).to have_content "ツイートできました"
        expect(page).to have_content user.name
      end
    }.to change(user.tweets, :count).by(2)
  end

  scenario "user fails to creates a new tweet" do

    expect {
      fill_in 'いまどうしてる？', with: ''
      click_button 'ツイートする'

      aggregate_failures do
        expect(page).to have_content "失敗しました"
      end
    }.to change(user.tweets, :count).by(0)
  end
end
