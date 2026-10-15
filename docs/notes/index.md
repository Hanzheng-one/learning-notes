---
title: 学习笔记总览
---

# 学习笔记总览

这一页叫 **MOC（Map of Content）**，是手动维护的索引页。
笔记一多，光靠左侧导航会找不到东西，所以这里按主题分组列出来。

## 嵌入式

- [STM32 GPIO 八种输出模式](2026-10-14-stm32-gpio.md) — 2026-10-14

## C / C++

- 待补充

## 大学物理实验

- 待补充

---

## 怎么新增一篇笔记

1. 在本目录下新建 `YYYY-MM-DD-主题.md`
2. 在文件开头写上：

   ```markdown
   ---
   title: 标题
   date: 2026-10-14
   tags:
     - 标签1
   status: 学习中
   review: 2026-10-21
   ---
   ```

3. 回到本页，在对应分组下加一行链接
4. 在 `mkdocs.yml` 的 `nav:` 里加一行
5. `mkdocs serve` 预览 → `mkdocs gh-deploy` 发布
