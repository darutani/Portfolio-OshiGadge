class SearchesController < ApplicationController
  def index
    @q = params[:q]
    @model = params[:model] || 'gadgets'
    if @q.present?
      if @model == 'users'
        @users = User.ransack(name_or_introduction_cont: @q).result(distinct: true)
      else
        @gadgets = Gadget.ransack(name_or_reason_or_usage_or_point_cont: @q).result(distinct: true)
      end
    end

    # binding.pry

    respond_to do |format|
      format.html
      format.js
    end
  end
end
