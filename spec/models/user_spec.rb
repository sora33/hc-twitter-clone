require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it "is valid with name, birthday, email, tel, website, and password" do
    user = User.new(
      name: "Aaron",
      email:      "tester@example.com",
      tel: "1234567890",
      birthday:   Date.today,
      website: "http://www.example.com",
      password:   "dottle-nouveau-pavilion-tights-furze",
    )
    expect(user).to be_valid
  end
  
  it "is invalid without a password" do
    user = FactoryBot.build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("を入力してください")
  end

  it "is invalid without an email address" do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end

  it "is invalid without an birthday address" do
    user = FactoryBot.build(:user, birthday: nil)
    user.valid?
    expect(user.errors[:birthday]).to include("を入力してください")
  end

  it "is invalid without an tel address" do
    user = FactoryBot.build(:user, tel: nil)
    user.valid?
    expect(user.errors[:tel]).to include("を入力してください")
  end

  it "is invalid with a duplicate email address" do
    FactoryBot.create(:user, email: "aaron@example.com")
    user = FactoryBot.build(:user, email: "aaron@example.com")
    allow_any_instance_of(User).to receive(:send_confirmation_instructions).and_return(true)
    user.valid?
    expect(user.errors[:email]).to include("はすでに使用されています")
  end

  describe "#follow and #unfollow" do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }

    it "can follow and unfollow a user" do
      user.follow(other_user)
      expect(user.following?(other_user)).to be_truthy

      user.unfollow(other_user)
      expect(user.following?(other_user)).to be_falsey
    end
  end

  describe "#create_notification" do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }
    let(:tweet) { FactoryBot.create(:tweet, user: other_user) }
  
    it "creates a new notification" do
      expect { user.create_notification(tweet, 'like') }.to change { Notification.count }.by(1)
      
      created_notification = Notification.last
      expect(created_notification.action).to eq 'like'
      expect(created_notification.action_user).to eq user
      expect(created_notification.tweet).to eq tweet
    end
  end
  

end
