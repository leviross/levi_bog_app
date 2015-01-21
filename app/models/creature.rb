class Creature < ActiveRecord::Base
   has_and_belongs_to_many :tags

   validates :name, presence: true, :uniqueness => {:case_sensitive => false}, format: {
    with: /\A[a-z\sA-Z]+\z/, message: "only allows letters" }
    validates :desc, presence: true, length: { in: 10..255 }
end
