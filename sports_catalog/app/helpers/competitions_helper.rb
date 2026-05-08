module CompetitionsHelper
  def status_badge(status)
    safe_status = status.to_s.downcase
    color_classes = case safe_status
    when "upcoming"  then "bg-blue-100 text-blue-800 border-blue-200"
    when "ongoing"   then "bg-yellow-100 text-yellow-800 border-yellow-200"
    when "completed" then "bg-green-100 text-green-800 border-green-200"
    when "cancelled" then "bg-red-100 text-red-800 border-red-200"
    else "bg-gray-100 text-gray-800 border-gray-200"
    end


    base_classes = "inline-block px-3 py-1 rounded-full text-xs font-bold uppercase tracking-wider border shadow-sm"

    content_tag(:span, status.capitalize, class: "#{base_classes} #{color_classes}")
  end
end
