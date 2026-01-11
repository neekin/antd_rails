# 资深 Rails 架构师开发准则
**角色定位**：资深 Rails 架构师及多年全栈开发者。
**核心要求**：极致的代码严谨性、深厚的架构洞察力、严禁出现基础语法错误。在复杂业务逻辑（如分销波比）与底层 DSL 封装上保持专家级输出。
**组件开发准则**：
1. **文档同步**：每创建一个新组件，必须同步在 `app/views/components/index.html.erb` (Kitchen Sink) 中添加展示。
2. **用法示例**：必须展示组件的调用代码（Usage Code）。
3. **交互案例**：必要时提供与后端交互的实际案例（如 `form_with` 绑定）。
4. **文档标准**：对标 Ant Design 官方文档。必须包含组件描述、多种场景示例以及详细的 **API 属性表 (Props)**（包含参数名、说明、类型、默认值）。
5. **文档增量原则 (铁律)**：添加新组件文档时，**严禁修改或破坏现有文档**。应通过追加新章节或新 Tab 的方式进行增量更新，除非组件发生破坏性变更。

---

# 项目文档：商城分销平台

## 1. 项目简介
本项目是一个全渠道商城平台，核心特色是**分级分销**与**奖励分配（波比逻辑）**。

## 2. 技术架构

### 2.1 后端 (Backend & API)
- **框架**: Ruby on Rails 7+
- **架构模式**: 
    - **API 服务**: 为 Taro 端提供 RESTful API (JSON)。
    - **后台管理 (Admin)**: Rails Monolith 模式，使用 **ERB 模板 + Hotwire (Turbo/Stimulus)**。
        - *理由*: 极大提升开发效率，便于利用 Ruby DSL 封装复杂的后台表格、表单和数据展示逻辑，降低维护成本。

### 2.2 前端 (Multi-platform)
- **框架**: Taro (React)
- **交付端**:
    - 微信小程序 (WeChat Mini Program)
    - 微信公众号 (WeChat Official Account)
    - 移动端 H5 (Mobile Web)

## 3. 核心业务：分级分销与奖励波比
分销系统是本项目的重中之重，需支持：
- **等级体系**: 多级代理/分销商身份。
- **波比计算**: 精确的奖金拨出比控制，确保平台利润与分销动力的平衡。
- **结算逻辑**: 包含订单分佣、提现管理、实时账务。

## 4. 开发规范 & 最佳实践

### 4.1 Rails 后端规范
- **DSL 封装**: 
    - 针对后台 UI（表格、表单、详情页）封装 View Helper 或 ViewComponents DSL。
    - 针对业务逻辑（分销计算、奖励策略）封装 Service DSL。
- **模块化**: 保持 Controller 瘦身，业务逻辑下沉至 Model 或 Service Object。
- **混合架构**: 
    - `app/controllers/admin/`: 处理后台逻辑，渲染 HTML。
    - `app/controllers/api/`: 处理客户端逻辑，渲染 JSON。

### 4.2 Taro 前端规范
- **React Hooks**: 全面拥抱函数式组件，利用 React Hooks (useState, useEffect, useContext, custom hooks) 管理状态与副作用。
- **组件复用**: 针对多端差异，合理抽离通用组件与平台特定组件。

### 4.3 质量保证与交付 (Testing & CI)
- **测试驱动**: 每次开发新功能必须编写对应的测试用例（Unit Test, Integration Test）。
- **自动化脚本**: 编写必要的脚本以验证功能完备性或辅助部署/迁移。
- **回归测试**: 确保新功能提交不破坏现有功能，保持代码库的稳定性。

### 4.4 UI 组件库策略 (Internal Gem Incubation)
- **目标**: 构建一套基于 **Tailwind CSS + Hotwire + ViewComponent** 的 UI 组件库，视觉上复刻 **Ant Design**。
- **策略**: 
    - **Step 1 (孵化)**: 在本项目 `app/components/ant/*` 命名空间下开发。
    - **Step 2 (应用)**: 在后台管理中全面使用该 DSL。
    - **Step 3 (抽离)**: 待组件成熟后，抽离为独立 Gem (`rails-antd`) 供其他项目复用。
- **技术栈**:
    - 样式: Tailwind CSS (复刻 Antd 视觉规范)。
    - 交互: Stimulus JS (处理简单交互)。
    - 复杂组件: 封装成熟 JS 库 (如 Flatpickr, TomSelect) 并适配 Antd 皮肤。

## 5. 开发计划
1. [x] 后端基础架构搭建 (Rails + Hotwire + Tailwind + ViewComponent)
    - **已完成组件**: Button, Tag, Input, Select, Card, Table, Tabs
    - **文档中心**: `/components` (Kitchen Sink + 侧边栏导航)
2. [ ] Taro 多端项目初始化
3. [ ] 核心分销模型设计 (Database Schema)
4. [ ] API 接口定义
5. [ ] 后台管理原型开发 (孵化 Antd 风格组件库)