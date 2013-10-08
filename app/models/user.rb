require 'digest/sha1'

class User < ActiveRecord::Base
  has_many :projects
  has_many :report_groups

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_confirmation_of :password
  validates_inclusion_of :role, :in => Settings.user_roles_available, :message => "There is no such role!"
  validate :password_not_blank

  def self.authenticate(name, password)
    user = self.find_by_name(name)
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    user
  end

  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end

  def admin?
    return (self.role == 'admin') ? true : false
  end

  def user?
    return (self.role == 'user') ? true : false
  end

  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def reports_overview
    overview = {}
    report_groups = self.report_groups.order('display_order')
    report_groups.each do |report_group|
      report = Report.where(:report_group_id => report_group.id).last
      unless report.nil?
        overview[report_group.name] = Hash.new
        overview[report_group.name]['group']  = report_group
        overview[report_group.name]['report'] = report
      end
    end
    overview
  end

private
  def password_not_blank
    errors.add(:password, "Missing password") if hashed_password.blank?
  end

  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

  

end
