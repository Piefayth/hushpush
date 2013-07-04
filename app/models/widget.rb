class Widget < ActiveRecord::Base
  attr_accessible :properties, :name, :user_id
  belongs_to :user

  validates :properties, presence: true
  validates :name, presence: true
  validates :user_id, presence: true

end
