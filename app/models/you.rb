class You < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :flie_o
end
