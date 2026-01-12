# Project Context for AI Assistants (Copilot, etc.)

## 1. Technology Stack
- **Backend**: Ruby on Rails 8.1+
- **Frontend (Admin)**: Hotwire (Turbo + Stimulus), Tailwind CSS v4
- **Component System**: ViewComponent
- **Database**: PostgreSQL

## 2. Coding Guidelines
- **Style**: Standard Ruby/Rails conventions.
- **UI Framework**: DO NOT use Bootstrap. Use **Tailwind CSS** with our custom `Ant` components.
- **HTML/ERB**: Always prefer using the provided **UI Helper DSL** instead of raw HTML tags.

## 3. UI Component Library (Ant Design Style)

When writing views, ALWAYS use the following helpers. Do NOT write raw `<div>` with Tailwind classes for these standard elements.

*(See component-specific docs in `/components`)*

### Button
```erb
<%= ant_button "Save", type: :primary %>
```

### Input & Form
```erb
<%= ant_input name: "user[email]" %>

<!-- Basic Select (单选) -->
<%= ant_select name: "user[role]", options: ["Admin", "User"] %>

<!-- Select with Custom Label/Value (自定义标签和值) -->
<%= ant_select name: "country", options: [["中国", "cn"], ["美国", "us"]], selected: "cn" %>

<!-- Select with Search (带搜索功能) -->
<%= ant_select name: "country", options: [["中国", "cn"], ["美国", "us"], ["日本", "jp"]], searchable: true %>

<!-- Multiple Select (多选) -->
<%= ant_select name: "tags[]", options: ["Tag1", "Tag2", "Tag3"], multiple: true, selected: ["Tag1"] %>

<!-- Multiple + Search + Max Tag Count (多选+搜索+标签数量限制) -->
<%= ant_select name: "skills[]", 
               options: ["Ruby", "Rails", "JavaScript", "React", "Vue"], 
               multiple: true, 
               searchable: true,
               max_tag_count: 3,
               selected: ["Ruby", "Rails"] %>

<!-- Select with Loading State (加载中状态) -->
<%= ant_select name: "city", options: @cities, loading: true %>

<!-- Disabled Select (禁用状态) -->
<%= ant_select name: "status", options: ["Active", "Inactive"], disabled: true %>
```

**Select 组件参数说明：**
- `name`: 表单字段名称（多选时使用 `name[]` 格式）
- `options`: 选项数组，支持 `["A", "B"]` 或 `[["标签", "值"]]` 格式
- `selected`: 默认选中值（多选时传数组）
- `placeholder`: 占位符文本（默认 "Please select"）
- `disabled`: 是否禁用
- `multiple`: 是否多选模式
- `searchable`: 是否启用搜索功能
- `loading`: 是否显示加载动画
- `max_tag_count`: 多选时最多显示的标签数量，超出显示 "+N"

**Select 组件特性：**
- 下拉选项列表最大高度为 256px（约 8-10 个选项）
- 选项超出时自动显示滚动条，支持鼠标滚轮��触摸板滚动
- 多选模式下，标签显示在触发器中，可点击 ❌ 删除
- 搜索模式下，打开下拉框时自动聚焦搜索输入框
- 点击组件外部或按 ESC 键自动关闭下拉框

### Form Builder（表单构建器）

**推荐使用 `ant_form_for` 或 `ant_form_with` 来创建表单，自动集成所有 Ant 组件：**

```erb
<%= ant_form_for @user, url: user_path(@user) do |f| %>
  <%= f.input :name, placeholder: "Enter name" %>
  <%= f.input :email, type: :email %>
  <%= f.select :role, [["Admin", "admin"], ["User", "user"]] %>
  <%= f.date_picker :birthday %>
  <%= f.checkbox :active, label: "Active" %>
  <%= f.submit "Save" %>
<% end %>
```

**Form Builder 特性：**
- 自动绑定 model 数据
- 自动显示验证错误（红色边框 + 错误文本）
- 支持所有 Ant 组件
- 自动生成字段名称（如 `user[name]`）

### DatePicker
```erb
<!-- Basic DatePicker (基本日期选择) -->
<%= ant_date_picker name: "user[birthday]", placeholder: "Select date" %>

<!-- DatePicker with Value (带默认值) -->
<%= ant_date_picker name: "appointment_date", value: Date.today %>

<!-- Disabled DatePicker (禁用状态) -->
<%= ant_date_picker name: "locked_date", value: "2024-01-15", disabled: true %>
```

**DatePicker 组件参数说明：**
- `name`: 表单字段名称
- `value`: 默认选中的日期，支持 Date/Time/DateTime/String
- `placeholder`: 输入框占位符（默认 "Select date"）
- `disabled`: 是否禁用

**DatePicker 组件特性：**
- 日期格式统一为 "YYYY-MM-DD" 字符串存储
- 点击输入框触发器打开日历面板
- 点击日期单元格选中日期并自动关闭面板
- 通过隐藏 input 字段提交选中的日期值

### Transfer
```erb
<!-- Basic Transfer (基本穿梭框) -->
<%= ant_transfer name: "permissions", 
                 options: [["查看", "view"], ["编辑", "edit"], ["删除", "delete"]],
                 selected: ["view"] %>

<!-- Transfer with Titles (自定义标题) -->
<%= ant_transfer name: "roles", 
                 options: [["Admin", "admin"], ["User", "user"]],
                 selected: ["admin"],
                 left_title: "可选角色",
                 right_title: "已分配" %>

<!-- Disabled Transfer (禁用状态) -->
<%= ant_transfer name: "locked", 
                 options: [["A", "a"], ["B", "b"]],
                 selected: ["a"],
                 disabled: true %>
```

**Transfer 组件参数说明：**
- `name`: 表单字段名称（自动添加 [] 后缀）
- `options`: 选项列表，支持 `["A", "B"]` 或 `[["标签", "值"]]` 格式
- `selected`: 默认选中的值数组
- `left_title`: 左侧面板标题（默认 "Source"）
- `right_title`: 右侧面板标题（默认 "Target"）
- `disabled`: 是否禁用

**Transfer 组件特性：**
- 双栏显示未选中和已选中的项
- 中间操作按钮 ">" 和 "<" 用于移动项目
- 显示每个面板的项目数量统计
- 通过多个隐藏 input (name[]) 字段提交选中值
- 禁用状态下所有交互元素不可操作

### Upload
```erb
<!-- Basic File Upload (基本文件上传) -->
<%= ant_upload name: "document" do %>
  Support for a single or bulk upload.
<% end %>

<!-- Multiple Files with Limits (多文件上传带限制) -->
<%= ant_upload name: "documents[]", 
               multiple: true, 
               max_count: 5, 
               max_size: 10 do %>
  Maximum 5 files, each file size should not exceed 10MB.
<% end %>

<!-- Image Upload (图片上传) -->
<%= ant_upload name: "avatar", mode: :image, max_count: 1 %>

<!-- Image Gallery (图片墙) -->
<%= ant_upload name: "gallery[]", 
               mode: :image, 
               list_type: :"picture-card",
               multiple: true,
               max_count: 8,
               max_size: 5 do %>
  Upload images (Max 8 files, 5MB each)
<% end %>
```

**Upload 组件参数说明：**
- `name`: 表单字段名称（必填）
- `mode`: 上传模式，`:file`（文件）或 `:image`（图片），默认 `:file`
- `accept`: 接受的文件类型，如 `"image/*"` 或 `".pdf,.doc"`
- `multiple`: 是否支持多文件上传，默认 `false`
- `max_size`: 单个文件最大大小限制（MB）
- `max_count`: 最多上传文件数量
- `list_type`: 上传列表样式，`:text` 或 `:picture-card`，默认 `:text`

**Upload 组件特性：**
- 支持文件和图片两种上传模式
- 图片模式自动设置 `accept="image/*"`
- 客户端文件大小和数量验证
- 达到最大数量后自动隐藏上传按钮
- Form Builder 提供 `f.upload` 和 `f.image_upload` 方法

### Image
```erb
<!-- Basic Image (基本图片) -->
<%= ant_image src: "https://example.com/image.jpg", alt: "Example" %>

<!-- With Size (自定义尺寸) -->
<%= ant_image src: "image.jpg", width: 300, height: 200 %>

<!-- With Preview (带预览功能) -->
<%= ant_image src: "image.jpg", preview: true, width: 200 %>

<!-- With Fallback (容错处理) -->
<%= ant_image src: "broken.jpg", fallback: "https://example.com/fallback.jpg" %>
```

**Image 组件参数说明：**
- `src`: 图片地址（必填）
- `alt`: 图片描述
- `width`: 图片宽度（像素）
- `height`: 图片高度（像素）
- `preview`: 是否支持预览，默认 `false`
- `placeholder`: 加载占位图 URL
- `fallback`: 加载失败容错图 URL

**Image 组件特性：**
- 懒加载：自动使用 loading="lazy"
- 占位图：加载过程中显示 placeholder
- 容错处理：加载失败时自动切换到 fallback
- 预览功能：点击打开全屏预览

### Empty
```erb
<!-- Basic Empty (基本空状态) -->
<%= ant_empty %>

<!-- Custom Description (自定义描述) -->
<%= ant_empty description: "No products found" %>

<!-- Simple Style (简单样式) -->
<%= ant_empty description: "No data", image: :simple %>

<!-- With Action Button (带操作按钮) -->
<%= ant_empty description: "No items yet" do %>
  <%= ant_button "Create New", type: :primary %>
<% end %>

<!-- Custom Image (自定义图片) -->
<%= ant_empty description: "Custom state", image: "https://example.com/empty.png" %>
```

**Empty 组件参数说明：**
- `description`: 空状态描述文字，默认 "No Data"
- `image`: 空状态图片，支持 `:default`、`:simple` 或自定义 URL
- 可通过 block 传入操作按钮或其他内容

**Empty 组件特性：**
- 内置默认和简约两种样式
- 支持自定义描述和图片
- 可添加操作按钮引导用户

### Badge
```erb
<!-- Basic Badge (基本徽标) -->
<%= ant_badge count: 5 do %>
  <%= ant_button "通知", type: :default %>
<% end %>

<!-- Standalone Badge (独立使用) -->
<%= ant_badge count: 25 %>
<%= ant_badge count: 4, color: :blue %>

<!-- Max Count (封顶数字) -->
<%= ant_badge count: 100 do %>
  <%= ant_button "通知", type: :default %>
<% end %>

<!-- Dot Badge (小红点) -->
<%= ant_badge dot: true do %>
  <%= ant_button "通知", type: :default %>
<% end %>

<!-- Status Badge (状态点) -->
<%= ant_badge status: :success, text: "Success" %>
<%= ant_badge status: :processing, text: "Processing" %>
<%= ant_badge status: :error, text: "Error" %>

<!-- With Colors (多种颜色) -->
<%= ant_badge count: 5, color: :blue do %>
  <%= ant_button "Blue", type: :default %>
<% end %>
```

**Badge 组件参数说明：**
- `count`: 展示的数字，默认 `0`
- `dot`: 不展示数字，只显示小红点，默认 `false`
- `show_zero`: 当数值为 0 时是否展示，默认 `false`
- `max`: 最大值，超过显示 '{max}+'，默认 `99`
- `color`: 自定义颜色（预设色: blue, green, red, yellow, orange, purple, cyan, magenta）
- `status`: 状态点模式（success, processing, error, warning, default）
- `text`: 状态点的文本
- `offset`: 位置偏移 `[x, y]`

**Badge 组件特性：**
- 可包裹任意元素或独立使用
- 支持数字显示和小红点两种模式
- 封顶数字显示 99+
- 多种预设颜色
- 状态点模式支持动画效果

### Notification
```erb
<!-- JavaScript 方式触发通知 -->
<button onclick="showNotification()">Open Notification</button>

<script>
function showNotification() {
  const html = `<%= ant_notification(
    message: 'Notification Title',
    description: 'This is the content of the notification.'
  ) %>`;
  document.body.insertAdjacentHTML('beforeend', html);
}
</script>

<!-- 不同类型 -->
<%= ant_notification(message: 'Success', description: 'Success message', type: 'success') %>
<%= ant_notification(message: 'Error', description: 'Error message', type: 'error') %>
<%= ant_notification(message: 'Warning', description: 'Warning message', type: 'warning') %>

<!-- 不同位置 -->
<%= ant_notification(message: 'Top Left', placement: 'topLeft') %>
<%= ant_notification(message: 'Bottom Right', placement: 'bottomRight') %>

<!-- 自定义时长 -->
<%= ant_notification(message: 'Quick', duration: 1500) %>
<%= ant_notification(message: 'Never Close', duration: 0) %>
```

**Notification 组件参数说明：**
- `message`: 通知提醒标题（必选）
- `description`: 通知提醒内容
- `type`: 通知类型（'success', 'info', 'warning', 'error'），默认 'info'
- `duration`: 自动关闭延时（毫秒），0 表示不自动关闭，默认 4500
- `placement`: 弹出位置（'topLeft', 'topRight', 'bottomLeft', 'bottomRight'），默认 'topRight'
- `show_icon`: 是否显示图标，默认 true
- `closable`: 是否显示关闭按钮，默认 true

**Notification 组件特性：**
- 在页面四个角落显示
- 支持多个通知同时显示
- 自动排列，不会重叠
- 带有流畅的进入/退出动画
- 点击关闭按钮或自动关闭

### Message
```erb
<!-- JavaScript 方式触发消息 -->
<button onclick="showMessage()">Show Message</button>

<script>
function showMessage() {
  const html = `<%= ant_message(content: 'This is a message') %>`;
  document.body.insertAdjacentHTML('beforeend', html);
}
</script>

<!-- 不同类型 -->
<%= ant_message(content: 'Success message', type: 'success') %>
<%= ant_message(content: 'Error message', type: 'error') %>
<%= ant_message(content: 'Warning message', type: 'warning') %>
<%= ant_message(content: 'Loading...', type: 'loading') %>

<!-- 自定义时长 -->
<%= ant_message(content: 'Quick message', duration: 1000) %>
<%= ant_message(content: 'Persistent message', duration: 0) %>
```

**Message 组件参数说明：**
- `content`: 提示内容（必选）
- `type`: 提示类型（'success', 'info', 'warning', 'error', 'loading'），默认 'info'
- `duration`: 自动关闭延时（毫秒），0 表示不自动关闭，默认 3000
- `show_icon`: 是否显示图标，默认 true

**Message 组件特性：**
- 顶部居中显示
- 轻量级提示，不打断用户操作
- 支持多个消息同时显示
- 自动垂直排列
- 流畅的进入/退出动画
- loading 类型显示旋转动画

### Card
- `description`: 描述文案，默认 "No Data"
- `image`: 空状态图片，`:default`、`:simple` 或自定义 URL

**Empty 组件特性：**
- 默认图片：Ant Design 风格的空状态插画
- 简单图标：适合小空间
- 可添加操作按钮
- 适用于列表为空、搜索无结果等场景

### Table
```erb
<%= ant_table(@users) %>
```

## 4. Architecture Rules & Workflow (DEFINITION OF DONE)

**CRITICAL**: When creating a NEW component (e.g., `Ant::NewComponent`), you MUST complete ALL following steps in order. **No component is considered "complete" until all three phases (Implementation + Testing + Documentation) are finished.**

### Step 1: Component Implementation
1.  **Create Component Class**: `app/components/ant/new_component.rb`
    ```ruby
    class Ant::NewComponent < ViewComponent::Base
      def initialize(name:, **options)
        @name = name
        @options = options
      end
    end
    ```

2.  **Create Component Template**: `app/components/ant/new_component.html.erb`
    ```erb
    <div data-controller="ant--new" class="...">
      <!-- Component HTML structure -->
    </div>
    ```

3.  **Register Helper Method**: Add to `app/helpers/ant_helper.rb`
    ```ruby
    def ant_new(**options, &block)
      render(Ant::NewComponent.new(**options), &block)
    end
    ```

4.  **Create Stimulus Controller** (if interactive): `app/javascript/controllers/ant/new_controller.js`
    ```javascript
    import { Controller } from "@hotwired/stimulus"
    
    export default class extends Controller {
      static targets = ["element"]
      
      connect() {
        // Initialization logic
      }
    }
    ```

5.  **⚠️ For Form Input Components ONLY**: If creating a form field component (Input, Select, DatePicker, etc.), you MUST also:
    - **Add method to AntFormBuilder**: Open `app/helpers/ant_form_builder.rb` and add:
      ```ruby
      def new_component(method, options = {})
        @template.ant_new(
          name: field_name_for(method),
          value: @object&.send(method),
          class: error_class(@object&.errors&.[](method), options[:class]),
          **options
        ).tap do |html|
          html << error_messages(@object&.errors&.[](method))
        end
      end
      ```
    - **Update Form documentation**: Add example to `app/views/components/form.html.erb`
    - **Update API table**: Add the new method to Form Builder methods table

### Step 2: Unit Testing (REQUIRED)
**CRITICAL**: Every new component MUST have comprehensive unit tests. Tests are NOT optional.

1.  **Create Test File**: `test/components/ant/new_component_test.rb`
    ```ruby
    require "test_helper"

    class Ant::NewComponentTest < ViewComponent::TestCase
      test "renders component with default props" do
        render_inline(Ant::NewComponent.new(name: "test"))
        
        assert_selector "div[data-controller='ant--new']"
        assert_text "Expected Text"
      end
      
      # Add more tests for different states and props
    end
    ```

2.  **Test Coverage Requirements**:
    - ✅ Default rendering (basic props)
    - ✅ All variant states (e.g., checked/unchecked, enabled/disabled)
    - ✅ Different sizes (if applicable)
    - ✅ Custom HTML options (class, data attributes)
    - ✅ Content blocks (if component uses `content`)
    - ✅ Edge cases (empty state, loading state, etc.)

3.  **Common Testing Patterns**:
    ```ruby
    # For components with content blocks
    render_inline(Ant::NewComponent.new) do
      "Content text"
    end
    
    # For hidden inputs (use visible: :all)
    assert_selector "input[type='hidden']", visible: :all
    
    # For case-insensitive text matching
    assert_text /text/i
    
    # For multiple variants
    [:small, :default, :large].each do |size|
      render_inline(Ant::NewComponent.new(size: size))
      # assertions...
    end
    ```

4.  **Run Tests**: `rails test test/components/ant/new_component_test.rb`

### Step 3: Documentation Page (REQUIRED)
**CRITICAL**: You MUST create a comprehensive documentation page demonstrating the component. This is NOT optional.

1.  **Add Code Example Methods**: Open `app/helpers/documentation_helper.rb`
    ```ruby
    def new_basic_code
      <<~RUBY
        <%= ant_new name: "example" %>
      RUBY
    end
    
    def new_with_options_code
      <<~RUBY
        <%= ant_new name: "example", 
                    disabled: true,
                    class: "custom-class" %>
      RUBY
    end
    ```
    *Reason*: Using helper methods prevents ERB syntax errors in documentation views.

2.  **Create Documentation View**: `app/views/components/new.html.erb`
    
    **Required Structure** (following Ant Design documentation standard):
    
    ```erb
    <%# 1. Component Header: Title, Description, When To Use %>
    <%= render Ui::ComponentHeaderComponent.new(
      title: "New Component",
      description: "Brief description of what this component does.",
      when_to_use: [
        "Scenario A: When you need...",
        "Scenario B: When you want...",
        "Scenario C: When you have..."
      ]
    ) %>

    <%# 2. Examples: Render component + show code %>
    <%= render Ui::ExampleComponent.new(
      title: "Basic Usage",
      language: :erb,
      code: new_basic_code
    ) do %>
      <%= ant_new name: "basic_example" %>
    <% end %>

    <%= render Ui::ExampleComponent.new(
      title: "With Options",
      language: :erb,
      code: new_with_options_code
    ) do %>
      <%= ant_new name: "advanced", disabled: true %>
    <% end %>

    <%# 3. API Documentation Table %>
    <h3 class="text-xl font-bold text-gray-800 mb-4 mt-12">API</h3>
    <%= render Ui::ApiTableComponent.new do |api| %>
      <% api.row "name", "Form field name", "String", "-", true %>
      <% api.row "disabled", "Whether disabled", "Boolean", "false", false %>
      <% api.row "class", "Additional CSS classes", "String", "-", false %>
    <% end %>
    ```

3.  **Register in Navigation**: Edit `app/views/layouts/components.html.erb`
    ```erb
    <!-- Add link in appropriate category -->
    <%= link_to "New 新组件", 
                component_doc_path("new"),
                class: "..." %>
    ```

4.  **Whitelist in Controller**: Edit `app/controllers/components_controller.rb`
    ```ruby
    def show
      @component = params[:component]
      
      valid_components = [
        # ... existing components
        'new'  # Add your component here
      ]
      
      # ... rest of method
    end
    ```

5.  **Update Context Documentation**: Add usage example to this file (`llm_context.md` Section 3)
    ```markdown
    ### New Component
    \```erb
    <%= ant_new name: "example" %>
    \```
    ```

### Step 4: Verification Checklist
Before considering a component "complete", verify ALL items:

**Phase 1: Implementation**
- [ ] Component class created (`app/components/ant/new_component.rb`)
- [ ] Component template created (`app/components/ant/new_component.html.erb`)
- [ ] Helper method registered in `app/helpers/ant_helper.rb`
- [ ] Stimulus controller created (if component requires interactivity)
- [ ] Component renders correctly in all states
- [ ] **For form components**: Method added to `AntFormBuilder` with error handling
- [ ] **For form components**: Form documentation updated with example
- [ ] **For form components**: API table updated with new method

**Phase 2: Testing**
- [ ] Test file created (`test/components/ant/new_component_test.rb`)
- [ ] Tests cover default rendering with basic props
- [ ] Tests cover all variant states (enabled/disabled, checked/unchecked, etc.)
- [ ] Tests cover different sizes (if applicable: small/default/large)
- [ ] Tests cover custom HTML options (class, data attributes, style)
- [ ] Tests cover content blocks (if component uses `content`)
- [ ] Tests cover edge cases (empty state, loading state, error state)
- [ ] All tests passing: `rails test test/components/ant/new_component_test.rb`

**Phase 3: Documentation**
- [ ] Code example methods added to `app/helpers/documentation_helper.rb`
- [ ] Documentation page created (`app/views/components/new.html.erb`)
- [ ] Page includes `Ui::ComponentHeaderComponent` with title/description/when_to_use
- [ ] Page includes multiple `Ui::ExampleComponent` blocks (basic + advanced usage)
- [ ] Page includes `Ui::ApiTableComponent` documenting all props/parameters
- [ ] Component link added to sidebar navigation (`app/views/layouts/components.html.erb`)
- [ ] Component whitelisted in controller (`app/controllers/components_controller.rb`)
- [ ] Usage example added to `llm_context.md` Section 3
- [ ] Documentation accessible at `/components/new` URL

**⚠️ IMPORTANT REMINDERS:**
1. **DO NOT skip unit tests** - They are mandatory for every component
2. **DO NOT skip documentation** - It must be created immediately after implementation
3. **Test first, then document** - Ensures component works before showing examples
4. **Update all 4 locations** for documentation: helper methods → view page → sidebar → controller
5. **For form components**: MUST update AntFormBuilder + Form documentation page + API table

**✅ Definition of "Done":**
A component is ONLY complete when all 3 phases (Implementation + Testing + Documentation) are finished and all checklist items are verified.
