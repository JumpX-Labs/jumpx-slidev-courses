# Slidev 课程平台 PRD 初稿

## 概述

本项目旨在建设一个基于 Slidev 的课程课件平台，用于承载大规模课程内容的生产、管理、发布与访问。平台采用单仓库、多 deck 的内容组织方式，面向语义优先的课程 URL 体系，支持课程目录页、课时级 Slidev deck 页面、跨课程组件复用，以及基于 AI 的课件生成与维护流程。[cite:88][cite:95][cite:90]

当前已明确的业务前提包括：一门课程对应一个固定版本的 slide；不区分老师模式和复习模式；需要课程目录页；一套组件会在多个课程之间复用；整体采用单仓库、多 deck 的工程组织方式。[cite:95][cite:90]

该平台的典型课程结构为：一门课程包含若干节课，每节课对应一个 Slidev deck，每个 deck 包含约 20 页 slide。未来课程规模可达到约 100 门，因此 URL 体系、目录结构、组件复用和 AI 生成约束必须从一开始就具备可扩展性。[cite:90][cite:105]

## 产品目标

平台的核心目标是建立一套稳定、语义清晰、便于学生理解的课程访问体系，同时保证研发团队可以在单仓库下批量维护大量 Slidev deck，并通过共享组件、共享布局和统一规范降低生产成本。[cite:105][cite:110][cite:95]

除内容发布外，平台还需要兼容 AI 参与课件生产的工作流。由于 Slidev 采用扩展型 Markdown 语法，并支持 frontmatter、Vue components、内联 HTML/CSS 等能力，若缺少语法约束与 skill 约束，AI 生成内容容易出现解析失败、样式错乱或不可维护的问题。[cite:118][cite:120][cite:123]

## 信息架构

平台采用“两层内容语义 + 一层 lesson”的 URL 方案，正式路径结构定义如下：[cite:105][cite:110]

- `/courses`：课程总目录页
- `/courses/{course-slug}`：单门课程目录页
- `/courses/{course-slug}/{lesson-slug}`：具体课时的 Slidev deck 页面

该结构的设计依据是信息架构中的内容层级一致性原则，即导航层级、URL 层级与用户心智模型保持一致。对于学生而言，最自然的认知路径是“课程 → 第几节课”，而不是“仓库 → deck → 文件”。[cite:105][cite:117]

### URL 规范

课程 slug 使用课程语义命名，例如：

- `ai-general-literacy`
- `ai-productivity-for-office`
- `llm-tools-for-managers`

课时 slug 采用统一规则：

`lesson-{nn}-{topic}`

例如：

- `lesson-01-intro-to-ai`
- `lesson-02-prompt-engineering`
- `lesson-03-context-engineering`

该规则兼顾排序稳定性、语义可读性和后续搜索/分享友好性，同时避免仅使用 `lesson-01` 造成 URL 信息密度过低的问题。[cite:110][cite:117]

### URL 约束

- `course-slug` 发布后应保持稳定，除非发生重大战略调整。
- `lesson-slug` 在同一课程内必须唯一。
- `lesson-slug` 必须带排序号，以保证 URL 顺序与课程展示顺序一致。
- URL 中不应出现 `slidev`、`deck`、`presentation` 等技术实现词汇，以避免暴露底层实现并降低用户理解成本。[cite:105]

## 页面层级与功能范围

### 课程总目录页 `/courses`

课程总目录页用于展示全部课程的列表和分类入口，是学生访问平台的统一起点。该页面至少应支持课程卡片展示、课程标题、课程简介、封面图、课程 lesson 数量和跳转入口等基础能力。[cite:103][cite:105]

### 单课程目录页 `/courses/{course-slug}`

课程目录页用于承载某门课程的完整学习入口，至少应包含：课程标题、课程简介、课程封面、lesson 列表、lesson 顺序、lesson 标题、lesson 简介、预计时长、是否包含 demo 标记等信息。[cite:103][cite:106]

该页面是平台的信息枢纽，学生进入后可以理解当前课程结构，并继续跳转至某一节具体课件。[cite:105]

### 课时 Deck 页 `/courses/{course-slug}/{lesson-slug}`

该页面直接承载单个 Slidev deck，是实际课件展示页。Slidev 支持静态构建和子路径部署，因此可以将每个 deck 构建到对应 URL 子路径下。
为了打破 Slidev 全屏演示带来的“迷失感”（即学生进入课件后找不到返回上一级的入口），平台**必须**利用 Slidev 的 `global-top.vue` 或 `global-bottom.vue` 机制。在所有 Deck 之上注入一个悬浮的“平台全局导航层”，包含返回课程目录的面包屑或按钮，确保学习体验闭环。

## 仓库结构建议

平台采用单仓库、多 deck 结构。Slidev 官方文档中明确存在 `components/`、`layouts/`、`styles/` 等共享目录机制，这非常适合跨课程复用组件和统一主题风格。[cite:95]

建议仓库结构如下：

```text
repo/
├─ global-top.vue             # 全局导航栏 UI 注入（提供返回主站等跨页面控制）
├─ components/                # 全局共享 Slidev/Vue 组件
├─ layouts/                   # 全局共享布局
├─ styles/                    # 全局样式与主题覆写
├─ themes/                    # 自定义主题（如需要）
├─ shared-slides/             # 跨课程复用的 Markdown 片段（如通用的介绍页）
├─ courses/
│  ├─ ai-general-literacy/
│  │  ├─ meta.json            # 课程元数据
│  │  ├─ lesson-01-intro-to-ai/
│  │  │  └─ slides.md
│  │  ├─ lesson-02-prompt-engineering/
│  │  │  └─ slides.md
│  │  └─ lesson-03-context-engineering/
│  │     └─ slides.md
│  └─ ...
├─ catalog/                   # 课程总目录数据（可选）
├─ scripts/                   # 构建、校验、导出脚本
└─ package.json
```

该结构便于实现多 deck 构建、共享资源维护、课程元数据读取和目录页生成，也与单仓库多 presentation 的社区实践方向一致。[cite:90][cite:95]

## 构建与部署

Slidev 官方文档说明其支持静态构建与静态托管，并可以通过 `--base` 指定子路径进行部署。[cite:88][cite:109] 这使得平台可以将不同课程/课时的 deck 分别发布到对应的 URL 路径下，而不需要为每个 deck 单独使用独立仓库或独立域名。[cite:88]

建议构建策略如下：

- 课程目录页与总站目录页由统一站点壳层（如 Vue/Nuxt/Vite）负责生成。
- **多入口一次性构建（Multiple Entries Build）**：绝对禁止使用脚本循环执行 `slidev build`。必须通过 Slidev CLI 原生的多入口支持（如 `npx slidev build courses/*/*/slides.md`）一次性完成全站构建。这保证了底层 Vite 实例仅启动一次，所有 Deck 共享同一套组件、资源和依赖缓存，彻底解决 OOM 和构建时间灾难。
- 构建产物会共用同一个 `dist/assets`，在平台层面上跳转不同 Markdown 甚至可实现路由软切换，体验平滑。
- **静态资源规范**：为避免随着课程增多导致单仓极度膨胀，**严禁在仓库内直接存储视频和大体积图片**。所有课程多媒体资源必须统一托管于云端 CDN（基于既有规范，即使用 `r2.jumpxai.com`），课件中仅保留绝对路径链接。

## 共享组件策略

由于一套组件需要在多个课程之间复用，因此组件必须平台化而非课程私有化。Slidev 支持在 slides 中直接使用 Vue components，也支持共享组件目录，这为跨 deck 复用提供了天然基础。[cite:116][cite:95]

组件策略建议如下：

- 公共教学组件统一放在 `components/` 下维护。
- 组件按教学语义划分，而不是按课程划分，例如：`PromptCompare.vue`、`ContextWindowDemo.vue`、`AIResponsePanel.vue`。
- 课程层面如需个性化组件，应优先通过 props 参数扩展，而不是复制组件。
- 新组件进入共享库前需要经过语法、安全性、可维护性和视觉一致性评审。
- **Markdown 片段级复用**：如果多个课程需要完全一样的幻灯片（如“讲师介绍”或“什么是AI”），不应让 AI 重复生成或组件化，而是放在 `shared-slides/` 目录下，直接通过 Slidev 的 `<src="../shared-slides/what-is-ai.md" />` 语法进行跨 Deck 文件级引入。

## Slidev 语法规则调研结论

Slidev 并非使用普通 Markdown，而是使用扩展型的 Slidev Markdown。官方语法文档说明：deck 入口通常是 `slides.md`；slide 之间通过 `---` 分隔；文档开头支持 deck 级 YAML headmatter；单页也支持 block frontmatter；同时还支持内联 HTML、Vue components、LaTeX、Mermaid、PlantUML 和 scoped CSS 等扩展能力。[cite:118][cite:119][cite:120]

这意味着 Slidev 的表达能力很强，但也导致语法更容易被 AI 破坏。常见高风险点包括：

- slide separator `---` 使用错误；[cite:119]
- YAML frontmatter 非法；[cite:118][cite:120]
- Markdown、HTML、Vue 组件混写时标签不闭合；[cite:119][cite:135]
- 某些 component / MDC / addon 语法升级后失效；社区 issue 已出现相关案例。[cite:123][cite:125]

因此，Slidev 项目必须把“语法合法性”视为生产级要求，而不能只依赖人工目测或临时 prompt 约束。[cite:118][cite:123]

## skills 的易用性调研结论

Slidev 官方已经明确提供 “Work with AI” 文档与 agent skill，覆盖 Markdown syntax、slide separator、frontmatter、动画、代码块、图表、布局、内置组件、导出与 hosting 等内容。[cite:140]

这说明 Slidev 对 AI 生成内容的支持已经进入官方视野，skills 的易用性相比早期明显提高。对于大规模课程生产，skills 的主要价值不在于一次性写完几页 slide，而在于：

- 保证输出尽量符合合法 Slidev 语法；[cite:140]
- 复用统一组件与布局；[cite:116][cite:124]
- 降低不同 deck 之间的风格漂移；[cite:95]
- 为研发与内容团队建立一致的生成约束。[cite:140]

因此，从工程与内容生产视角看，skills 是易用且必要的，但前提是要把它制度化，而不是零散地作为 prompt 附件使用。[cite:140]

## skills 的质量调研结论

### 官方 skills / docs / themes

官方文档、官方 AI 支持、官方 themes 和内置组件的质量总体较高，因为它们直接覆盖了 Slidev 的核心能力范围，并且与当前主版本保持一致性更强。[cite:140][cite:137][cite:116]

### 社区 themes / addons / 第三方 skills

社区生态灵活，但质量并不均匀。Slidev 官方允许通过 theme 和 addon 扩展样式、组件、布局甚至工具行为，同时 addon 的开发门槛较低。[cite:122][cite:124] 这意味着生态丰富，但也意味着维护状态、兼容性和文档质量可能差异很大。[cite:124][cite:127]

因此，平台在生产体系中应采用以下质量策略：

- 官方 skill / 官方 docs / 官方 theme / 官方 addon 作为默认基线；[cite:137][cite:140]
- 第三方 skill、theme、addon 进入体系前必须经过审核；[cite:124][cite:127]
- 审核至少包括：维护活跃度、最近更新时间、文档完整度、示例可运行性、与当前 Slidev 版本兼容性；[cite:124][cite:132]
- 所有第三方能力都必须通过本地 build / export / render 验证后才能纳入正式课件生产链路。[cite:88][cite:124]

## AI 生成与 Slidev 语法护栏

考虑到未来课程规模大、内容生产高度依赖 AI，本项目必须在 PRD 中明确“Slidev + AI 生成约束清单”。该清单建议至少包含以下要求：

### 语法护栏

- 所有 deck 必须符合官方 Slidev Markdown 语法规范。[cite:118]
- `slides.md` 必须通过自动 frontmatter 解析校验。[cite:120]
- slide separator 数量与结构必须通过自动检查。[cite:119]
- 不允许自由生成高风险语法模式，除非命中白名单模板。

### 组件护栏

- 组件调用仅允许来自共享白名单组件库。[cite:116]
- 新组件必须附带示例、参数文档和最低限度截图验证。
- 复杂交互组件必须保证在多个课程场景下可复用。

### 生态护栏

- 默认优先官方 theme/addon/skill。
- 第三方生态引入需通过维护性和兼容性评审。
- **资源托管限制**：AI 生成的插图或视频必须提供指向 JumpX Assets CDN (`r2.jumpxai.com`) 的绝对路径链接，严禁向工作区根目录的 `public/` 文件夹写入任何多媒体文件，以维持单仓轻量化。

### 工程护栏

- AI 输出后必须触发自动 build 校验；[cite:88]
- 构建成功后应进行关键页面截图校验；
- 失败案例应有最小可读报错，便于内容团队和研发协同修复。

## 非目标

以下内容不属于当前阶段的目标范围：

- 多版本课程并存；
- 老师模式与复习模式区分；
- 多仓库拆分管理；
- 任意第三方 Slidev theme/addon 无门槛接入；
- 让 AI 在没有护栏的前提下直接自由生成生产级 deck。

## 推荐结论

当前方案的推荐结论如下：

1. URL 体系采用 `/courses/{course-slug}/{lesson-slug}`，并通过 `global-top.vue` 注入全局平台级导航兜底。
2. 工程组织采用单仓库、多 deck，并利用 Slidev CLI 的 **Multiple Entries** 机制实现全站单次极速构建，彻底规避 OOM。
3. 建立严格的内容与资源分离规范：代码与组件存仓，多媒体资产统一存放在 JumpX Assets CDN。
4. Slidev 语法规则必须作为正式生产约束进入 PRD，而不是依赖个人经验维护。
5. skills 可以作为大规模课件生产的重要能力，但必须以官方能力为基线，并配套质量审核与自动化校验流程。
6. PRD 中必须单列 “Slidev + AI 生成约束” 章节，作为后续研发落地的重要实现规范。

## 研发交付建议

后续若将该项目作为 mission 交付研发，建议优先拆解并验证以下核心工作包：

- URL 规范与课程元数据模型设计
- **单仓多入口架构验证**：跑通 `slidev build courses/*/*/slides.md` 极速构建。
- **全局 UI 壳层开发**：实现并注入 `global-top.vue` 跨页导航栏与主站返回逻辑。
- 课程总目录页与课程目录页生成
- 共享组件库（`components/`）与共享片段（`shared-slides/`）体系确立
- JumpX CDN 资源链接生成自动化规范
- Slidev syntax guardrails 与 AI 生成自动校验机制
