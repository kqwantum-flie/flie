class OsLog < ApplicationRecord
  belongs_to :flie_o

  before_create :process

  def process
    args = self.in.split(" ")
    self.out = "<processed> " + args.join(" ")
  end
end
