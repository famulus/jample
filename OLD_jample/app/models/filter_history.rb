class FilterHistory
    include Mongoid::Document
    include Mongoid::Timestamps::Created

    field :filter_value, type: String

end