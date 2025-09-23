module ApplicationHelper
  def current_sort?(attribute)
    params[:sort] == attribute.to_s
  end

  def current_direction
    params[:direction] == "desc" ? "desc" : "asc"
  end

  def next_direction(attribute)
    return "desc" if current_sort?(attribute) && current_direction == "asc"

    "asc"
  end

  def sort_params(attribute)
    params.except(:controller, :action).permit!.to_h.merge(sort: attribute, direction: next_direction(attribute))
  end
end
