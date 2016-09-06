module ApplicationHelper
  def format_data(data)
    data ? data.to_s + " %" : "No Data"
  end
end
