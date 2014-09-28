class Project < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :user_id
  validates_numericality_of :search_depth, :only_integer => true, :message => "can only be natural number"
  validates_inclusion_of :search_depth, :in => 10..200, :message => "can only be between 10 and 200"
  validates_presence_of :search_engines, :on => :update, :message => ": should be checked at least one"
  validates_presence_of :keywords, :on => :update, :message => ": shouldn't be empty"
  validates_presence_of :sites, :on => :update, :message => ": shouldn't be empty"
  validates_inclusion_of :scheduler_mode, :in => ['On Demand', 'Daily', 'Weekly', 'Monthly'], :message => "invalid value"
  validates_inclusion_of :scheduler_factor, :in => 1..999, :message => "can only be between 1 and 999"
  validates_inclusion_of :scheduler_day, :in => 1..31, :message => "can only be between 1 and 31"

  belongs_to :user, :touch => true
  has_many :keywords, :dependent => :destroy
  has_many :sites, :dependent => :destroy
  has_and_belongs_to_many :search_engines


end
