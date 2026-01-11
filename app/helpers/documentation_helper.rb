module DocumentationHelper
  def button_types_code
    <<~RUBY
      <%= ant_button "Primary Button", type: :primary %>
      <%= ant_button "Default Button" %>
      <%= ant_button "Dashed Button", class: "border-dashed" %>
      <%= ant_button "Danger Button", type: :primary, class: "!bg-red-500 !border-red-500" %>
    RUBY
  end

  def button_icon_code
    <<~RUBY
      <%= ant_button type: :primary do %>
        <span class="mr-2">🔍</span>Search
      <% end %>

      <%= ant_button class: "ml-2" do %>
        Download<span class="ml-2">⬇️</span>
      <% end %>
    RUBY
  end

  def table_basic_code
    <<~RUBY
      <%# 假设 @users 是来自 Controller 的数据 %>
      <%= ant_table(@users) do |t| %>
        <% t.column "ID" do |u| %>
          <%= u.id %>
        <% end %>

        <% t.column "Name" do |u| %>
          <div class="font-medium"><%= u.name %></div>
        <% end %>

        <% t.column "Action", class: "text-right" do |u| %>
          <%= link_to "Edit", edit_user_path(u) %>
        <% end %>
      <% end %>
    RUBY
  end
  
  def table_auto_code
    <<~RUBY
      <%# 懒人模式：不传递 Block，组件会自动推断列 %>
      <%= ant_table(@users) %>
    RUBY
  end

  def table_advanced_code
    <<~RUBY
      <%# 使用 ant_pagination 生成分页组件 %>
      <% pagination = ant_pagination(current_page: 2, total_count: 50, per_page: 10) %>
      
      <%= ant_table(@long_list, sticky_header: true, paginate: pagination) do |t| %>
        <% t.column "ID", sticky: :left, class: "w-20" do |u| %>
          <%= u.id %>
        <% end %>

        <% t.column "Name" do |u| %>
          <%= u.name %>
        <% end %>

        <%# ... 更多列 ... %>

        <% t.column "Action", sticky: :right, class: "text-right" do |u| %>
          <a>Edit</a>
        <% end %>
      <% end %>
    RUBY
  end
  
  def tabs_basic_code
    <<~RUBY
      <%= ant_tabs(default: "a") do |t| %>
        <% t.with_item(label: "Tab A", id: "a") do %>
           Content A
        <% end %>

        <% t.with_item(label: "Tab B", id: "b") do %>
           Content B
        <% end %>
      <% end %>
    RUBY
  end
  
  def input_basic_code
    '<%= ant_input name: "username", placeholder: "Basic usage" %>'
  end

  def input_password_code
    '<%= ant_input name: "password", type: :password, placeholder: "Input password" %>'
  end

  def input_disabled_code
    <<~RUBY
      <%= ant_input name: "disabled_input", placeholder: "Disabled", disabled: true %>
      <%= ant_input name: "readonly_input", value: "Readonly Value", readonly: true, class: "mt-4" %>
    RUBY
  end
  
  def select_basic_code
    '<%= ant_select name: "role", options: ["Admin", "User", "Guest"], selected: "User" %>'
  end

  def select_disabled_code
    '<%= ant_select name: "status", options: ["Active", "Inactive"], disabled: true %>'
  end
  
  def tag_basic_code
    <<~RUBY
      <%= ant_tag "Success", color: :success %>
      <%= ant_tag "Processing", color: :processing %>
      <%= ant_tag "Error", color: :error %>
      <%= ant_tag "Warning", color: :warning %>
    RUBY
  end
  
  def card_basic_code
    <<~RUBY
      <%= ant_card title: "Project Info", extra: ant_tag("Active", color: :success) do %>
        <p class="text-gray-600">This is a card content.</p>
        <p class="text-gray-600">It can hold anything.</p>
      <% end %>
    RUBY
  end

  def card_simple_code
    <<~RUBY
      <%= ant_card do %>
        <p class="text-gray-600">No title, just content.</p>
      <% end %>
    RUBY
  end

  def modal_basic_code
    <<~RUBY
      <!-- Trigger Button -->
      <button onclick="document.getElementById('my-modal').ant_modal_controller.open()" 
              class="px-4 py-2 bg-blue-600 text-white rounded">
        Open Modal
      </button>

      <!-- Modal Component -->
            <%= ant_modal(title: "Basic Modal", id: "my-modal", open: false) do |modal| %>
              <p>Some contents...</p>
              <p>Some contents...</p>
              <p>Some contents...</p>
            <% end %>
          RUBY
        end
      
        def calendar_basic_code
          <<~RUBY
            <%= ant_calendar(date: Date.today) %>
          RUBY
        end
      end
      