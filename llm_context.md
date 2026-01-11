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

### Table
```erb
<%= ant_table(@users) %>
```

## 4. Architecture Rules & Workflow (DEFINITION OF DONE)

**CRITICAL**: When creating a NEW component (e.g., `Ant::NewComponent`), you MUST complete ALL following steps in order.

### Step 1: Implementation
1.  **Create Component**: `app/components/ant/new_component.rb` & `.html.erb`.
2.  **Register Helper**: Add helper method (e.g., `ant_new`) to `app/helpers/ant_helper.rb`.

### Step 2: Unit Testing (REQUIRED)
**CRITICAL**: Every new component MUST have comprehensive unit tests.

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

### Step 3: Documentation (The "Kitchen Sink")
You must create a documentation page in `app/views/components/` that matches the **Ant Design Documentation Standard**.

1.  **Prepare Example Code**:
    - Open `app/helpers/documentation_helper.rb`.
    - Add a method returning the example code using Ruby Heredoc (`<<~RUBY`).
    - *Reason*: This prevents ERB syntax errors in the view.

2.  **Create Documentation View**: `app/views/components/new.html.erb`.
    - **Structure MUST be**:
        1.  `Ui::ComponentHeaderComponent`: Title, Description, When To Use.
        2.  `Ui::ExampleComponent`: Render the component + Show code (from helper).
        3.  `Ui::ApiTableComponent`: Document ALL arguments (props), types, and defaults.

    **Template**:
    ```erb
    <%= render Ui::ComponentHeaderComponent.new(
      title: "New Component",
      description: "Description...",
      when_to_use: ["Scenario A", "Scenario B"]
    ) %>

    <%= render Ui::ExampleComponent.new(
      title: "Basic Usage",
      language: :erb,
      code: new_basic_code # Defined in DocumentationHelper
    ) do %>
      <%= ant_new(...) %>
    <% end %>

    <h3 class="text-xl font-bold text-gray-800 mb-4 mt-12">API</h3>
    <%= render Ui::ApiTableComponent.new do |api| %>
      <% api.row "prop_name", "Description", "String", "default" %>
    <% end %>
    ```

3.  **Register Navigation**:
    - Add link to Sidebar: `app/views/layouts/components.html.erb`.
    - Whitelist in Controller: `app/controllers/components_controller.rb` (`valid_components` array).

4.  **Update Context**: Add a brief usage example to `llm_context.md` (Section 3).

### Step 4: Verification Checklist
Before considering a component "complete", verify:
- [ ] Component renders correctly in all states
- [ ] Helper method registered in `ant_helper.rb`
- [ ] **Unit tests written and passing** (`rails test test/components/ant/`)
- [ ] Documentation page created with examples
- [ ] API table documents all props/parameters
- [ ] Navigation link added to sidebar
- [ ] Component whitelisted in controller
- [ ] Usage example added to `llm_context.md`

**Do not consider a component "done" until ALL steps above are completed, especially the unit tests.**
