class RankingsController < ApplicationController
  def have
    have_ids = Have.group(:item_id).order('count_item_id desc').limit(10).count('item_id').keys
    @items = Item.find(have_ids).sort_by{|o| have_ids.index(o.id)}
    render 'show'
  end

  def want
    want_ids = Want.group(:item_id).order('count_item_id desc').limit(10).count('item_id').keys
    @items = Item.find(want_ids).sort_by{|o| want_ids.index(o.id)}
    render 'show'
  end
end
