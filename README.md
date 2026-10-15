# 学习指北 · 从 GitHub 仓库到在线学习网站

一套可以直接用的起步模板：用 Markdown 记笔记 → MkDocs Material 编译成网站 → GitHub Pages 免费发布到公网。
以后**push 一次，网站更新一次**，不需要手动上传任何东西。

---

## 0. 先分清三个东西

| 名字 | 是什么 | 在哪 |
|---|---|---|
| **Git** | 版本控制工具，记录"谁在什么时候改了哪一行" | 你的电脑 |
| **GitHub** | 存放 Git 仓库的云端平台 | 浏览器 |
| **GitHub Pages** | GitHub 附赠的静态网站托管服务 | 公网 |

**核心认知**：GitHub Pages 只托管**静态文件**（HTML / CSS / JS / 图片）。
Markdown 浏览器不认，中间必须有一个"把 `.md` 编译成 `.html`"的步骤。
本模板用 **MkDocs Material** 做这件事。

```
本地 notes/*.md  --git push-->  GitHub 仓库  --自动构建-->  在线网站
```

---

## 1. 新建仓库（网页版英文界面）

1. 登录 GitHub → 右上角 `+` → **New repository**
2. **Repository name**：`learning-notes`
   - 全小写 + 连字符，不要中文、不要空格（它会变成网址的一部分）
3. **Description**：随意，如 `我的学习笔记与成果站`
4. **Visibility**：选 **Public**
   - ⚠️ 免费账号的 GitHub Pages 只对 public 仓库开放
5. 勾选 **Add a README file**
6. `.gitignore` 选 `None`，`License` 可选 `MIT`
7. 点绿色 **Create repository**

### 仓库主页各区域速查

| 位置 | 作用 |
|---|---|
| 左上 `owner/仓库名` | 仓库身份 |
| 绿色 `<> Code` 按钮 | 取克隆地址（HTTPS / SSH） |
| `Add file` 按钮 | 网页上新建 / 上传文件 |
| `commits` 数字 | 提交历史，可以点进去看每一次改动 |
| `Settings` 标签 | 开 Pages、改仓库名、删仓库，都在这里 |
| `Issues` / `Pull requests` | 个人笔记项目用不到，忽略 |

> **关于仓库名的一个小技巧**：如果仓库叫 `<你的用户名>.github.io`，网址就是
> `https://<你的用户名>.github.io/`（没有子路径），看起来更正式。
> 但每个账号只能有一个这样的仓库，且必须用来做主页站。
> 建议先用 `learning-notes`，网址形如 `https://<用户名>.github.io/learning-notes/`。

---

## 2. 环境准备

需要装 **Git** 和 **Python 3.8+**：

```bash
git --version
python --version
```

然后装 MkDocs Material：

```bash
pip install mkdocs-material
mkdocs --version
```

> 如果 `pip` 装得很慢，换国内源：
> `pip install mkdocs-material -i https://pypi.tuna.tsinghua.edu.cn/simple`

---

## 3. 把本模板放进仓库

### 方式 1：命令行（推荐）

```bash
cd 你放项目的目录
git clone https://github.com/<你的用户名>/learning-notes.git
```

把本模板里的这些内容**复制到 `learning-notes/` 目录下**：

```
mkdocs.yml
.gitignore
docs/
```

然后：

```bash
cd learning-notes
git add .
git commit -m "初始化学习笔记站"
git push
```

### 方式 2：纯网页（不装 Git）

1. 打开仓库页 → `Add file` → `Upload files`
2. 把 `mkdocs.yml` 和整个 `docs/` 文件夹拖进去
3. 下方 Commit changes 填一句说明 → **Commit changes**

---

## 4. 本地预览（写笔记时的反馈回路）

```bash
mkdocs serve
```

浏览器打开 `http://127.0.0.1:8000` —— 改 `.md` 文件**保存即刷新**，不用重启。
按 `Ctrl + C` 停止。

这一步很关键：它让你在推送到公网之前就能看到最终效果。

---

## 5. 发布到公网（核心一步）

### 5.1 推送构建产物

```bash
mkdocs gh-deploy
```

这条命令会：把 `docs/` 编译成 HTML → 推到仓库的 `gh-pages` 分支。
**你不碰 `gh-pages` 分支，它由命令自动维护。**

### 5.2 打开 Pages

1. 仓库页 → **Settings**（顶部标签栏最后一个）
2. 左侧栏 → **Pages**
3. **Source** 选 `Deploy from a branch`
4. **Branch** 选 `gh-pages`，目录选 `/ (root)` → **Save**
5. 等 1–2 分钟，刷新页面，顶部会出现：

```
Your site is live at https://<你的用户名>.github.io/learning-notes/
```

点进去能打开，就成功了。

### 5.3 以后再更新

改完笔记只要两条命令：

```bash
git add . && git commit -m "新增 xx 笔记"
mkdocs gh-deploy
```

> **想更省事？** 可以改用 GitHub Actions 自动部署：`git push` 之后由云端自动构建，
> 不用本地跑 `gh-deploy`。配置见文末「附录 B」。
> 两条路线**二选一**，不要同时开。

---

## 6. 怎么组织笔记

### 6.1 分清两类内容（最重要的一条原则）

| 类型 | 放哪 | 特征 | 例子 |
|---|---|---|---|
| **知识点笔记** | `docs/notes/` | 可复用、会长期更新、按主题 | 「STM32 GPIO 八种模式」 |
| **过程记录** | `docs/notes/` 同一目录 | 带时间戳、一次性、按时间 | 「2026-10-14 调通了 SPI」 |
| **成果展示** | `docs/projects/` | 有成品、有截图、面向别人看 | 「OLED 中文显示」 |
| **复习材料** | `docs/review/` | 错题、易错点、周复盘 | 「2026-W42 周复盘」 |

很多人笔记站最后废弃，就是因为把「今天学了啥」和「这个知识点是什么」混在一个文件里，
半年后既找不回知识点，也翻不出时间线。

### 6.2 命名规则

```
日期类：  2026-10-14-stm32-gpio.md          （年月日-主题，可排序）
知识点类：stm32-gpio-八种模式.md
成果类：  stm32-oled-中文显示.md
复盘类：  2026-W42-周复盘.md                 （ISO 周号）
```

**文件名用英文/数字/连字符，中文标题写在文件内部的 `# 标题` 里。**
理由：中文文件名会变成 URL 里的 `%E4%B8%AD%E6%96%87` 一长串乱码，分享出去很难看。

### 6.3 每篇笔记的头部（front matter）

```markdown
---
title: STM32 GPIO 八种输出模式
date: 2026-10-14
tags:
  - STM32
  - 寄存器
status: 已掌握
review: 2026-10-21
---
```

`status` 和 `review` 是给"回顾"用的：搜 `status: 待复习` 就能拉出所有欠账。

### 6.4 新增一篇笔记的完整流程

1. 复制 `docs/notes/` 里的样例文件，改名
2. 改里面的标题和内容
3. 在 `mkdocs.yml` 的 `nav:` 里加一行
4. `mkdocs serve` 预览
5. `mkdocs gh-deploy` 发布

> `nav:` 手写容易漏。如果笔记变多觉得烦，可以装 `mkdocs-awesome-pages-plugin` 用目录文件自动生成导航；
> 或者干脆删掉 `nav:` 整段，让 MkDocs 按文件名字母序自动生成。

---

## 7. 怎么可视化学习成果

### 7.1 Mermaid 图表（已配好，直接写）

流程图、时间线、状态机都能画。在 `.md` 里写：

````markdown
```mermaid
flowchart LR
    A[51 单片机] --> B[STM32 标准库]
    B --> C[时钟与寄存器]
    C --> D[外设驱动]
    D --> E[OLED 中文显示]
```
````

### 7.2 进度表格

```markdown
| 方向 | 进度 | 状态 |
|---|---|---|
| STM32 | ██████░░░░ 60% | 进行中 |
| C/C++ | ████░░░░░░ 40% | 进行中 |
```

用 `█` 和 `░` 拼进度条，纯文本、任何主题都能显示。

### 7.3 截图与波形图

把图片放进 `docs/assets/images/`，然后：

```markdown
![GPIO 输出波形](../assets/images/gpio-波形.png)
```

### 7.4 提示框

```markdown
!!! note "踩坑记录"
    这里写内容，会渲染成带标题的彩色盒子。
```

---

## 8. 怎么辅助回顾

1. **全文搜索**：Material 自带，右上角搜索框，中文也支持。这是回顾最有效的入口。
2. **状态标记**：`status: 待复习` + 搜索，等于自建一个待办清单。
3. **复习日期**：`review: 2026-10-21`，到期时搜日期。
4. **周复盘**：每周日在 `docs/review/` 写一篇，模板见 `_template-周复盘.md`。
5. **标签页**：想在站里加一个标签汇总页，装 `mkdocs-material` 的 `tags` 插件即可：

```yaml
plugins:
  - tags:
      tags_file: tags.md
```

---

## 9. 常见问题

| 现象 | 原因 | 解决 |
|---|---|---|
| 网址打开是 404 | Pages 没开 / 分支选错 | Settings → Pages 确认分支是 `gh-pages`、目录是 `/ (root)` |
| 页面能开但没样式 | `site_url` 配错 | 检查 `mkdocs.yml` 里的 `site_url` 与真实网址完全一致 |
| `mkdocs` 命令找不到 | 没装或没进 PATH | 重新 `pip install mkdocs-material`，或改用 `python -m mkdocs serve` |
| 中文搜索搜不到 | 没设语言 | 确认 `theme.language: zh` |
| 改了内容网站没变 | 忘了重新部署 | 再跑一次 `mkdocs gh-deploy` |
| 部署后样式是旧的 | 浏览器/CDN 缓存 | `Ctrl + F5` 强制刷新，等 2 分钟 |
| 构建时打印一长串 MkDocs 2.0 授权警告 | 上游版本的提示信息 | 与个人学习站无关，忽略即可，不影响发布 |
| 多出 `site/` 目录 | 本地构建产物 | 已在 `.gitignore` 里，不会被提交 |

---

## 附录 A：文件清单

```
learning-notes-starter/
├─ mkdocs.yml                    站点配置（导航、主题、插件）
├─ .gitignore                    忽略 site/ 等产物
├─ README.md                     本文件
└─ docs/
   ├─ index.md                   网站首页
   ├─ notes/
   │  ├─ index.md                笔记总览（MOC，手动维护索引）
   │  └─ 2026-10-14-stm32-gpio.md  样例笔记
   ├─ projects/
   │  └─ index.md                成果展示
   ├─ review/
   │  ├─ index.md                复习总览
   │  └─ _template-周复盘.md      周复盘模板
   └─ assets/
      └─ images/README.md        图片存放说明
```

## 附录 B：进阶 · 用 GitHub Actions 自动部署

不想每次本地跑 `mkdocs gh-deploy` 的话，新建
`.github/workflows/deploy.yml`：

```yaml
name: Deploy site
on:
  push:
    branches: [main]
permissions:
  contents: write
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.x'
      - run: pip install mkdocs-material
      - run: mkdocs gh-deploy --force
```

然后把 **Settings → Pages → Source** 改成 `Deploy from a branch` / `gh-pages`
（或 `GitHub Actions`，视工作流而定）。之后 `git push` 就会自动发布。

> 注意：如果 Actions 报权限错误，去 **Settings → Actions → General →
> Workflow permissions** 勾选 `Read and write permissions`。
