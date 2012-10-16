class GoverningPeriod < ActiveRecord::Base
  include Hdo::ModelHelpers::HasDateRange

  belongs_to :party
  attr_accessible :start_date, :end_date, :party, :party_id

  validates_presence_of :party
end
