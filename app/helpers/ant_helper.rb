module AntHelper
  def ant_button(label = nil, type: :default, **options, &block)
    render Ant::ButtonComponent.new(label: label, type: type, **options), &block
  end

  def ant_card(title: nil, extra: nil, **options, &block)
    render Ant::CardComponent.new(title: title, extra: extra, **options), &block
  end

  def ant_tag(label = nil, color: :default, **options, &block)
    render Ant::TagComponent.new(label: label, color: color, **options), &block
  end

  def ant_input(name: nil, value: nil, type: :text, placeholder: nil, **options)
    render Ant::InputComponent.new(name: name, value: value, type: type, placeholder: placeholder, **options)
  end
  
  def ant_select(name: nil, options: [], selected: nil, disabled: false, **html_options)
    render Ant::SelectComponent.new(name: name, options: options, selected: selected, disabled: disabled, **html_options)
  end

  def ant_tabs(default: nil, **options, &block)
    render Ant::TabsComponent.new(default: default, **options), &block
  end

  def ant_table(collection, sticky_header: false, paginate: nil, **options, &block)
    component = Ant::TableComponent.new(collection, sticky_header: sticky_header, paginate: paginate, **options)
    block.call(component) if block_given?
    render component
  end

  def ant_pagination(current_page: 1, total_count: 0, per_page: 10, **options)
    render Ant::PaginationComponent.new(current_page: current_page, total_count: total_count, per_page: per_page, **options)
  end

  def ant_modal(title: nil, id: nil, open: false, **options, &block)
    render Ant::ModalComponent.new(title: title, id: id, open: open, **options), &block
  end
end