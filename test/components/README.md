# 组件测试文档

## 概述

所有 Ant 组件都已添加完整的单元测试，使用 ViewComponent 的测试框架。

## 测试文件位置

```
test/components/ant/
├── button_component_test.rb      # Button 组件测试
├── tag_component_test.rb         # Tag 组件测试
├── input_component_test.rb       # Input 组件测试
├── select_component_test.rb      # Select 组件测试
├── switch_component_test.rb      # Switch 组件测试
├── radio_component_test.rb       # Radio 组件测试
├── checkbox_component_test.rb    # Checkbox 组件测试
├── card_component_test.rb        # Card 组件测试
├── modal_component_test.rb       # Modal 组件测试
├── tabs_component_test.rb        # Tabs 组件测试
├── table_component_test.rb       # Table 组件测试
├── pagination_component_test.rb  # Pagination 组件测试
└── calendar_component_test.rb    # Calendar 组件测试
```

## 运行测试

### 运行所有组件测试

```bash
rails test test/components/
```

### 运行单个组件测试

```bash
rails test test/components/ant/button_component_test.rb
rails test test/components/ant/table_component_test.rb
# ... 等等
```

### 运行特定测试方法

```bash
rails test test/components/ant/button_component_test.rb -n test_renders_primary_button
```

### 查看详细输出

```bash
rails test test/components/ -v
```

## 测试覆盖率

每个组件的测试覆盖了以下方面：

### 基础功能测试
- ✅ 默认渲染
- ✅ 各种 props 组合
- ✅ HTML 结构验证

### 样式测试
- ✅ 不同尺寸 (small, default, large)
- ✅ 不同颜色/状态 (primary, danger, success, etc.)
- ✅ 禁用状态
- ✅ 自定义 CSS 类

### 交互测试
- ✅ 按钮点击
- ✅ 表单输入
- ✅ 选择器选项
- ✅ 复选框/单选框状态

### 插槽测试
- ✅ 内容插槽
- ✅ Header/Footer 插槽
- ✅ Icon 插槽
- ✅ 自定义渲染块

### 边缘情况
- ✅ 空数据处理
- ✅ 加载状态
- ✅ 错误状态
- ✅ 长文本/大数据量

## 测试示例

### Button 组件测试示例

```ruby
# 测试主要按钮
test "renders primary button" do
  render_inline(Ant::ButtonComponent.new("Primary", color: :primary))
  
  assert_selector "button.bg-\\[\\#1677ff\\]"
  assert_selector "button.text-white"
end

# 测试禁用状态
test "renders disabled button" do
  render_inline(Ant::ButtonComponent.new("Disabled", disabled: true))
  
  assert_selector "button[disabled]"
  assert_selector "button.opacity-50"
end
```

### Table 组件测试示例

```ruby
# 测试自动生成列
test "auto-generates columns from data" do
  render_inline(Ant::TableComponent.new(@users))
  
  assert_selector "th", text: "Id"
  assert_selector "th", text: "Name"
  assert_selector "th", text: "Email"
end

# 测试排序功能
test "renders sortable columns" do
  render_inline(Ant::TableComponent.new(@users)) do |component|
    component.column("Name", sortable: true) { |u| u.name }
  end
  
  assert_selector "span[data-sortable='true']"
  assert_selector "svg" # sort icon
end
```

## 测试统计

总共创建了 **13 个组件测试文件**，包含约 **100+ 个测试用例**。

### 各组件测试数量

| 组件 | 测试数量 | 覆盖特性 |
|------|---------|---------|
| Button | 10 | 颜色、尺寸、状态、插槽 |
| Tag | 7 | 颜色、可关闭、自定义 |
| Input | 9 | 类型、尺寸、状态、插槽 |
| Select | 7 | 选项、占位符、尺寸 |
| Switch | 7 | 尺寸、状态、文本、加载 |
| Radio | 5 | 尺寸、状态、选中 |
| Checkbox | 8 | 尺寸、状态、半选 |
| Card | 6 | 插槽、标题、自定义 |
| Modal | 6 | 结构、宽度、插槽 |
| Tabs | 4 | 标签、内容、激活 |
| Table | 14 | 列、排序、筛选、选择 |
| Pagination | 7 | 页码、导航、状态 |
| Calendar | 7 | 日期、导航、选择 |

## 持续集成

可以在 CI/CD 管道中添加测试步骤：

```yaml
# .github/workflows/test.yml
test:
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v2
    - name: Setup Ruby
      uses: ruby/setup-ruby@v1
      with:
        bundler-cache: true
    - name: Run component tests
      run: |
        rails test:prepare
        rails test test/components/
```

## 最佳实践

1. **每次修改组件后运行测试**
   ```bash
   rails test test/components/ant/button_component_test.rb
   ```

2. **添加新功能时添加对应测试**
   - 新增 prop → 添加测试用例
   - 新增插槽 → 添加插槽测试
   - 新增状态 → 添加状态测试

3. **使用描述性的测试名称**
   ```ruby
   test "renders primary button with large size"
   test "disables next button on last page"
   ```

4. **测试边缘情况**
   - 空数据
   - nil 值
   - 极大/极小数值
   - 特殊字符

## 调试测试

如果测试失败，可以：

1. **查看详细错误信息**
   ```bash
   rails test test/components/ant/button_component_test.rb -v
   ```

2. **使用 binding.pry 调试**
   ```ruby
   test "some test" do
     render_inline(Ant::ButtonComponent.new("Test"))
     binding.pry  # 在这里暂停
     assert_selector "button"
   end
   ```

3. **打印渲染的 HTML**
   ```ruby
   test "some test" do
     result = render_inline(Ant::ButtonComponent.new("Test"))
     puts result.to_html
     assert_selector "button"
   end
   ```

## 注意事项

- ViewComponent 测试需要 `view_component` gem
- 某些 Stimulus 交互测试可能需要 JavaScript 集成测试
- CSS 类名中的特殊字符需要转义（如 `\\[\\#1677ff\\]`）
- 测试数据库需要与开发环境分离

## 下一步

- [ ] 添加集成测试测试完整的用户流程
- [ ] 添加性能测试
- [ ] 添加可访问性测试
- [ ] 设置测试覆盖率报告
- [ ] 添加视觉回归测试
