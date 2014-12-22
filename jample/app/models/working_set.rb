include TimeHelpers
include Settings


class WorkingSet
  include Mongoid::Document

  field :tracks, type: Array


  

end
