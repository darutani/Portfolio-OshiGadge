class ConvertCategoriesToTags < ActiveRecord::Migration[6.1]
  class Gadget < ApplicationRecord
    acts_as_taggable_on :categories
  end

  def up
    Gadget.find_each do |gadget|
      gadget.category_list = gadget.category
      gadget.save
    end
  end
end
