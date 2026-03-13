class Tagging < ApplicationRecord
  belongs_to :taggable, polymorphic: true, touch: true
  belongs_to :tag
end
