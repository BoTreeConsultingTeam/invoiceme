class HomeController < ApplicationController

  def index
    if current_user.present?
      from = Time.now - 90.days
      to = Time.now
      tmp = from
      @array = []
      begin
        tmp = tmp + 1.day
        @array << [
            day: tmp.strftime("%d %b"),
            dayago: "#{Date.today.to_date - tmp.to_date} days ago",
            activities: PublicActivity::Activity.order("created_at desc").where(owner_id: current_user.id, owner_type: "User").where("created_at BETWEEN ? AND ?", tmp, tmp + 1.day)
        ]
      end while tmp <= to
      @array = @array.reverse!
    end
  end
end
