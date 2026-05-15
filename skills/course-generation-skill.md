# Skill: 生成与维护 Slidev 课程课件 (JumpX 规范)

## 技能描述
此技能用于指导 AI 助手如何根据用户的文本、图片或大纲内容，将其转化为符合 JumpX AI 训练营平台规范的 Slidev Markdown 源码，并严格遵循工程架构与防崩溃约束。

## 适用场景
- 将现有的教学大纲转化为一节课件 (`slides.md`)。
- 用户提供全图流（如 20 张海报），需要快速组装成翻页课件。
- 在现有的 `slides.md` 中安全地插入或更新一页，而不破坏前后文 AST 结构。

## 严格执行规范 (Guardrails)

### 1. 语法与分隔符规范
- **页首 Frontmatter**：每节课（Deck）开头**必须**包含 YAML Frontmatter 描述，指定主题和转场：
  ```yaml
  ---
  theme: default
  class: text-center
  highlighter: shiki
  lineNumbers: false
  transition: slide-left
  title: 【此处填写课程名称】
  ---
  ```
- **分页符**：严格使用 `---` 作为换页符。`---` 前后必须各保留一个空行。
- **页面属性注入**：如果需要为单页设置特定背景或布局，应该在 `---` 下方紧接块级 Frontmatter，如：
  ```yaml
  ---
  layout: image-right
  image: https://r2.jumpxai.com/...
  ---
  ```

### 2. 多媒体与资源托管规范 (CRITICAL)
- **绝对禁止写入本地**：所有生成的插图、视频、背景图**绝对不能**尝试写入到工作区的 `public/` 目录下。
- **强制使用 JumpX CDN**：
  - 图片链接必须形如：`https://r2.jumpxai.com/courses/{course-slug}/{lesson-slug}/xx.png`
  - 如果用户提供的仅仅是“第 1 页到第 20 页的图”，请使用全屏图片布局，语法如下：
    ```yaml
    ---
    layout: image
    image: https://r2.jumpxai.com/.../01.jpg
    ---
    ```

### 3. 组件与复用策略
- 跨课程通用的知识卡片，不要重复写正文，使用 `<src="../shared-slides/xxx.md" />` 导入。
- **全局 UI 兼容**：不要在单页 Slide 内覆盖 `top: 0` 的绝对定位元素，以免遮挡平台默认注入的 `global-top.vue`（返回主站导航栏）。

### 4. 全图流课件组装特例（针对第一课）
如果用户表示“我第一课制作的都是图片”，请直接生成全图流框架。每张图片独占一页，不需要额外的 Markdown 文本（或者只放在 speaker notes 里），使用 `layout: image` 或者全屏 `<img>` 标签构建。

## 典型输出结构示例
```markdown
---
theme: default
title: Week 01 - 纯图流示例
transition: fade
---

<!-- 第 1 页 -->
<img src="https://r2.jumpxai.com/courses/ai-camp/week-01/slide-01.png" class="w-full h-full object-cover" />

---

<!-- 第 2 页 -->
<img src="https://r2.jumpxai.com/courses/ai-camp/week-01/slide-02.png" class="w-full h-full object-cover" />

---
```
