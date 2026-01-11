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
<%= ant_select name: "user[role]", options: ["Admin", "User"] %>
```

### Table
```erb
<%= ant_table(@users) %>
```

## 4. Architecture Rules & Workflow (DEFINITION OF DONE)

**CRITICAL**: When creating a NEW component (e.g., `Ant::NewComponent`), you MUST complete ALL following steps in order.

### Step 1: Implementation
1.  **Create Component**: `app/components/ant/new_component.rb` & `.html.erb`.
2.  **Register Helper**: Add helper method (e.g., `ant_new`) to `app/helpers/ant_helper.rb`.

### Step 2: Documentation (The "Kitchen Sink")
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

**Do not consider a component "done" until it is documented and visible in the `/components` dashboard.**
