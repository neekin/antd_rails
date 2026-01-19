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
<!-- Basic Buttons (基本按钮) -->
<%= ant_button "Primary", type: :primary %>
<%= ant_button "Default" %>
<%= ant_button "Dashed", type: :dashed %>
<%= ant_button "Text", type: :text %>
<%= ant_button "Link", type: :link %>

<!-- Sizes (尺寸) -->
<%= ant_button "Large", type: :primary, size: :large %>
<%= ant_button "Middle", type: :primary, size: :middle %>
<%= ant_button "Small", type: :primary, size: :small %>

<!-- Danger Buttons (危险按钮) -->
<%= ant_button "Delete", type: :primary, danger: true %>
<%= ant_button "Delete", type: :default, danger: true %>

<!-- Ghost Buttons (幽灵按钮 - 透明背景) -->
<%= ant_button "Ghost Primary", type: :primary, ghost: true %>
<%= ant_button "Ghost Default", ghost: true %>

<!-- States (状态) -->
<%= ant_button "Disabled", type: :primary, disabled: true %>
<%= ant_button "Loading", type: :primary, loading: true %>
<%= ant_button "Block Button", type: :primary, block: true %>

<!-- Icon Button (图标按钮) -->
<%= ant_button type: :primary do %>
  <span class="mr-2">🔍</span>Search
<% end %>

<!-- Debounce (防抖 - 防止快速重复点击) -->
<%= ant_button "Search", 
               type: :primary, 
               debounce: 300, 
               onclick: "performSearch()" %>

<!-- Throttle (节流 - 限制执行频率) -->
<%= ant_button "Save", 
               type: :primary, 
               throttle: 1000, 
               onclick: "saveForm()" %>

<!-- Async Operation with Loading (异步操作) -->
<%= ant_button "Submit", 
               type: :primary, 
               id: "submit-btn", 
               onclick: "handleAsyncSubmit(this)" %>

<script>
async function handleAsyncSubmit(btn) {
  // 获取 Stimulus 控制器
  const controller = btn.closest('[data-controller="ant--button"]');
  const stimulusController = application.getControllerForElementAndIdentifier(
    controller, 'ant--button'
  );
  
  if (stimulusController) {
    stimulusController.setLoading(true); // 显示加载动画
    
    try {
      await submitFormData(); // 执行异步操作
      console.log('Success');
    } finally {
      stimulusController.setLoading(false); // 取消加载
    }
  }
}
</script>
```

**Button 组件参数说明：**
- `label`: 按钮文本（不使用 block 时）
- `type`: 按钮类型（`:primary`、`:default`、`:dashed`、`:text`、`:link`），默认 `:default`
- `size`: 按钮尺寸（`:small`、`:middle`、`:large`），默认 `:middle`
- `danger`: 危险按钮（红色），默认 `false`
- `ghost`: 幽灵按钮（透明背景），默认 `false`
- `disabled`: 禁用状态，默认 `false`
- `loading`: 加载状态（显示旋转图标），默认 `false`
- `block`: 块级按钮（宽度 100%），默认 `false`
- `debounce`: 防抖延迟（毫秒），默认 `0`（不启用）
- `throttle`: 节流延迟（毫秒），默认 `0`（不启用）
- `onclick`: 点击事件处理器（JavaScript 字符串）
- `class`: 自定义 CSS 类
- `**html_options`: 其他 HTML 属性

**Button 组件特性：**
- **防抖（Debounce）**：用户停止点击后延迟执行，适合搜索框、输入验证等场景
- **节流（Throttle）**：限制执行频率，适合表单提交、保存按钮等场景，防止重复提交
- **加载状态**：自动显示旋转图标，禁用按钮交互
- **多种类型和尺寸**：支持 5 种按钮类型和 3 种尺寸
- **危险操作**：红色危险按钮用于删除等操作
- **幽灵按钮**：透明背景，适合深色背景

**使用建议：**
- 表单提交按钮推荐使用 `throttle: 1000`（1秒内最多提交一次）
- 搜索按钮推荐使用 `debounce: 300`（停止输入300ms后执行）
- 异步操作使用 `setLoading()` 方法显示加载状态
- 主要操作使用 `type: :primary`，一个区域通常只有一个主按钮

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

### Modal
```erb
<!-- Basic Modal (基本对话框) -->
<button onclick="document.getElementById('my-modal').ant_modal_controller.open()">
  Open Modal
</button>

<%= ant_modal(title: "Basic Modal", id: "my-modal") do %>
  <p>Some contents...</p>
<% end %>

<!-- Custom Footer (自定义页脚) -->
<%= ant_modal(title: "Custom Footer", id: "custom-modal") do |modal| %>
  <% modal.with_footer do %>
    <%= ant_button "Return", type: :default, onclick: "..." %>
    <%= ant_button "Submit", type: :primary, onclick: "..." %>
  <% end %>
  <p>Modal content...</p>
<% end %>

<!-- Async Operation (异步操作) -->
<script>
function openAsyncModal() {
  const modal = document.getElementById('async-modal').ant_modal_controller;
  modal.open();
  
  // 监听确定按钮点击
  document.getElementById('async-modal').addEventListener('ant--modal:ok', async (event) => {
    event.preventDefault(); // 阻止默认关闭
    
    modal.setConfirmLoading(true); // 显示加载状态
    
    // 执行异步操作
    await fetchData();
    
    modal.setConfirmLoading(false); // 取消加载状态
    modal.close(); // 手动关闭
  }, { once: true });
}
</script>

<!-- Different Sizes (不同尺寸) -->
<%= ant_modal(title: "Small", id: "small-modal", size: :small) do %>
  <p>400px width</p>
<% end %>

<%= ant_modal(title: "Middle", id: "middle-modal", size: :middle) do %>
  <p>520px width (default)</p>
<% end %>

<%= ant_modal(title: "Large", id: "large-modal", size: :large) do %>
  <p>800px width</p>
<% end %>

<!-- Centered Modal (垂直居中) -->
<%= ant_modal(title: "Centered", id: "centered-modal", centered: true) do %>
  <p>Vertically centered modal</p>
<% end %>

<!-- No Close Button (禁用关闭) -->
<%= ant_modal(
  title: "No Close",
  id: "no-close-modal",
  closable: false,
  mask_closable: false
) do %>
  <p>Must click OK or Cancel to close</p>
<% end %>

<!-- Custom Button Text (自定义按钮文本) -->
<%= ant_modal(
  title: "Custom Text",
  id: "custom-text-modal",
  ok_text: "确定",
  cancel_text: "取消"
) do %>
  <p>Chinese button text</p>
<% end %>

<!-- Confirm Dialog (确认对话框) -->
<script>
function showConfirm() {
  const modalHtml = `
    <%= ant_modal(
      title: "Are you sure?",
      id: "confirm-modal",
      open: true,
      ok_text: "Delete",
      destroy_on_close: true
    ) do %>
      <p class="text-red-600">This action cannot be undone.</p>
    <% end %>
  `;
  
  document.body.insertAdjacentHTML('beforeend', modalHtml);
  
  const modal = document.getElementById('confirm-modal');
  modal.addEventListener('ant--modal:ok', () => {
    console.log('Confirmed!');
    modal.ant_modal_controller.close();
  });
}
</script>
```

**Modal 组件参数说明：**
- `title`: 标题
- `id`: 对话框唯一标识（用于 JS 调用），默认自动生成
- `open`: 对话框是否可见，默认 `false`
- `width`: 自定义宽度（如 "600px"）
- `size`: 预设尺寸（`:small` 400px、`:middle` 520px、`:large` 800px），默认 `:middle`
- `closable`: 是否显示右上角关闭按钮，默认 `true`
- `mask_closable`: 点击蒙层是否允许关闭，默认 `true`
- `centered`: 垂直居中展示，默认 `false`
- `ok_text`: 确认按钮文字，默认 "OK"
- `cancel_text`: 取消按钮文字，默认 "Cancel"
- `confirm_loading`: 确定按钮 loading 状态，默认 `false`
- `destroy_on_close`: 关闭时销毁 Modal 里的子元素，默认 `false`

**Modal 组件特性：**
- 支持自定义页脚（通过 `with_footer` slot）
- 点击蒙层或 ESC 键关闭
- 异步操作支持（通过事件回调）
- 三种预设尺寸或自定义宽度
- 打开时禁止页面滚动

**JavaScript API：**
```javascript
// 获取 Modal 控制器
const modal = document.getElementById('modal-id').ant_modal_controller;

// 方法
modal.open();                    // 打开对话框
modal.close();                   // 关闭对话框
modal.setConfirmLoading(true);   // 设置加载状态

// 事件监听
document.getElementById('modal-id').addEventListener('ant--modal:open', (e) => {
  // 对话框打开时触发
});

document.getElementById('modal-id').addEventListener('ant--modal:ok', (e) => {
  // 点击确定按钮时触发（可以 preventDefault 阻止关闭）
  e.preventDefault(); // 阻止默认关闭行为
});

document.getElementById('modal-id').addEventListener('ant--modal:cancel', (e) => {
  // 点击取消按钮时触发（可以 preventDefault 阻止关闭）
});

document.getElementById('modal-id').addEventListener('ant--modal:close', (e) => {
  // 对话框关闭后触发
});
```

### Table
```erb
<%= ant_table(@users) %>
```

### Pagination
```erb
<!-- 基本分页 -->
<%= ant_pagination current_page: 1, 
                   total_count: 100, 
                   per_page: 10 %>

<!-- 可切换每页条数 -->
<%= ant_pagination current_page: @current_page,
                   total_count: @total_count,
                   per_page: @per_page,
                   show_size_changer: true %>

<!-- 快速跳转 -->
<%= ant_pagination current_page: 3,
                   total_count: 500,
                   per_page: 10,
                   show_quick_jumper: true %>

<!-- 简洁模式 -->
<%= ant_pagination current_page: 2,
                   total_count: 50,
                   per_page: 10,
                   simple: true %>

<!-- 小尺寸 -->
<%= ant_pagination current_page: 2,
                   total_count: 100,
                   per_page: 10,
                   size: :small %>

<!-- 完整配置 -->
<%= ant_pagination current_page: @current_page,
                   total_count: @total_count,
                   per_page: @per_page,
                   show_size_changer: true,
                   show_quick_jumper: true,
                   show_total: true,
                   page_size_options: [10, 20, 50, 100] %>

<!-- 配合 Controller 使用 -->
# Controller
def index
  @posts = Post.page(params[:page]).per(params[:per_page] || 10)
  @total_count = Post.count
  @current_page = params[:page] || 1
  @per_page = params[:per_page] || 10
end

# View
<%= ant_pagination current_page: @current_page,
                   total_count: @total_count,
                   per_page: @per_page %>
```

**Pagination 组件参数：**
- `current_page`: 当前页数（默认：1）
- `total_count`: 数据总数（默认：0）
- `per_page`: 每页条数（默认：10）
- `param_name`: 页码的 URL 参数名（默认：`:page`）
- `per_page_param_name`: 每页条数的 URL 参数名（默认：`:per_page`）
- `show_size_changer`: 是否显示 pageSize 切换器（默认：`true`）
- `show_quick_jumper`: 是否可以快速跳转至某页（默认：`false`）
- `show_total`: 是否显示总数（默认：`true`）
- `simple`: 简洁模式（默认：`false`）
- `size`: 尺寸大小（`:default` | `:small`，默认：`:default`）
- `page_size_options`: 指定每页可以显示多少条（默认：`[10, 20, 50, 100]`）

**特性：**
- 页码过多时自动显示省略号
- 支持自定义每页条数选项
- 支持快速跳转到指定页
- 简洁模式适用于移动端
- 自动生成正确的 URL 参数

## 3.5 Ant Scaffold Generator (CRUD 脚手架)

项目包含一个自定义的 scaffold 生成器，可以快速生成使用 Ant 组件的 CRUD 代码。

### 基本用法

```bash
# 生成完整的 CRUD 脚手架
rails generate ant:scaffold Post title:string content:text published:boolean

# 带外键关联
rails generate ant:scaffold Comment post:references author:string content:text

# 跳过路由或迁移
rails generate ant:scaffold Product name:string --skip-routes
rails generate ant:scaffold Product name:string --skip-migration
```

### 支持的字段类型

- `string` - 字符串（文本输入框）
- `text` - 长文本（文本域）
- `integer` / `decimal` / `float` - 数字（数字输入框）
- `boolean` - 布尔值（复选框）
- `date` - 日期（日期选择器）
- `datetime` - 日期时间
- `references` - 外键关联（下拉选择框）

### 生成的文件

```
app/
├── models/
│   └── post.rb                    # Model
├── controllers/
│   └── posts_controller.rb        # Controller (标准 CRUD)
└── views/
    └── posts/
        ├── index.html.erb         # 列表页面（表格展示）
        ├── show.html.erb          # 详情页面（卡片布局）
        ├── new.html.erb           # 新建页面
        ├── edit.html.erb          # 编辑页面
        └── _form.html.erb         # 表单部分视图

db/
└── migrate/
    └── xxx_create_posts.rb        # Migration

config/
└── routes.rb                      # 添加 resources :posts
```

### 生成的代码特性

#### Index 页面
- 使用 Tailwind CSS 表格样式
- 每行快速操作按钮（Show, Edit, Delete）
- 空状态使用 `ant_empty` 组件
- 新建按钮使用 `ant_button` 组件

#### Show 页面
- 卡片式布局
- 字段网格展示
- 编辑和删除按钮
- 返回列表按钮

#### New/Edit 页面
- 使用 `ant_form_for` 构建表单
- 自动字段类型识别：
  - `text` → `f.text_area`
  - `boolean` → `f.checkbox`
  - `date` → `f.date_picker`
  - `integer/decimal` → `f.input type: :number`
  - `references` → `f.collection_select`
- 表单验证错误显示
- 提交按钮自动添加 `throttle: 1000`（防重复提交）
- 取消按钮返回列表

#### Controller
- 标准 RESTful CRUD 操作
- Strong Parameters
- Flash 消息提示

### 使用示例

#### 博客系统
```bash
# 生成文章
rails generate ant:scaffold Post title:string content:text published:boolean published_at:date

# 生成评论（关联到文章）
rails generate ant:scaffold Comment post:references author:string content:text

# 运行迁移
rails db:migrate

# 访问 http://localhost:3000/posts
```

#### 电商系统
```bash
# 生成分类
rails generate ant:scaffold Category name:string description:text

# 生成产品（关联到分类）
rails generate ant:scaffold Product category:references name:string price:decimal stock:integer description:text

# 生成订单
rails generate ant:scaffold Order user:references total:decimal status:string

rails db:migrate
```

### 自定义模板

模板文件位于 `lib/generators/ant/scaffold/templates/`，可以根据需要修改：

- `views/index.html.erb.tt` - 列表页面模板
- `views/show.html.erb.tt` - 详情页面模板
- `views/_form.html.erb.tt` - 表单模板
- `controller.rb.tt` - 控制器模板
- `model.rb.tt` - 模型模板

修改后重新运行生成器即可应用更改。

### 与默认 scaffold 对比

| 特性 | Ant Scaffold | Rails 默认 Scaffold |
|------|-------------|-------------------|
| UI 框架 | Ant 组件 + Tailwind CSS | 基础 HTML |
| 防重复提交 | ✅ 自动添加 throttle | ❌ 需手动实现 |
| 空状态提示 | ✅ ant_empty 组件 | ❌ 无 |
| 表单构建器 | ✅ ant_form_for | Rails form_with |
| 响应式布局 | ✅ Tailwind 响应式 | ❌ 基础样式 |
| 组件一致性 | ✅ 统一组件库 | ❌ 原生 HTML |
| 日期选择 | ✅ ant_date_picker | ❌ date_field |

详细文档参考：`lib/generators/ant/scaffold/USAGE`

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
