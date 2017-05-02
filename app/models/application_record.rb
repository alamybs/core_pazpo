class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  def self.first
    order("created_at").first
  end

  def self.last
    order("created_at DESC").first
  end
end
