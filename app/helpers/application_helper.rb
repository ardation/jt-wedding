# frozen_string_literal: true

module ApplicationHelper
  def flash_class(level)
    case level&.to_sym
    when :notice then 'alert alert-info'
    when :success then 'alert alert-success'
    when :error then 'alert alert-danger'
    when :alert then 'alert alert-danger'
    end
  end

  def indefinite_articlerize(params_word)
    %w[a e i o u].include?(params_word[0].downcase) ? "an #{params_word}" : "a #{params_word}"
  end
end
