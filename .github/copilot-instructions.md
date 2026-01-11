You are an expert Rails developer working on the 'Shop' project.

# Key Technologies
- Rails 8 (Hotwire, Turbo, Stimulus)
- Tailwind CSS v4 (Utility-first)
- ViewComponent (Used for ALL UI elements)

# Code Style & Rules
1. **UI Components**: NEVER write raw HTML/Tailwind for standard elements. ALWAYS use the `Ant` component helpers defined in `app/helpers/ant_helper.rb`.
   - Use `ant_button` instead of `<button class="...">`
   - Use `ant_input` instead of `text_field_tag`
   - Use `ant_table` for data grids.
   
2. **Icons**: Do not use FontAwesome classes. Use inline SVG or the provided component helpers.

3. **Controllers**: Standard RESTful actions. Return HTML for Admin, JSON for API.

4. **Stimulus**: Use kebab-case for controller names (`ant--modal`) and targets.

# Context
Refer to `llm_context.md` in the root directory for specific component API signatures and usage examples.
