# 图片存放目录

把笔记里要用的截图、波形图、原理图放在这里。

## 引用方式

从 `docs/notes/xxx.md` 引用：

```markdown
![说明文字](../assets/images/文件名.png)
```

从 `docs/projects/xxx.md` 引用：

```markdown
![说明文字](../assets/images/文件名.png)
```

（两个目录都在 `docs/` 下一层，所以相对路径都是 `../assets/images/`）

## 命名建议

- 全小写 + 连字符，例如 `gpio-输出波形.png`
- 按主题加前缀，避免 `截图1.png` 这种名字
- 图片体积尽量压到 500KB 以下，否则打开会慢
