# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user_role = user.user_type.role

    if user_role == "super_admin"
      can :manage, :all
    elsif user_role == "admin"
      can [:read, :update], AdminUser, id: user.id
    else
      # no access to users for admin panel
    end
  end
end
