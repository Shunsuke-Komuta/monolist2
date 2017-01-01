class OwnershipsController < ApplicationController
  before_action :logged_in_user

  def create
    if params[:item_code]
      @item = Item.find_or_initialize_by(item_code: params[:item_code])
    else
      @item = Item.find(params[:item_id])
    end

    # itemsテーブルに存在しない場合は楽天のデータを登録する。
    if @item.new_record?
      items = RakutenWebService::Ichiba::Item.search(
        itemCode: params[:item_code],
        imageFlag: 1,
      )

      item                  = items.first
      @item.title           = item['itemName']
      @item.small_image     = item['smallImageUrls'].first['imageUrl']
      @item.medium_image    = item['mediumImageUrls'].first['imageUrl']
      @item.large_image     = item['mediumImageUrls'].first['imageUrl'].gsub('?_ex=128x128', '')
      @item.detail_page_url = item['itemUrl']
      @item.save!
    end

    user = User.find_by(id: session[:user_id])
    case params[:type]
    when 'Have'
      user.have(@item)
    when 'Want'
      user.want(@item)
    end

  end

  def destroy
    @item = Item.find(params[:item_id])

    user = User.find_by(id: session[:user_id])
    case params[:type]
    when 'Have'
      user.unhave(@item)
    when 'Want'
      user.unwant(@item)
    end
  end
end
