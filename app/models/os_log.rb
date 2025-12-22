class OsLog < ApplicationRecord
  belongs_to :flie_o
  has_rich_text :out
end
