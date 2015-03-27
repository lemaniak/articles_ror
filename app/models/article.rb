class Article < ActiveRecord::Base
  belongs_to :store
  validates :name, presence: true,length: { minimum: 5 , maximum: 50}
  validates :description, presence: true,length: { minimum: 5 , maximum: 300}
  validates :price, presence: true
  validates :price , presence: true,numericality: true
  validates :total_in_shelf, presence: true,numericality: true
  validates :total_in_vault, presence: true,numericality: true
  validates :store_id,presence: true, numericality: true

end
