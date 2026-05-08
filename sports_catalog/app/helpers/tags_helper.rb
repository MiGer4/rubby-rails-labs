module ApplicationHelper
  def tag_badge(tag_name)
    normalized_name = tag_name.to_s.downcase

    colors = [
      "bg-red-100 text-red-800 border-red-200",
      "bg-orange-100 text-orange-800 border-orange-200",
      "bg-amber-100 text-amber-800 border-amber-200",
      "bg-green-100 text-green-800 border-green-200",
      "bg-emerald-100 text-emerald-800 border-emerald-200",
      "bg-teal-100 text-teal-800 border-teal-200",
      "bg-cyan-100 text-cyan-800 border-cyan-200",
      "bg-blue-100 text-blue-800 border-blue-200",
      "bg-indigo-100 text-indigo-800 border-indigo-200",
      "bg-violet-100 text-violet-800 border-violet-200",
      "bg-purple-100 text-purple-800 border-purple-200",
      "bg-fuchsia-100 text-fuchsia-800 border-fuchsia-200",
      "bg-pink-100 text-pink-800 border-pink-200",
      "bg-rose-100 text-rose-800 border-rose-200"
    ]

    color_index = normalized_name.sum % colors.length
    chosen_color = colors[color_index]

    base_classes = "inline-flex items-center px-2 py-0.5 rounded text-xs font-medium border shadow-sm"

    content_tag(:span, "##{normalized_name}", class: "#{base_classes} #{chosen_color}")
  end
end
