class Ability
  include CanCan::Ability

  def initialize(user)

    # guest user (not logged in)
    user ||= User.new 

    if user.admin?
      can :manage, :all
    else
      can :read, [SettingsForm, SearchEngine]
      can [:read, :update], User, :id => user.id
      cannot :update_name, :update_role, User
      can :manage, Project, :user_id => user.id
      can [:read, :destroy], ReportGroup, :user_id => user.id
      cannot :manage, LogViewer
    end

    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
