module DocumentationHelper
  def button_types_code
    <<~RUBY
      <%= ant_button "Primary Button", type: :primary %>
      <%= ant_button "Default Button" %>
      <%= ant_button "Dashed Button", type: :dashed %>
      <%= ant_button "Text Button", type: :text %>
      <%= ant_button "Link Button", type: :link %>
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

  def button_size_code
    <<~RUBY
      <%= ant_button "Large", type: :primary, size: :large %>
      <%= ant_button "Middle", type: :primary, size: :middle %>
      <%= ant_button "Small", type: :primary, size: :small %>
    RUBY
  end

  def button_disabled_code
    <<~RUBY
      <%= ant_button "Disabled Primary", type: :primary, disabled: true %>
      <%= ant_button "Disabled Default", disabled: true %>
    RUBY
  end

  def button_loading_code
    <<~RUBY
      <%= ant_button "Loading", type: :primary, loading: true %>
      <%= ant_button "Normal Button", type: :primary %>
    RUBY
  end

  def button_danger_code
    <<~RUBY
      <%= ant_button "Delete", type: :primary, danger: true %>
      <%= ant_button "Delete", type: :default, danger: true %>
      <%= ant_button "Delete", type: :dashed, danger: true %>
      <%= ant_button "Delete", type: :text, danger: true %>
      <%= ant_button "Delete", type: :link, danger: true %>
    RUBY
  end

  def button_ghost_code
    <<~RUBY
      <div class="bg-gray-800 p-4 rounded">
        <%= ant_button "Primary", type: :primary, ghost: true %>
        <%= ant_button "Default", ghost: true %>
        <%= ant_button "Dashed", type: :dashed, ghost: true %>
        <%= ant_button "Danger", type: :primary, danger: true, ghost: true %>
      </div>
    RUBY
  end

  def button_block_code
    <<~RUBY
      <%= ant_button "Block Button", type: :primary, block: true %>
      <%= ant_button "Block Button", block: true, class: "mt-2" %>
    RUBY
  end

  def button_debounce_code
    <<~RUBY
      <!-- 防抖：300ms 内多次点击只执行一次 -->
      <%= ant_button "Search (Debounce 300ms)",#{' '}
                     type: :primary,#{' '}
                     debounce: 300,#{' '}
                     onclick: "console.log('Searched at', new Date())" %>
    RUBY
  end

  def button_throttle_code
    <<~RUBY
      <!-- 节流：每 1000ms 最多执行一次 -->
      <%= ant_button "Save (Throttle 1000ms)",#{' '}
                     type: :primary,#{' '}
                     throttle: 1000,#{' '}
                     onclick: "console.log('Saved at', new Date())" %>
    RUBY
  end

  def button_async_code
    <<~RUBY
      <%= ant_button "Submit Form",#{' '}
                     type: :primary,#{' '}
                     id: "async-btn",#{' '}
                     onclick: "handleAsyncSubmit(this)" %>

      <script>
      async function handleAsyncSubmit(btn) {
        const controller = btn.closest('[data-controller=\"ant--button\"]');
        if (!controller) return;
        #{' '}
        // 获取 Stimulus 控制器并设置加载状态
        const stimulusController = application.getControllerForElementAndIdentifier(
          controller, 'ant--button'
        );
        #{' '}
        if (stimulusController) {
          stimulusController.setLoading(true);
          #{' '}
          try {
            // 模拟异步操作
            await new Promise(resolve => setTimeout(resolve, 2000));
            console.log('Form submitted successfully');
          } finally {
            stimulusController.setLoading(false);
          }
        }
      }
      </script>
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

  def table_sortable_code
    <<~RUBY
      <%= ant_table(@users, row_selection: { get_row_key: ->(user) { user.id } }) do |t| %>
        <% t.column "ID", sortable: true do |u| %>
          <%= u.id %>
        <% end %>

        <% t.column "Name", sortable: true do |u| %>
          <%= u.name %>
        <% end %>

        <% t.column "Role", filterable: true, filters: [
             { text: "Developer", value: "developer" },
             { text: "Designer", value: "designer" }
           ] do |u| %>
          <%= ant_tag u.role %>
        <% end %>

        <% t.column "Action" do |u| %>
          <a href="#">Edit</a>
        <% end %>
      <% end %>
    RUBY
  end

  def table_loading_code
    <<~RUBY
      <%= ant_table(@users, loading: true) do |t| %>
        <% t.column "ID" do |u| %>
          <%= u.id %>
        <% end %>
        <% t.column "Name" do |u| %>
          <%= u.name %>
        <% end %>
      <% end %>
    RUBY
  end

  def table_empty_code
    <<~RUBY
      <%= ant_table([], empty_text: "暂无数据") do |t| %>
        <% t.column "ID" do |u| %>
          <%= u.id %>
        <% end %>
        <% t.column "Name" do |u| %>
          <%= u.name %>
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

  def select_searchable_code
    <<~RUBY
      <%= ant_select name: "country",#{' '}
                     options: [["中国", "cn"], ["美国", "us"], ["日本", "jp"], ["英国", "uk"], ["法国", "fr"]],#{' '}
                     searchable: true,
                     placeholder: "Search to Select" %>
    RUBY
  end

  def select_multiple_code
    <<~RUBY
      <%= ant_select name: "tags[]",#{' '}
                     options: ["Ruby", "Rails", "JavaScript", "React", "Vue", "TypeScript"],#{' '}
                     multiple: true,
                     selected: ["Ruby", "Rails"],
                     placeholder: "Please select" %>
    RUBY
  end

  def select_multiple_search_code
    <<~RUBY
      <%= ant_select name: "skills[]",#{' '}
                     options: ["Ruby", "Rails", "JavaScript", "React", "Vue", "TypeScript", "Python", "Django", "Go", "Java"],#{' '}
                     multiple: true,
                     searchable: true,
                     selected: ["Ruby", "Rails", "JavaScript", "React"],
                     max_tag_count: 3,
                     placeholder: "Select skills" %>
    RUBY
  end

  def select_loading_code
    <<~RUBY
      <%= ant_select name: "city",#{' '}
                     options: ["北京", "上海", "广州", "深圳"],#{' '}
                     loading: true,
                     searchable: true,
                     placeholder: "Loading..." %>
    RUBY
  end

  def select_custom_code
    <<~RUBY
      <%= ant_select name: "user[role]",#{' '}
                     options: [["管理员", "admin"], ["编辑", "editor"], ["访客", "guest"]],#{' '}
                     selected: "editor",
                     class: "w-full" %>
    RUBY
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
      <button onclick="document.getElementById('my-modal').ant_modal_controller.open()"#{' '}
              class="px-4 py-2 bg-blue-600 text-white rounded">
        Open Modal
      </button>

      <!-- Modal Component -->
      <%= ant_modal(title: "Basic Modal", id: "my-modal", open: false) do %>
        <p>Some contents...</p>
        <p>Some contents...</p>
        <p>Some contents...</p>
      <% end %>
    RUBY
  end

  def modal_custom_footer_code
    <<~RUBY
      <button onclick="document.getElementById('custom-footer-modal').ant_modal_controller.open()"#{' '}
              class="px-4 py-2 bg-blue-600 text-white rounded">
        Custom Footer
      </button>

      <%= ant_modal(title: "Custom Footer", id: "custom-footer-modal") do |modal| %>
        <% modal.with_footer do %>
          <%= ant_button "Return", type: :default, onclick: "document.getElementById('custom-footer-modal').ant_modal_controller.close()" %>
          <%= ant_button "Submit", type: :primary, onclick: "document.getElementById('custom-footer-modal').ant_modal_controller.close()" %>
          <%= ant_button "Search on Google", type: :dashed, onclick: "window.open('https://google.com')" %>
        <% end %>
        <p>Modal content...</p>
      <% end %>
    RUBY
  end

  def modal_async_code
    <<~RUBY
      <button onclick="openAsyncModal()" class="px-4 py-2 bg-blue-600 text-white rounded">
        Async Modal
      </button>

      <%= ant_modal(title: "Async Operation", id: "async-modal") do %>
        <p>Click OK button to simulate an async operation...</p>
      <% end %>

      <script>
      function openAsyncModal() {
        const modal = document.getElementById('async-modal').ant_modal_controller;
        modal.open();
      #{'  '}
        // Listen for OK button click
        document.getElementById('async-modal').addEventListener('ant--modal:ok', async (event) => {
          event.preventDefault(); // Prevent default close behavior
      #{'    '}
          modal.setConfirmLoading(true);
      #{'    '}
          // Simulate async operation
          await new Promise(resolve => setTimeout(resolve, 2000));
      #{'    '}
          modal.setConfirmLoading(false);
          modal.close();
        }, { once: true });
      }
      </script>
    RUBY
  end

  def modal_confirm_code
    <<~RUBY
      <button onclick="showConfirm()" class="px-4 py-2 bg-blue-600 text-white rounded">
        Confirm Delete
      </button>

      <script>
      function showConfirm() {
        const modalHtml = `
          <%= ant_modal(
            title: "Are you sure?",
            id: "confirm-modal",
            open: true,
            ok_text: "Delete",
            cancel_text: "Cancel",
            destroy_on_close: true
          ) do %>
            <p class="text-red-600">This action cannot be undone.</p>
          <% end %>
        `;
      #{'  '}
        document.body.insertAdjacentHTML('beforeend', modalHtml);
      #{'  '}
        const modal = document.getElementById('confirm-modal');
      #{'  '}
        modal.addEventListener('ant--modal:ok', () => {
          console.log('Confirmed! Deleting...');
        });
      #{'  '}
        modal.addEventListener('ant--modal:cancel', () => {
          console.log('Cancelled');
        });
      }
      </script>
    RUBY
  end

  def modal_sizes_code
    <<~RUBY
      <%= ant_button "Small", onclick: "document.getElementById('small-modal').ant_modal_controller.open()" %>
      <%= ant_button "Middle (Default)", onclick: "document.getElementById('middle-modal').ant_modal_controller.open()" %>
      <%= ant_button "Large", onclick: "document.getElementById('large-modal').ant_modal_controller.open()" %>

      <%= ant_modal(title: "Small Modal", id: "small-modal", size: :small) do %>
        <p>This is a small modal (400px)</p>
      <% end %>

      <%= ant_modal(title: "Middle Modal", id: "middle-modal", size: :middle) do %>
        <p>This is a middle modal (520px, default)</p>
      <% end %>

      <%= ant_modal(title: "Large Modal", id: "large-modal", size: :large) do %>
        <p>This is a large modal (800px)</p>
      <% end %>
    RUBY
  end

  def modal_centered_code
    <<~RUBY
      <button onclick="document.getElementById('centered-modal').ant_modal_controller.open()"#{' '}
              class="px-4 py-2 bg-blue-600 text-white rounded">
        Centered Modal
      </button>

      <%= ant_modal(title: "Centered Modal", id: "centered-modal", centered: true) do %>
        <p>This modal is vertically centered.</p>
      <% end %>
    RUBY
  end

  def modal_no_close_code
    <<~RUBY
      <button onclick="document.getElementById('no-close-modal').ant_modal_controller.open()"#{' '}
              class="px-4 py-2 bg-blue-600 text-white rounded">
        No Close Button
      </button>

      <%= ant_modal(
        title: "No Close Button",#{' '}
        id: "no-close-modal",#{' '}
        closable: false,#{' '}
        mask_closable: false
      ) do %>
        <p>You must click Cancel or OK to close this modal.</p>
      <% end %>
    RUBY
  end

  def modal_custom_text_code
    <<~RUBY
      <button onclick="document.getElementById('custom-text-modal').ant_modal_controller.open()"#{' '}
              class="px-4 py-2 bg-blue-600 text-white rounded">
        Custom Button Text
      </button>

      <%= ant_modal(
        title: "Custom Button Text",#{' '}
        id: "custom-text-modal",#{' '}
        ok_text: "确定",#{' '}
        cancel_text: "取消"
      ) do %>
        <p>This modal has custom button text in Chinese.</p>
      <% end %>
    RUBY
  end

  def calendar_basic_code
    <<~RUBY
      <%= ant_calendar(value: Date.today) %>
    RUBY
  end

  def calendar_selectable_code
    <<~RUBY
      <%= ant_calendar(value: Date.today, selectable: true) %>
    RUBY
  end

  def calendar_events_code
    <<~RUBY
      <% events = [
        { date: Date.today, title: 'Team Meeting', color: 'blue' },
        { date: Date.today + 1, title: 'Project Deadline', color: 'red' },
        { date: Date.today + 2, title: 'Birthday Party', color: 'purple' }
      ] %>
      <%= ant_calendar(value: Date.today, events: events, selectable: true) %>
    RUBY
  end

  def calendar_year_mode_code
    <<~RUBY
      <%= ant_calendar(value: Date.today, mode: 'year') %>
    RUBY
  end

  def calendar_disabled_code
    <<~RUBY
      <%# 禁用周末 %>
      <% disable_weekends = ->(date) { [0, 6].include?(date.wday) } %>
      <%= ant_calendar(value: Date.today, selectable: true, disabled_date: disable_weekends) %>
    RUBY
  end

  def calendar_card_mode_code
    <<~RUBY
      <%= ant_calendar(value: Date.today, fullscreen: false, selectable: true) %>
    RUBY
  end

  def calendar_locale_code
    <<~RUBY
      <%= ant_calendar(value: Date.today, locale: 'zh', selectable: true) %>
    RUBY
  end

  def switch_basic_code
    '<%= ant_switch name: "notifications", checked: true %>'
  end

  def switch_with_label_code
    <<~RUBY
      <%= ant_switch name: "notifications", checked: true, label: "Enable notifications" %>
      <%= ant_switch name: "dark_mode", checked: false, label: "Dark mode" %>
    RUBY
  end

  def switch_disabled_code
    <<~RUBY
      <%= ant_switch name: "disabled_off", checked: false, disabled: true %>
      <%= ant_switch name: "disabled_on", checked: true, disabled: true, class: "ml-4" %>
    RUBY
  end

  def switch_text_code
    <<~RUBY
      <%= ant_switch name: "with_text", checked: true, checked_text: "开", unchecked_text: "关" %>
    RUBY
  end

  def switch_loading_code
    <<~RUBY
      <%= ant_switch name: "loading_off", checked: false, loading: true %>
      <%= ant_switch name: "loading_on", checked: true, loading: true, class: "ml-4" %>
    RUBY
  end

  def switch_size_code
    <<~RUBY
      <%= ant_switch name: "small_switch", checked: true, size: :small %>
      <%= ant_switch name: "default_switch", checked: true, size: :default, class: "ml-4" %>
    RUBY
  end
  # Radio Examples
  def radio_basic_code
    <<~RUBY
      <%= ant_radio name: "choice", value: "1", checked: true do %>
        Option 1
      <% end %>
      <%= ant_radio name: "choice", value: "2" do %>
        Option 2
      <% end %>
    RUBY
  end

  def radio_disabled_code
    <<~RUBY
      <%= ant_radio name: "disabled_choice", value: "1", checked: true, disabled: true do %>
        Disabled Selected
      <% end %>
      <%= ant_radio name: "disabled_choice", value: "2", disabled: true do %>
        Disabled Unselected
      <% end %>
    RUBY
  end

  def radio_size_code
    <<~RUBY
      <%= ant_radio name: "size_small", value: "1", checked: true, size: :small do %>
        Small
      <% end %>
      <%= ant_radio name: "size_default", value: "1", checked: true, size: :default do %>
        Default
      <% end %>
    RUBY
  end

  def radio_group_code
    <<~RUBY
      <div class="space-y-2">
        <%= ant_radio name: "plan", value: "basic", checked: true do %>
          Basic - Free
        <% end %>
        <%= ant_radio name: "plan", value: "pro" do %>
          Pro - $9.99/month
        <% end %>
        <%= ant_radio name: "plan", value: "enterprise" do %>
          Enterprise - Contact us
        <% end %>
      </div>
    RUBY
  end

  def radio_button_style_code
    <<~RUBY
      <div class="inline-flex border border-gray-300 rounded-md overflow-hidden">
        <%= ant_radio name: "view", value: "list", checked: true do %>
          List
        <% end %>
        <%= ant_radio name: "view", value: "grid" do %>
          Grid
        <% end %>
        <%= ant_radio name: "view", value: "kanban" do %>
          Kanban
        <% end %>
      </div>
    RUBY
  end

  # Checkbox Examples
  def checkbox_basic_code
    <<~RUBY
      <%= ant_checkbox name: "agree", checked: true do %>
        I agree to the terms
      <% end %>
    RUBY
  end

  def checkbox_disabled_code
    <<~RUBY
      <%= ant_checkbox name: "disabled_unchecked", disabled: true do %>
        Disabled Unchecked
      <% end %>
      <%= ant_checkbox name: "disabled_checked", checked: true, disabled: true do %>
        Disabled Checked
      <% end %>
    RUBY
  end

  def checkbox_group_code
    <<~RUBY
      <div class="space-y-2">
        <%= ant_checkbox name: "features[]", value: "notifications", checked: true do %>
          Notifications
        <% end %>
        <%= ant_checkbox name: "features[]", value: "newsletter" do %>
          Newsletter
        <% end %>
        <%= ant_checkbox name: "features[]", value: "updates" do %>
          Product Updates
        <% end %>
      </div>
    RUBY
  end

  def checkbox_indeterminate_code
    <<~RUBY
      <div data-controller="checkbox-group">
        <%= ant_checkbox name: "select_all",#{' '}
            data: {#{' '}
              "checkbox-group-target": "selectAll",#{' '}
              action: "change->checkbox-group#toggleSelectAll"#{' '}
            } do %>
          Select All
        <% end %>
      #{'  '}
        <div class="ml-6 space-y-2">
          <%= ant_checkbox name: "items[]", value: "apple", checked: true,
              data: {#{' '}
                "checkbox-group-target": "item",#{' '}
                action: "change->checkbox-group#toggleItem"#{' '}
              } do %>
            Apple
          <% end %>
          <%= ant_checkbox name: "items[]", value: "orange",
              data: {#{' '}
                "checkbox-group-target": "item",#{' '}
                action: "change->checkbox-group#toggleItem"#{' '}
              } do %>
            Orange
          <% end %>
        </div>
      </div>
    RUBY
  end

  def checkbox_size_code
    <<~RUBY
      <%= ant_checkbox name: "small_checkbox", checked: true, size: :small do %>
        Small
      <% end %>
      <%= ant_checkbox name: "default_checkbox", checked: true, size: :default do %>
        Default
      <% end %>
    RUBY
  end

  # DatePicker 代码示例
  def date_picker_basic_code
    '<%= ant_date_picker name: "user[birthday]", placeholder: "Select date" %>'
  end

  def date_picker_value_code
    <<~RUBY
      <%= ant_date_picker name: "appointment_date",#{' '}
                          value: Date.today,
                          placeholder: "Select date" %>
    RUBY
  end

  def date_picker_disabled_code
    <<~RUBY
      <%= ant_date_picker name: "locked_date",#{' '}
                          value: "2024-01-15",
                          disabled: true,
                          placeholder: "Disabled" %>
    RUBY
  end

  def date_picker_custom_code
    <<~RUBY
      <%= ant_date_picker name: "custom_date",#{' '}
                          placeholder: "Custom styled",
                          class: "w-full border-2 border-blue-500" %>
    RUBY
  end

  # Transfer 代码示例
  def transfer_basic_code
    <<~RUBY
      <%= ant_transfer name: "permissions",#{' '}
                       options: [["查看用户", "view_users"], ["编辑用户", "edit_users"], ["删除用户", "delete_users"], ["管理角色", "manage_roles"], ["系统设置", "system_settings"]],
                       selected: ["view_users", "manage_roles"] %>
    RUBY
  end

  def transfer_titles_code
    <<~RUBY
      <%= ant_transfer name: "assigned_roles",#{' '}
                       options: [["管理员", "admin"], ["编辑", "editor"], ["作者", "author"], ["访客", "guest"]],
                       selected: ["admin"],
                       left_title: "可选角色",
                       right_title: "已分配角色" %>
    RUBY
  end

  def transfer_disabled_code
    <<~RUBY
      <%= ant_transfer name: "locked_tags",#{' '}
                       options: [["Ruby", "ruby"], ["Rails", "rails"], ["JavaScript", "js"]],
                       selected: ["ruby", "rails"],
                       disabled: true,
                       left_title: "所有标签",
                       right_title: "已选标签" %>
    RUBY
  end

  def transfer_custom_code
    <<~RUBY
      <%= ant_transfer name: "features",#{' '}
                       options: [["特性 A", "feature_a"], ["特性 B", "feature_b"], ["特性 C", "feature_c"], ["特性 D", "feature_d"]],
                       selected: ["feature_a"],
                       left_title: "未启用",
                       right_title: "已启用",
                       class: "shadow-lg rounded-lg" %>
    RUBY
  end

  # Form 代码示例
  def form_basic_code
    <<~RUBY
      <%= ant_form_for @user, url: user_path(@user) do |f| %>
        <div>
          <label>Name</label>
          <%= f.input :name, placeholder: "Enter your name" %>
        </div>
        <div>
          <label>Email</label>
          <%= f.input :email, type: :email %>
        </div>
        <%= f.submit "Submit" %>
      <% end %>
    RUBY
  end

  def form_validation_code
    <<~RUBY
      <%= ant_form_for @user, url: user_path(@user) do |f| %>
        <div>
          <label>Email</label>
          <%= f.input :email %>
          <!-- 验证失败时自动显示红色边框和错误信息 -->
        </div>
        <div>
          <label>Age</label>
          <%= f.input :age, type: :number %>
        </div>
      <% end %>
    RUBY
  end

  def form_complete_code
    <<~RUBY
      <%= ant_form_for @user, url: user_path(@user) do |f| %>
        <div>
          <%= f.input :name %>
        </div>
        <div>
          <%= f.select :role, [["Admin", "admin"], ["Editor", "editor"]] %>
        </div>
        <div>
          <%= f.date_picker :birthday %>
        </div>
        <div>
          <%= f.checkbox :active, label: "Active Account" %>
        </div>
        <%= f.submit "Save Changes" %>
      <% end %>
    RUBY
  end

  def form_all_components_code
    <<~RUBY
      <%= ant_form_for @user, url: user_path(@user) do |f| %>
        <!-- Input 输入框 -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Name</label>
          <%= f.input :name, placeholder: "Enter your name" %>
        </div>
      #{'  '}
        <!-- Input with Type 带类型的输入框 -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
          <%= f.input :email, type: :email, placeholder: "your@email.com" %>
        </div>
      #{'  '}
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Password</label>
          <%= f.input :password, type: :password, placeholder: "Enter password" %>
        </div>
      #{'  '}
        <!-- Select 下拉选择 -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Role</label>
          <%= f.select :role, [["Admin", "admin"], ["Editor", "editor"], ["Viewer", "viewer"]] %>
        </div>
      #{'  '}
        <!-- DatePicker 日期选择 -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Birthday</label>
          <%= f.date_picker :birthday %>
        </div>
      #{'  '}
        <!-- Transfer 穿梭框 -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Permissions</label>
          <%= f.transfer :permissions,#{' '}
                         options: [["View", "view"], ["Edit", "edit"], ["Delete", "delete"], ["Manage", "manage"]],
                         left_title: "Available",
                         right_title: "Assigned" %>
        </div>
      #{'  '}
        <!-- Switch 开关 -->
        <div class="flex items-center">
          <%= f.switch :active, label: "Active Account" %>
        </div>
      #{'  '}
        <!-- Checkbox 复选框 -->
        <div class="flex items-center">
          <%= f.checkbox :newsletter, label: "Subscribe to newsletter" %>
        </div>
      #{'  '}
        <!-- Radio Button 单选按钮 -->
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Gender</label>
          <div class="space-y-2">
            <%= f.radio_button :gender, "male", label: "Male" %>
            <%= f.radio_button :gender, "female", label: "Female" %>
            <%= f.radio_button :gender, "other", label: "Other" %>
          </div>
        </div>
      #{'  '}
        <!-- Submit 提交按钮 -->
        <%= f.submit "Save All", type: :primary %>
      <% end %>
    RUBY
  end

  # Upload Examples
  def upload_basic_code
    <<~RUBY
      <%= ant_upload name: "document" do %>
        Support for a single or bulk upload.
      <% end %>
    RUBY
  end

  def upload_file_multiple_code
    <<~RUBY
      <%= ant_upload name: "documents[]", multiple: true, max_count: 5, max_size: 10 do %>
        Maximum 5 files, each file size should not exceed 10MB.
      <% end %>
    RUBY
  end

  def upload_image_basic_code
    <<~RUBY
      <%= ant_upload name: "avatar",#{' '}
                     mode: :image,#{' '}
                     list_type: :"picture-card",
                     max_count: 1 %>
    RUBY
  end

  def upload_image_gallery_code
    <<~RUBY
      <%= ant_upload name: "gallery[]",#{' '}
                     mode: :image,#{' '}
                     list_type: :"picture-card",
                     multiple: true,
                     max_count: 8,
                     max_size: 5 do %>
        Upload images (Max 8 files, 5MB each)
      <% end %>
    RUBY
  end

  def upload_disabled_code
    <<~RUBY
      <%= ant_upload name: "locked_file", disabled: true %>
    RUBY
  end

  def upload_custom_accept_code
    <<~RUBY
      <%= ant_upload name: "pdf_file", accept: ".pdf,.doc,.docx" do %>
        Only PDF and Word documents are allowed.
      <% end %>
    RUBY
  end

  # Image Examples
  def image_basic_code
    <<~RUBY
      <%= ant_image src: "https://via.placeholder.com/400x300", alt: "Example image" %>
    RUBY
  end

  def image_with_size_code
    <<~RUBY
      <%= ant_image src: "https://via.placeholder.com/800x600",#{' '}
                    alt: "Resized image",#{' '}
                    width: 300,#{' '}
                    height: 200 %>
    RUBY
  end

  def image_preview_code
    <<~RUBY
      <%= ant_image src: "https://via.placeholder.com/600x400",#{' '}
                    alt: "Preview image",#{' '}
                    preview: true,
                    width: 200 %>
    RUBY
  end

  def image_fallback_code
    <<~RUBY
      <%= ant_image src: "https://invalid-url.com/broken.jpg",#{' '}
                    alt: "Image with fallback",#{' '}
                    fallback: "https://via.placeholder.com/400x300?text=Fallback",
                    width: 300 %>
    RUBY
  end

  # Empty Examples
  def empty_basic_code
    "<%= ant_empty %>"
  end

  def empty_custom_description_code
    <<~RUBY
      <%= ant_empty description: "No products found" %>
    RUBY
  end

  def empty_simple_code
    <<~RUBY
      <%= ant_empty description: "No data", image: :simple %>
    RUBY
  end

  def empty_with_action_code
    <<~RUBY
      <%= ant_empty description: "No items yet" do %>
        <%= ant_button "Create New", type: :primary %>
      <% end %>
    RUBY
  end

  def empty_custom_image_code
    <<~RUBY
      <%= ant_empty description: "Custom empty state",#{' '}
                    image: "https://via.placeholder.com/300x200?text=Custom" %>
    RUBY
  end

  # Badge Examples
  def badge_basic_code
    <<~RUBY
      <%= ant_badge count: 5 do %>
        <%= ant_button "通知", type: :default %>
      <% end %>
    RUBY
  end

  def badge_standalone_code
    <<~RUBY
      <%= ant_badge count: 25 %>
      <%= ant_badge count: 4, color: :blue %>
      <%= ant_badge count: 109, color: :green %>
    RUBY
  end

  def badge_max_code
    <<~RUBY
      <%= ant_badge count: 99 do %>
        <%= ant_button "通知", type: :default %>
      <% end %>

      <%= ant_badge count: 100 do %>
        <%= ant_button "通知", type: :default %>
      <% end %>

      <%= ant_badge count: 1000, max: 999 do %>
        <%= ant_button "通知", type: :default %>
      <% end %>
    RUBY
  end

  def badge_dot_code
    <<~RUBY
      <%= ant_badge dot: true do %>
        <%= ant_button "通知", type: :default %>
      <% end %>
    RUBY
  end

  def badge_colors_code
    <<~RUBY
      <%= ant_badge count: 5, color: :blue do %>
        <%= ant_button "Blue", type: :default %>
      <% end %>

      <%= ant_badge count: 5, color: :green do %>
        <%= ant_button "Green", type: :default %>
      <% end %>

      <%= ant_badge count: 5, color: :red do %>
        <%= ant_button "Red", type: :default %>
      <% end %>
    RUBY
  end

  def badge_status_code
    <<~RUBY
      <%= ant_badge status: :success, text: "Success" %>
      <%= ant_badge status: :error, text: "Error" %>
      <%= ant_badge status: :default, text: "Default" %>
      <%= ant_badge status: :processing, text: "Processing" %>
      <%= ant_badge status: :warning, text: "Warning" %>
    RUBY
  end

  # Notification examples
  def notification_basic_code
    <<~RUBY
      <button onclick="showNotification()">
        Open Notification
      </button>

      <script>
      function showNotification() {
        const html = `<%= ant_notification(
          message: 'Notification Title',
          description: 'This is the content of the notification.'
        ) %>`;
        document.body.insertAdjacentHTML('beforeend', html);
      }
      </script>
    RUBY
  end

  def notification_types_code
    <<~RUBY
      <%= ant_notification(message: 'Success', description: 'This is a success message.', type: 'success') %>
      <%= ant_notification(message: 'Info', description: 'This is an info message.', type: 'info') %>
      <%= ant_notification(message: 'Warning', description: 'This is a warning message.', type: 'warning') %>
      <%= ant_notification(message: 'Error', description: 'This is an error message.', type: 'error') %>
    RUBY
  end

  def notification_placement_code
    <<~RUBY
      <%= ant_notification(message: 'Notification', description: 'Top Left', placement: 'topLeft') %>
      <%= ant_notification(message: 'Notification', description: 'Top Right', placement: 'topRight') %>
      <%= ant_notification(message: 'Notification', description: 'Bottom Left', placement: 'bottomLeft') %>
      <%= ant_notification(message: 'Notification', description: 'Bottom Right', placement: 'bottomRight') %>
    RUBY
  end

  def notification_duration_code
    <<~RUBY
      <%# 1.5 秒后自动关闭 %>
      <%= ant_notification(message: 'Quick Close', description: '1.5 seconds', duration: 1500) %>

      <%# 不自动关闭 %>
      <%= ant_notification(message: 'Never Close', description: 'Will not close automatically', duration: 0) %>
    RUBY
  end

  # Message examples
  def message_basic_code
    <<~RUBY
      <button onclick="showMessage()">
        Show Message
      </button>

      <script>
      function showMessage() {
        const html = `<%= ant_message(message: 'This is a normal message') %>`;
        document.body.insertAdjacentHTML('beforeend', html);
      }
      </script>
    RUBY
  end

  def message_types_code
    <<~RUBY
      <%= ant_message(message: 'Success message', type: 'success') %>
      <%= ant_message(message: 'Error message', type: 'error') %>
      <%= ant_message(message: 'Warning message', type: 'warning') %>
      <%= ant_message(message: 'Info message', type: 'info') %>
      <%= ant_message(message: 'Loading...', type: 'loading') %>
    RUBY
  end

  def message_duration_code
    <<~RUBY
      <%# 1秒后关闭 %>
      <%= ant_message(message: 'Quick message', duration: 1000) %>

      <%# 5秒后关闭 %>
      <%= ant_message(message: 'Long message', duration: 5000) %>

      <%# 不自动关闭 %>
      <%= ant_message(message: 'Persistent message', duration: 0) %>
    RUBY
  end

  # Pagination examples
  def pagination_basic_code
    <<~RUBY
      <%= ant_pagination current_page: 1, total_count: 50, per_page: 10 %>
    RUBY
  end

  def pagination_more_code
    <<~RUBY
      <%= ant_pagination current_page: 5, total_count: 500, per_page: 10 %>
    RUBY
  end

  def pagination_size_changer_code
    <<~RUBY
      <%= ant_pagination current_page: 1,#{' '}
                         total_count: 500,#{' '}
                         per_page: 20,#{' '}
                         show_size_changer: true %>
    RUBY
  end

  def pagination_with_table_code
    <<~RUBY
      <%# Controller %>
      def index
        @posts = Post.page(params[:page]).per(params[:per_page] || 10)
        @total_count = Post.count
        @current_page = params[:page] || 1
        @per_page = params[:per_page] || 10
      end

      <%# View %>
      <%= ant_table @posts do |t| %>
        <% t.column "Title" do |post| %>
          <%= post.title %>
        <% end %>
      <% end %>

      <%= ant_pagination current_page: @current_page,
                         total_count: @total_count,
                         per_page: @per_page,
                         show_size_changer: true %>
    RUBY
  end

  def pagination_jumper_code
    <<~RUBY
      <%= ant_pagination current_page: 3, 
                         total_count: 500, 
                         per_page: 10, 
                         show_quick_jumper: true %>
    RUBY
  end

  def pagination_simple_code
    <<~RUBY
      <%= ant_pagination current_page: 2, 
                         total_count: 50, 
                         per_page: 10, 
                         simple: true %>
    RUBY
  end

  def pagination_small_code
    <<~RUBY
      <%= ant_pagination current_page: 2, 
                         total_count: 100, 
                         per_page: 10, 
                         size: :small %>
    RUBY
  end

  def pagination_full_code
    <<~RUBY
      <%= ant_pagination current_page: 3, 
                         total_count: 500, 
                         per_page: 20,
                         show_size_changer: true,
                         show_quick_jumper: true,
                         page_size_options: [10, 20, 30, 50, 100] %>
    RUBY
  end
end
