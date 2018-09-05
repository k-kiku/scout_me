class PostsController < ApplicationController
  require 'securerandom'
  require 'mini_magick'
  
  before_action :set_post, only: [:confirm, :edit, :update]

  before_action :new_post, only: [:show, :new]
  # GET /posts
  # GET /posts.json
  BASE_IMAGE_PATH = './app/assets/images/scout.png'.freeze
  GRAVITY = 'center'.freeze
  TEXT_POSITION = '0,0'.freeze
  FONT = './.fonts/azukiLB.ttf'
  FONT_SIZE = 32
  INDENTION_COUNT = 21
  ROW_LIMIT = 8
  
  def index
    @post = Post.all
  end

  def show
    render :new
  end

  # GET /posts/new
  def new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    #@postに入力したcontentが入ってる
    @post = Post.new(post_params)
    make_picture
    if @post.save
      redirect_to confirm_path(@post)
    else
      render :new
    end
  end
  

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def confirm
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    #　パラメーターを渡せるように
    def post_params
      params.require(:post).permit(:content, :picture)
    end
    
    def set_post
      @post = Post.find(params[:id])
    end
    
    # メソッド追加
    def new_post
      @post = Post.new
    end
    
    # 背景にいい感じに収まるように文字を調整して返却
    def format_text(text)
      text.scan(/.{1,#{INDENTION_COUNT}}/)[0...ROW_LIMIT].join("\n")
    end
    
  def make_picture
    content = @post.content
    image = MiniMagick::Image.open(BASE_IMAGE_PATH) 
    # 設定関連の値を代
    image.combine_options do |config|
        config.font FONT
        config.gravity GRAVITY
        config.pointsize FONT_SIZE
        config.draw "text 0,0 '#{content}'"
    end
    # 保存先のストレージの指定。Amazon S3を指定する。
    storage = Fog::Storage.new(
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      region: 'ap-northeast-1'
    )
    # 開発環境or本番環境でS3のバケットを分ける
    case Rails.env
      when 'production'
        # 14 バケットの指定・URLの設定
        bucket = storage.directories.get('scoutme-production')
        # 保存するディレクトリ、ファイル名の指定（ファイル名はランダムに生成）
        png_path = SecureRandom.hex + '.png'
        image_uri = image.path
        file = bucket.files.create(key: png_path, public: true, body: open(image_uri))
        @post.picture = 'https://s3-ap-northeast-1.amazonaws.com/scoutme-production' + "/" + png_path
      when 'development'
       bucket = storage.directories.get('scoutme-development')
       png_path = SecureRandom.hex + '.png'
       image_uri = image.path
       file = bucket.files.create(key: png_path, public: true, body: open(image_uri))
       @post.picture = 'https://s3-ap-northeast-1.amazonaws.com/scoutme-development' + "/" + png_path
    end
  end
end

  
