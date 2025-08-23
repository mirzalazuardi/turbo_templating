# frozen_string_literal: true

class SidebarNavItemComponent < ViewComponent::Base
  def initialize(href:, label:, icon_name:)
    @href = href
    @label = label
    @icon_name = icon_name
  end

  private

  def icon_path
    case @icon_name
    when "house" then house_icon_path
    when "briefcase" then briefcase_icon_path
    when "people" then people_icon_path
    when "file" then file_icon_path
    when "life-preserver" then life_preserver_icon_path
    when "gear" then gear_icon_path
    when "lock" then lock_icon_path
    else ''
    end
  end

  def active_classes
    "bg-white shadow-xs shadow-slate-300/50"
  end

  def inactive_classes
    "hover:bg-white hover:shadow-xs hover:shadow-slate-300/50 active:bg-white/75 active:text-slate-800 active:shadow-slate-300/10"
  end
end
