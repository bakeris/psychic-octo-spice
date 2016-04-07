module AdministratorsHelper
  def activation_desactivation_links(current_user_profile, user)
    if user.published == false
      html = <<-HTML
        <a href="#{enable_administrator_account_path(user.id)}" class="tipS" original-title="Activer le compte">#{image_tag('icons/color/tick.png', alt: '')}</a>
      HTML
    else
      html = <<-HTML
        <a href="#{disable_administrator_account_path(user.id)}" class="tipS" original-title="Désactiver le compte">#{image_tag('icons/color/cross.png', alt: '')}</a>
      HTML
    end

    if current_user_profile != "Super Administrateur"
      html = ""
    end

    html.html_safe
  end
end
