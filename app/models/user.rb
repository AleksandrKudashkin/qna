class User < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter]

  def voted_for?(votable)
    votes.where(votable: votable).exists?
  end

  def author_of?(thing)
    self == thing.user
  end

  def self.from_omniauth(auth)
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    return if !auth.try(:info, :email) || auth.info[:email].blank?
    email = auth.info[:email]
    user = User.find_or_create_by(email: email) do |u|
      password = Devise.friendly_token[0, 20]
      u.password = password
      u.password_confirmation = password
      u.email = email
    end

    user.authorizations.create(provider: auth.provider, uid: auth.uid)
    user
  end
end
