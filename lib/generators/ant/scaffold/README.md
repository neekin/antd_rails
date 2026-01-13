# Ant Scaffold Generator - 快速开始

## 安装完成 ✅

自定义 scaffold 生成器已经创建完成，位于 `lib/generators/ant/scaffold/`。

## 立即使用

### 1. 生成一个简单的博客文章模型

```bash
rails generate ant:scaffold Post title:string content:text published:boolean
rails db:migrate
rails server
```

访问 `http://localhost:3000/posts` 查看效果！

### 2. 生成一个产品管理系统

```bash
rails generate ant:scaffold Product name:string price:decimal stock:integer description:text
rails db:migrate
```

### 3. 带关联的模型

```bash
# 先创建分类
rails generate ant:scaffold Category name:string

# 再创建产品（关联到分类）
rails generate ant:scaffold Product category:references name:string price:decimal

rails db:migrate
```

## 生成的代码特性

### ✨ 自动集成的功能

1. **Ant 组件**
   - `ant_button` - 所有按钮
   - `ant_form_for` - 表单构建器
   - `ant_empty` - 空状态提示

2. **防抖节流**
   - 提交按钮自动添加 `throttle: 1000`（1秒内只能提交一次）
   - 防止重复提交

3. **美观样式**
   - Tailwind CSS 响应式布局
   - 卡片式设计
   - 悬停效果
   - 统一的间距和颜色

4. **完整 CRUD**
   - Index: 列表展示 + 搜索占位
   - Show: 详情展示
   - New/Edit: 表单编辑
   - Delete: 删除确认

5. **智能表单字段**
   - `string` → 文本输入框
   - `text` → 文本域
   - `boolean` → 复选框
   - `date` → 日期选择器
   - `integer/decimal` → 数字输入框
   - `references` → 下拉选择框

## 目录结构

```
lib/generators/ant/scaffold/
├── scaffold_generator.rb          # 生成器主文件
├── USAGE                          # 详细使用文档
├── README.md                      # 快速开始指南
└── templates/
    ├── model.rb.tt               # Model 模板
    ├── controller.rb.tt          # Controller 模板
    ├── migration.rb.tt           # Migration 模板
    └── views/
        ├── index.html.erb.tt     # 列表页面
        ├── show.html.erb.tt      # 详情页面
        ├── new.html.erb.tt       # 新建页面
        ├── edit.html.erb.tt      # 编辑页面
        └── _form.html.erb.tt     # 表单部分视图
```

## 示例对比

### 使用 Ant Scaffold 生成的按钮
```erb
<%= ant_button "New Post", type: :primary do %>
  <span class="mr-2">+</span>New Post
<% end %>
```

### 使用 Ant Form Builder
```erb
<%= ant_form_for @post do |f| %>
  <%= f.input :title, placeholder: "Enter title" %>
  <%= f.text_area :content, rows: 4 %>
  <%= f.checkbox :published, label: "Published" %>
  <%= f.submit "Create Post", type: :primary, throttle: 1000 %>
<% end %>
```

## 常见使用场景

### 博客系统
```bash
rails g ant:scaffold Post title:string content:text published:boolean published_at:date
rails g ant:scaffold Comment post:references author:string content:text
```

### 电商系统
```bash
rails g ant:scaffold Category name:string description:text
rails g ant:scaffold Product category:references name:string price:decimal stock:integer
rails g ant:scaffold Order user:references total:decimal status:string
```

### 用户管理
```bash
rails g ant:scaffold User name:string email:string role:string active:boolean
rails g ant:scaffold Profile user:references bio:text avatar:string
```

## 下一步

1. 生成你的第一个 scaffold
2. 查看生成的代码
3. 根据需要自定义视图
4. 参考 `USAGE` 文件了解更多选项

## 需要帮助？

- 详细文档: `lib/generators/ant/scaffold/USAGE`
- 组件文档: `llm_context.md`
- 组件演示: `http://localhost:3000/components`

享受快速开发！🚀
