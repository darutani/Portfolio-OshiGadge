class SearchesController < ApplicationController
  def index
    @q = params[:q]
    @model = params[:model].presence || 'gadgets'
    if @q.present?
        case @model
        when 'users'
            @users = User.ransack(name_or_introduction_cont: @q).result(distinct: true)
        when 'gadgets'
            @gadgets = Gadget.ransack(name_or_reason_or_usage_or_point_cont: @q).result(distinct: true)
        when 'categories'
            @gadgets = Gadget.tagged_with(@q)
        end
    end
    respond_to do |format|
        format.html
        format.js
    end
end
end
