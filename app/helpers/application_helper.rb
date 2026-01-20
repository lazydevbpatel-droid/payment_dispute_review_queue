module ApplicationHelper
  def human_duration(seconds)
    return "-" if seconds.nil?

    s = seconds.to_i
    minutes = s / 60
    hours = minutes / 60
    days = hours / 24

    if days > 0
      "#{days}d #{hours % 24}h"
    elsif hours > 0
      "#{hours}h #{minutes % 60}m"
    else
      "#{minutes}m"
    end
  end
end
