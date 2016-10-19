require 'rails_helper'

describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe '#subscribed_to?' do
    let(:question_subscription) { create(:subscription, user: other_user, question: question) }

    it 'return true if author' do
      question
      expect(user.subscribed_to?(question)).to be_truthy
    end

    it 'return false if not subscribed' do
      expect(other_user.subscribed_to?(question)).to be_falsy
    end

    it 'return true if subscribed' do
      question_subscription
      expect(other_user.subscribed_to?(question)).to be_truthy
    end
  end

  describe '#voted_for?' do
    let(:question_vote) { create(:question_vote, votable_id: question.id, user: other_user) }
    let(:answer_vote) { create(:answer_vote, votable_id: answer.id, user: other_user) }

    it 'should return true if voted for a question' do
      question_vote
      expect(other_user.voted_for?(question)).to be_truthy
    end

    it 'should return true if voted for an answer' do
      answer_vote
      expect(other_user.voted_for?(answer)).to be_truthy
    end

    it 'should return false if not voted for a question' do
      expect(user.voted_for?(question)).to be_falsy
    end

    it 'should return false if not voted for an answer' do
      expect(user.voted_for?(answer)).to be_falsy
    end
  end

  describe '#author_of?' do
    it 'should return true if author of the question' do
      expect(user.author_of?(question)).to be true
    end

    it 'should return false if not author of the question' do
      expect(other_user.author_of?(question)).to be false
    end

    it 'should return true if author of the answer' do
      expect(user.author_of?(answer)).to be true
    end
    it 'should return false if not author of the answer' do
      expect(other_user.author_of?(answer)).to be false
    end
  end

  describe '.from_omniauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123545') }

    context 'provider returns hash without email or invalid hash' do
      it 'doesnt create a user' do
        expect { User.from_omniauth(auth) }.to_not change(User, :count)
      end

      it 'returns nil' do
        expect(User.from_omniauth(auth)).to be_nil
      end
    end

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123545')
        expect(User.from_omniauth(auth)).to eq user
      end
    end

    context 'user has no authorization' do
      context 'user already exists' do
        let(:auth) do
          OmniAuth::AuthHash.new(provider: 'facebook', uid: '123545',
                                 info: { email: user.email })
        end

        it 'does not create a new user' do
          expect { User.from_omniauth(auth) }.to_not change(User, :count)
        end

        it 'creates an authorization for user' do
          expect { User.from_omniauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates an authorization with provider and uid' do
          authorization = User.from_omniauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.from_omniauth(auth)).to eq user
        end
      end

      context 'user doesnt exists' do
        let(:auth) do
          OmniAuth::AuthHash.new(provider: 'facebook', uid: '123545',
                                 info: { email: 'new@user.com' })
        end

        it 'creates a new user' do
          expect { User.from_omniauth(auth) }.to change(User, :count).by(1)
        end

        it 'fills users email' do
          user = User.from_omniauth(auth)
          expect(user.email).to eq auth.info.email
        end

        it 'creates authorization for user' do
          user = User.from_omniauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates an authorization with provider and user id' do
          authorization = User.from_omniauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end
