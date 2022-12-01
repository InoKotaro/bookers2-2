class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image
  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy

  #--------------------------↓フォロー機能--------------------------------
 has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
 has_many :followings, through: :relationships, source: :followed#一覧で使用
 has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
 has_many :followers, through: :reverse_of_relationships, source: :follower#一覧で使用
  #------------------------------------------------------------------------

  validates :name, length: { minimum: 2, maximum: 20 }, presence: true, uniqueness: true
  validates :introduction, length: { maximum: 50 }


  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  #-----------↓フォロー機能-----リレーションシップコントで使うメソッド--------------------------------
  def follow(user)#フォロー時
   relationships.create(followed_id: user.id)#リレシテーブルfollowed_idカラムをuser.idに置換える処理
  end                                        #followed_idはmigtateファイルで設定したカラム

  def unfollow(user)#フォロー解除時
   relationships.find_by(followed_id: user.id).destroy
  end

  def following?(user)#フォロー確認をおこなう
   followings.include?(user)
  end
  #------------------------------------------------------------------------

 #--------------------------↓検索機能（user）------------------------------
  def self.looks(search, word)#searchテンプレでモデル指定したから
     if search == "perfect_match"
       @user = User.where("name LIKE?", "#{word}")#完全一致
     elsif search == "forward_match"
       @user = User.where("name LIKE?","#{word}%")#前方一致
     elsif search == "backward_match"
       @user = User.where("name LIKE?","%#{word}")#後方一致
     elsif search == "partial_match"
       @user = User.where("name LIKE?","%#{word}%")#部分一致
     else
       @user = User.all
     end
  end
  #-------------------------------------------------------------------------
end
