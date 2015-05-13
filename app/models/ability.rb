class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    else
      cannot [User, Client, Company, Item]
    end

  end
end
