class Store < ActiveRecord::Base
  has_many :articles, dependent: :destroy
  # validates_associated :articles
  validates :name, presence: true,length: { minimum: 5 , maximum: 50}
  validates :address, presence: true,length: { minimum: 5 , maximum: 300}
end
