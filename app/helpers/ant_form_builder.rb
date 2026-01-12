class AntFormBuilder < ActionView::Helpers::FormBuilder
  # Input field
  def input(method, options = {})
    field_name = field_name_for(method)
    field_value = @object&.send(method)
    errors = @object&.errors&.[](method)

    @template.ant_input(
      name: field_name,
      value: field_value,
      placeholder: options[:placeholder],
      type: options[:type] || :text,
      disabled: options[:disabled],
      class: error_class(errors, options[:class]),
      **options.except(:placeholder, :type, :disabled, :class)
    ).tap do |html|
      html << error_messages(errors) if errors.present?
    end
  end

  # Select field
  def select(method, choices = nil, options = {}, html_options = {})
    field_name = field_name_for(method)
    field_value = @object&.send(method)
    errors = @object&.errors&.[](method)

    @template.ant_select(
      name: field_name,
      options: choices || options[:options] || [],
      selected: field_value,
      placeholder: options[:placeholder],
      multiple: options[:multiple],
      searchable: options[:searchable],
      disabled: options[:disabled],
      loading: options[:loading],
      max_tag_count: options[:max_tag_count],
      class: error_class(errors, html_options[:class]),
      **html_options.except(:class)
    ).tap do |html|
      html << error_messages(errors) if errors.present?
    end
  end

  # DatePicker field
  def date_picker(method, options = {})
    field_name = field_name_for(method)
    field_value = @object&.send(method)
    errors = @object&.errors&.[](method)

    @template.ant_date_picker(
      name: field_name,
      value: field_value,
      placeholder: options[:placeholder],
      disabled: options[:disabled],
      class: error_class(errors, options[:class]),
      **options.except(:placeholder, :disabled, :class)
    ).tap do |html|
      html << error_messages(errors) if errors.present?
    end
  end

  # Checkbox field
  def checkbox(method, options = {}, checked_value = "1", unchecked_value = "0")
    field_name = field_name_for(method)
    field_checked = @object&.send(method)
    errors = @object&.errors&.[](method)

    @template.ant_checkbox(
      name: field_name,
      value: checked_value,
      checked: field_checked,
      disabled: options[:disabled],
      size: options[:size],
      class: error_class(errors, options[:class]),
      **options.except(:disabled, :size, :class)
    ) do
      options[:label] || method.to_s.humanize
    end.tap do |html|
      html << error_messages(errors) if errors.present?
    end
  end

  # Switch field
  def switch(method, options = {})
    field_name = field_name_for(method)
    field_checked = @object&.send(method)
    errors = @object&.errors&.[](method)

    @template.ant_switch(
      name: field_name,
      checked: field_checked,
      disabled: options[:disabled],
      class: error_class(errors, options[:class]),
      **options.except(:disabled, :class)
    ).tap do |html|
      html << error_messages(errors) if errors.present?
    end
  end

  # Radio buttons
  def radio_button(method, tag_value, options = {})
    field_name = field_name_for(method)
    field_value = @object&.send(method)
    errors = @object&.errors&.[](method)

    @template.ant_radio(
      name: field_name,
      value: tag_value,
      checked: field_value == tag_value,
      disabled: options[:disabled],
      class: error_class(errors, options[:class]),
      **options.except(:disabled, :class)
    ) do
      options[:label] || tag_value.to_s.humanize
    end.tap do |html|
      html << error_messages(errors) if errors.present?
    end
  end

  # Transfer field
  def transfer(method, options = {})
    field_name = field_name_for(method)
    field_value = @object&.send(method) || []
    errors = @object&.errors&.[](method)

    @template.ant_transfer(
      name: field_name,
      options: options[:options] || [],
      selected: field_value,
      left_title: options[:left_title],
      right_title: options[:right_title],
      disabled: options[:disabled],
      class: error_class(errors, options[:class]),
      **options.except(:options, :left_title, :right_title, :disabled, :class)
    ).tap do |html|
      html << error_messages(errors) if errors.present?
    end
  end

  # Submit button
  def submit(label = nil, options = {})
    label ||= submit_default_value
    type = options.delete(:type) || :primary

    @template.ant_button(
      label,
      type: type,
      class: options[:class],
      **options.except(:class).merge(type: "submit")
    )
  end

  # Upload field (file upload)
  def upload(method, options = {}, &block)
    field_name = field_name_for(method)
    errors = @object&.errors&.[](method)

    @template.ant_upload(
      name: field_name,
      mode: :file,
      accept: options[:accept],
      multiple: options[:multiple],
      max_size: options[:max_size],
      max_count: options[:max_count],
      disabled: options[:disabled],
      list_type: options[:list_type] || :text,
      class: error_class(errors, options[:class]),
      **options.except(:accept, :multiple, :max_size, :max_count, :disabled, :list_type, :class),
      &block
    ).tap do |html|
      html << error_messages(errors) if errors.present?
    end
  end

  # Image upload field
  def image_upload(method, options = {}, &block)
    field_name = field_name_for(method)
    errors = @object&.errors&.[](method)

    @template.ant_upload(
      name: field_name,
      mode: :image,
      accept: options[:accept] || "image/*",
      multiple: options[:multiple],
      max_size: options[:max_size],
      max_count: options[:max_count],
      disabled: options[:disabled],
      list_type: options[:list_type] || :"picture-card",
      class: error_class(errors, options[:class]),
      **options.except(:accept, :multiple, :max_size, :max_count, :disabled, :list_type, :class),
      &block
    ).tap do |html|
      html << error_messages(errors) if errors.present?
    end
  end

  private

  def field_name_for(method)
    if @object_name.present?
      "#{@object_name}[#{method}]"
    else
      method.to_s
    end
  end

  def error_class(errors, base_class = nil)
    if errors.present?
      [ base_class, "border-red-500" ].compact.join(" ")
    else
      base_class
    end
  end

  def error_messages(errors)
    return "".html_safe if errors.blank?

    @template.content_tag(:div, class: "text-red-500 text-sm mt-1") do
      errors.map { |error| @template.content_tag(:div, error) }.join.html_safe
    end
  end

  def submit_default_value
    object = @object || @object_name.to_s.classify.safe_constantize&.new
    key = object&.persisted? ? :update : :create
    model = object.class.model_name.human
    @template.t("helpers.submit.#{key}", model: model, default: key.to_s.humanize)
  end
end
