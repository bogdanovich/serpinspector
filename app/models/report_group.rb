class ReportGroup < ActiveRecord::Base
  belongs_to :user
  has_many :reports, :dependent => :destroy

  validates_uniqueness_of :name, :scope => :user_id
end
