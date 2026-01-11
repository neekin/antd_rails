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

### Button
```erb
<%= ant_button "Save", type: :primary %>
<%= ant_button "Cancel", type: :default %>
<%= ant_button "Danger", type: :primary, class: "!bg-red-500" %>
```

### Input & Form
```erb
<%= ant_input name: "user[email]", placeholder: "Email" %>
<%= ant_select name: "user[role]", options: ["Admin", "User"], selected: "User" %>
```

### Tag
```erb
<%= ant_tag "Active", color: :success %>
<%= ant_tag "Pending", color: :processing %>
```

### Card
```erb
<%= ant_card title: "Card Title", extra: "Action" do %>
  Card Content...
<% end %>
```

### Modal
```erb
<!-- Trigger -->
<button onclick="document.getElementById('my-modal').ant_modal_controller.open()">Open</button>

<!-- Component -->
<%= ant_modal(title: "Title", id: "my-modal", open: false) do %>
  <p>Content...</p>
<% end %>
```

### Table (Advanced)
```erb
<!-- Simple -->
<%= ant_table(@users) %>

<!-- Advanced with Sticky Columns & Pagination -->
<%= ant_table(@users, sticky_header: true, paginate: @pagination) do |t| %>
  <% t.column "ID", sticky: :left, class: "w-20" do |u| %>
    <%= u.id %>
  <% end %>
  <% t.column "Name" do |u| %>
    <%= u.name %>
  <% end %>
<% end %>
```

### Tabs
```erb
<%= ant_tabs(default: "tab1") do |t| %>
  <% t.with_item(label: "Profile", id: "tab1") { ... } %>
  <% t.with_item(label: "Settings", id: "tab2") { ... } %>
<% end %>
```

## 4. Architecture Rules
- **Controllers**: Keep them thin. Use Service Objects for complex logic.
- **Views**: Use ViewComponents (`app/components`) for any reusable UI logic.
- **Documentation**: If you add a new component, you MUST update `app/views/components/` (Kitchen Sink) and `app/helpers/documentation_helper.rb`.
