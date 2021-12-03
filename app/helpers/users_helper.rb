# frozen_string_literal: true

# ApplicationHelper
module UsersHelper
  def temperature(user_id)
    User.find_by(id: user_id).temperature
  end
end
