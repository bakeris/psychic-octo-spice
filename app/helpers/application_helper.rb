module ApplicationHelper

  def flash_class_job(level)
    case level
    when :notice then "alert-blue"
    when :success then "alert-green"
    when :error then "alert-red"
    when :alert then "alert-green"
    end
  end

  def flash_class(level)
    case level
    when :notice then "nNote nInformation hideit"
    when :success then "nNote nSuccess hideit"
    when :error then "nNote nFailure hideit"
    when :alert then "nNote nWarning hideit"
    end
  end

  def flash_messages!
    [:notice, :error, :success, :alert].each do |key|
      if flash[key]
        @key = key
        @message = flash[key]
      end
    end

    return "" if @message.blank?

    html = <<-HTML
      <div class="#{flash_class(@key)}">
        <p><strong>#{@message}</strong></p>
      </div>
    HTML

    html.html_safe
  end

  def go_back()
    link_to('<span>Revenir en arrière</span>'.html_safe, 'javascript:history.go(-1);', class: 'button redB')
  end
end
