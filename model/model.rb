class User < ActiveRecord::Base
  has_one :city
end

class City < ActiveRecord::Base
end