class PatchSet
  include Mongoid::Document

  has_many :patches
end
