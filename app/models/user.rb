class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, 
         :timeoutable, :omniauthable, omniauth_providers: %i[twitter]
  #---------------------------------------------------------------
  #Callback
  #---------------------------------------------------------------
  before_save { self.email = email.downcase }
  #---------------------------------------------------------------
  #Validations
  #---------------------------------------------------------------
  validates :name, length: { maximum: 50 }
  
  #twitter1認証でサインアップする為に外してみた
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, uniqueness: true
   #                 format: { with: VALID_EMAIL_REGEX },
    #                　length: { maximum: 255 },
  validates :password, length: { minimum: 6 }
  validates :uid, uniqueness: true
  
  #uidとproviderで検索してあったらそれを、無かったらレコードを作ります。
  def self.find_for_oauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = User.dummy_email(auth)
      user.password = Devise.friendly_token[4, 30]
      user.uid = auth['uid']
      user.provider = auth['provider']
      user.nickname = auth['info']['name']   # assuming the user model has a name
      user.image_url = auth['info']['image'] # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails, 
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end
  
  #認証情報として取ってきたuidやproviderなどを登録する為に
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.twitter_data"] && session["devise.twitter_data"]["extra"]["raw_info"]
        user.uid = data["uid"] if user.uid.blank?
      end
    end
  end
  
  
  #@TODO ダミーのパスワードじゃ都合悪い時に。配置はuser.rbでいい？
  #def password_required?
  #   super && provider.blank?  # provider属性に値があればパスワード入力免除
  #end
  
  private
  #twitterでサインアップする時に、本来サインアップに必要なメールアドレスカラムをダミーで埋める
  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end
  
  
  
  
end


