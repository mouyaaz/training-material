module Jekyll
  class IconTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      parts = text.strip.split
      @text = parts[0]
      @aria = true
      if parts[1] == 'aria=false' then
        @aria = false
      end
    end

    ##
    # This function renders the icon tag
    # Params:
    # +icon+:: The icon to render
    # +@area+:: Whether to add aria-hidden
    # +@text+:: The text to add to the icon
    #
    # Returns:
    # The HTML for the icon
    # Note: The icon text label is wrapped in a span with class "visually-hidden" to make it accessible to screen readers.
    #
    # Example:
    #  {% icon fa fa-github %}
    #  => <i class="fa fa-github" aria-hidden="true"></i>
    #  {% icon fa fa-github aria=false %}
    #  => <i class="fa fa-github"></i>
    def render_for_text(icon)
      if icon.empty?
        raise SyntaxError.new(
          "No icon defined for: '#{@text}'. " +
          "Please define it in `_config.yml` (under `icon-tag:`)."
        )
      end

      if icon.start_with?("fa")
        if @aria
          %Q(<i class="#{icon}" aria-hidden="true"></i><span class="visually-hidden">#{@text}</span>)
        else
          %Q(<i class="#{icon}" aria-hidden="true"></i>)
        end
      elsif icon.start_with?("ai")
        if @aria
          %Q(<i class="ai #{icon}" aria-hidden="true"></i><span class="visually-hidden">#{@text}</span>)
        else
          %Q(<i class="ai #{icon}" aria-hidden="true"></i>)
        end
      end
    end

    def render(context)
      cfg = get_config(context)
      icon = cfg[@text] || ''
      render_for_text(icon)
    end

    def get_config(context)
      context.registers[:site].config['icon-tag']
    end
  end

  class IconTagVar < IconTag
    def initialize(tag_name, text, tokens)
      super
      @text = text.strip
    end

    def render(context)
      cfg = get_config(context)
      icon = cfg[context[@text]] || ''
      render_for_text(icon)
    end
  end
end

Liquid::Template.register_tag('icon_var', Jekyll::IconTagVar)
Liquid::Template.register_tag('icon', Jekyll::IconTag)
