module ApplicationHelper
  def alert_msg(type, message)
    color_class = case type
                  when :success
                    "bg-green-100 border-green-400 text-green-700"
                  when :error
                    "bg-red-100 border-red-400 text-red-700"
                  when :warning
                    "bg-yellow-100 border-yellow-400 text-yellow-700"
                  when :info
                    "bg-blue-100 border-blue-400 text-blue-700"
                  else
                    "bg-gray-100 border-gray-400 text-gray-700"
                  end
    content_tag(:div, class: "border px-4 py-3 rounded relative #{color_class} mb-4", role: "alert") do
      concat(content_tag(:strong, message, class: "font-bold"))
    end
  end

  def button_color_classes(color, size: :md, rounded: false)
    result = case color
    when :blue
      "bg-blue-500 hover:bg-blue-600 text-white"
    when :green
      "bg-green-500 hover:bg-green-600 text-white"
    when :red
      "bg-red-500 hover:bg-red-600 text-white"
    when :yellow
      "bg-yellow-500 hover:bg-yellow-600 text-white"
    when :gray
      "bg-gray-500 hover:bg-gray-600 text-white"
    when :black
      "bg-black hover:bg-gray-800 text-white"
    when :navy
      "bg-blue-900 hover:bg-blue-800 text-white"
    else
      "bg-gray-500 hover:bg-gray-600 text-white"
    end

    result = result.dup
    result.concat(" rounded-full") if rounded
    result.concat(" rounded-md") unless rounded
    result.concat(" px-4 py-2") if size == :md
    result.concat(" px-3 py-1.5 text-sm") if size == :sm
    result.concat(" px-5 py-3 text-lg") if size == :lg
    result
  end

  def form_input_classes(size: :sm, rounded: false)
    result = "border border-gray-300 rounded-md p-2 w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
    result = result.dup
    result.concat(" rounded-full") if rounded
    result.concat(" rounded-md") unless rounded
    result.concat(" text-sm") if size == :sm
    result.concat(" text-lg") if size == :lg
    result
  end

  def form_error_classes
    "text-red-500 text-sm mt-1"
  end

  def form_group_classes
    "mb-4"
  end

  def form_container_classes
    "max-w-md mx-auto p-4 bg-white shadow-md rounded-md"
  end

  def form_title_classes
    "text-2xl font-bold mb-4 text-center"
  end

  def form_subtitle_classes
    "text-gray-600 mb-6 text-center"
  end

  def form_footer_classes
    "mt-6 text-center"
  end

  def checkbox_classes
    "h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
  end

  def submit_button_classes
    "bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded"
  end

  def cancel_button_classes
    "bg-gray-500 hover:bg-gray-600 text-white font-bold py-2 px-4 rounded"
  end

  def dropdown_menu_classes
    "origin-top-right absolute right-0 mt-2 w-48 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5 focus:outline-none"
  end

  def radio_button_classes
    "h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300"
  end

  def text_area_classes
    "border border-gray-300 rounded-md p-2 w-full h-32 focus:outline-none focus:ring-2 focus:ring-blue-500"
  end

  def select_classes
    "border border-gray-300 rounded-md p-2 w-full focus:outline-none focus:ring-2 focus:ring-blue-500"
  end

  def label_classes
    "block text-sm font-medium text-gray-700 mb-1"
  end

  def p_tag_classes(color = :black, size: :md)
    result = case size
             when :sm
                "text-sm"
             when :lg
                "text-lg"
             else
                "text-md"
             end
    result = result.dup
    result.concat(" font-bold") if color == :black
    result.concat(" font-semibold") if color == :blue
    result.concat(" font-normal") unless [:black, :blue].include?(color)
    result.concat(" text-red-700") if color == :red
    result.concat(" text-green-700") if color == :green
    result.concat(" text-blue-700") if color == :blue
    result.concat(" text-yellow-700") if color == :yellow
    result.concat(" text-black") if color == :black
    result.concat(" text-gray-700") if color == :gray
    result
  end

  def gear_icon_path
    <<~SVG
      <path
        d="M9.405 1.05c-.413-1.4-2.397-1.4-2.81 0l-.1.34a1.464 1.464 0 0 1-2.105.872l-.31-.17c-1.283-.698-2.686.705-1.987 1.987l.169.311c.446.82.023 1.841-.872 2.105l-.34.1c-1.4.413-1.4 2.397 0 2.81l.34.1a1.464 1.464 0 0 1 .872 2.105l-.17.31c-.698 1.283.705 2.686 1.987 1.987l.311-.169a1.464 1.464 0 0 1 2.105.872l.1.34c.413 1.4 2.397 1.4 2.81 0l.1-.34a1.464 1.464 0 0 1 2.105-.872l.31.17c1.283.698 2.686-.705 1.987-1.987l-.169-.311a1.464 1.464 0 0 1 .872-2.105l.34-.1c1.4-.413 1.4-2.397 0-2.81l-.34-.1a1.464 1.464 0 0 1-.872-2.105l.17-.31c.698-1.283-.705-2.686-1.987-1.987l-.311.169a1.464 1.464 0 0 1-2.105-.872l-.1-.34zM8 10.93a2.929 2.929 0 1 1 0-5.86 2.929 2.929 0 0 1 0 5.858z"
      />
    SVG
  end
  def lock_icon_path
    <<~SVG
      <path
        d="M8 1a2 2 0 0 1 2 2v4H6V3a2 2 0 0 1 2-2zm3 6V3a3 3 0 0 0-6 0v4a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2z"
      />
    SVG
  end
  def life_preserver_icon_path
    <<~SVG
      <path
        d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16zm6.43-5.228a7.025 7.025 0 0 1-3.658 3.658l-1.115-2.788a4.015 4.015 0 0 0 1.985-1.985l2.788 1.115zM5.228 14.43a7.025 7.025 0 0 1-3.658-3.658l2.788-1.115a4.015 4.015 0 0 0 1.985 1.985L5.228 14.43zm9.202-9.202-2.788 1.115a4.015 4.015 0 0 0-1.985-1.985l1.115-2.788a7.025 7.025 0 0 1 3.658 3.658zm-8.087-.87a4.015 4.015 0 0 0-1.985 1.985L1.57 5.228A7.025 7.025 0 0 1 5.228 1.57l1.115 2.788zM8 11a3 3 0 1 1 0-6 3 3 0 0 1 0 6z"
      />
    SVG
  end
  def house_icon_path
    <<~SVG
      <path d="M7.293 1.5a1 1 0 0 1 1.414 0L11 3.793V2.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v3.293l2.354 2.353a.5.5 0 0 1-.708.707L8 2.207 1.354 8.853a.5.5 0 1 1-.708-.707L7.293 1.5Z"/>
      <path d="m14 9.293-6-6-6 6V13.5A1.5 1.5 0 0 0 3.5 15h9a1.5 1.5 0 0 0 1.5-1.5V9.293Zm-6-.811c1.664-1.673 5.825 1.254 0 5.018-5.825-3.764-1.664-6.691 0-5.018Z"/>
    SVG
  end

  def briefcase_icon_path
    <<~SVG
      <path d="M6.5 1A1.5 1.5 0 0 0 5 2.5V3H1.5A1.5 1.5 0 0 0 0 4.5v1.384l7.614 2.03a1.5 1.5 0 0 0 .772 0L16 5.884V4.5A1.5 1.5 0 0 0 14.5 3H11v-.5A1.5 1.5 0 0 0 9.5 1h-3zm0 1h3a.5.5 0 0 1 .5.5V3H6v-.5a.5.5 0 0 1 .5-.5z"/>
      <path d="M0 12.5A1.5 1.5 0 0 0 1.5 14h13a1.5 1.5 0 0 0 1.5-1.5V6.85L8.129 8.947a.5.5 0 0 1-.258 0L0 6.85v5.65z"/>
    SVG
  end

  def people_icon_path
    <<~SVG
      <path d="M7 14s-1 0-1-1 1-4 5-4 5 3 5 4-1 1-1 1H7zm4-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6z"/>
      <path fill-rule="evenodd" d="M5.216 14A2.238 2.238 0 0 1 5 13c0-1.355.68-2.75 1.936-3.72A6.325 6.325 0 0 0 5 9c-4 0-5 3-5 4s1 1 1 1h4.216z"/>
      <path d="M4.5 8a2.5 2.5 0 1 0 0-5 2.5 2.5 0 0 0 0 5z"/>
    SVG
  end

  def file_icon_path
    <<~SVG
      <path d="M9.293 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V4.707A1 1 0 0 0 13.707 4L10 .293A1 1 0 0 0 9.293 0zM9.5 3.5v-2l3 3h-2a1 1 0 0 1-1-1zM4.5 9a.5.5 0 0 1 0-1h7a.5.5 0 0 1 0 1h-7zM4 10.5a.5.5 0 0 1 .5-.5h7a.5.5 0 0 1 0 1h-7a.5.5 0 0 1-.5-.5zm.5 2.5a.5.5 0 0 1 0-1h4a.5.5 0 0 1 0 1h-4z"/>
    SVG
  end

  def life_preserver_icon_path
    <<~SVG
      <path d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16zm6.43-5.228a7.025 7.025 0 0 1-3.658 3.658l-1.115-2.788a4.015 4.015 0 0 0 1.985-1.985l2.788 1.115zM5.228 14.43a7.025 7.025 0 0 1-3.658-3.658l2.788-1.115a4.015 4.015 0 0 0 1.985 1.985L5.228 14.43zm9.202-9.202-2.788 1.115a4.015 4.015 0 0 0-1.985-1.985l1.115-2.788a7.025 7.025 0 0 1 3.658 3.658zm-8.087-.87a4.015 4.015 0 0 0-1.985 1.985L1.57 5.228A7.025 7.025 0 0 1 5.228 1.57l1.115 2.788zM8 11a3 3 0 1 1 0-6 3 3 0 0 1 0 6z"/>
    SVG
  end

  def gear_icon_path
    <<~SVG
      <path d="M9.405 1.05c-.413-1.4-2.397-1.4-2.81 0l-.1.34a1.464 1.464 0 0 1-2.105.872l-.31-.17c-1.283-.698-2.686.705-1.987 1.987l.169.311c.446.82.023 1.841-.872 2.105l-.34.1c-1.4.413-1.4 2.397 0 2.81l.34.1a1.464 1.464 0 0 1 .872 2.105l-.17.31c-.698 1.283.705 2.686 1.987 1.987l.311-.169a1.464 1.464 0 0 1 2.105.872l.1.34c.413 1.4 2.397 1.4 2.81 0l.1-.34a1.464 1.464 0 0 1 2.105-.872l.31.17c1.283.698 2.686-.705 1.987-1.987l-.169-.311a1.464 1.464 0 0 1 .872-2.105l.34-.1c1.4-.413 1.4-2.397 0-2.81l-.34-.1a1.464 1.464 0 0 1-.872-2.105l.17-.31c.698-1.283-.705-2.686-1.987-1.987l-.311.169a1.464 1.464 0 0 1-2.105-.872l-.1-.34zM8 10.93a2.929 2.929 0 1 1 0-5.86 2.929 2.929 0 0 1 0 5.858z"/>
    SVG
  end

  def lock_icon_path
    <<~SVG
      <path d="M8 1a2 2 0 0 1 2 2v4H6V3a2 2 0 0 1 2-2zm3 6V3a3 3 0 0 0-6 0v4a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2z"/>
    SVG
  end
end
