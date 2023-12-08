# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # frozen_string_literal: true
    if user.user_type == 'Manager'
      puts "------------------------------------>#{user.user_type}"
      can %i[update assign_task index], Task
      can %i[update index destroy show create], Comment
    elsif user.user_type == 'Admin'
      puts "------------------------------------>#{user.user_type}"
      can [:create, :update, :index, :show, :destroy], Task
      can %i[update index destroy show create], Comment
    elsif user.user_type == 'User'
      puts "------------------------------------>#{user.user_type}"
      can %i[update index destroy show create], Comment
      can :read, Task
    end
  end
end
