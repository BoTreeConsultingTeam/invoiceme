class HomeController < ApplicationController

  def index
    if current_user.present?
      @activities = PublicActivity::Activity.order("created_at desc").where(owner_id: current_user.id, owner_type: "User")
    end
  end

end
