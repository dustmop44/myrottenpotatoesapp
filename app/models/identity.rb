class Identity < ApplicationRecord
  belongs_to :user
  validates :provider, :uid, presence: true
  
  def self.find_from_omniauth(auth)
    find_by(provider: auth.provider, uid: auth.uid)
  end
  
  def self.create_from_omniauth(auth, user)
    Identity.create!(user: user, provider: auth.provider, uid: auth.uid)
  end
end
