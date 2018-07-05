class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, 
         :confirmable, :timeoutable, :omniauthable, omniauth_providers: [:twitter]
  #---------------------------------------------------------------
  #Callback
  #---------------------------------------------------------------
  before_save { self.email = email.downcase }
  #---------------------------------------------------------------
  #Validations
  #---------------------------------------------------------------
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  
  #uidとproviderで検索してあったらそれを、無かったらレコードを作ります。
  def self.from_omniauth(auth) 
    find_or_create_by(provider: auth["provider"], uid: auth["uid"]) do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.username = auth["info"]["nickname"]
    end
  end
  
  #認証情報として取ってきたuidやproviderなどを登録する為に
  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"]) do |user|
        user.attributes = params
      end
    else
      super
    end
  end
end
