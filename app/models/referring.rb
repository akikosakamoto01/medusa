class Referring < ActiveRecord::Base
  belongs_to :bib
  belongs_to :referable, polymorphic: true

  validates :bib, existence: true
  validates :bib_id, uniqueness: { scope: [:referable_id, :referable_type] }
end
