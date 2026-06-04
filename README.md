# TomatoBar 🍅

一款简洁的 macOS 菜单栏番茄时钟 app，帮助你专注工作、规律休息。

## 功能

- **番茄钟计时** — 25 分钟专注 + 5 分钟短休息 + 长休息，可自定义时长
- **菜单栏驻留** — 图标常驻顶部菜单栏，显示实时倒计时和当前模式
- **系统通知 + 声音** — 计时结束自动提醒
- **自动下一轮** — 专注/休息结束后可自动开始下一轮
- **历史统计** — 按天/周/月查看番茄完成数量和时间分布（Swift Charts）
- **轻量纯净** — 纯 SwiftUI 构建，不占用系统资源

## 使用

1. 点击菜单栏的 🍅 图标，弹出面板
2. 点击「开始专注」启动第一个番茄
3. 专注结束后自动进入休息，也可手动跳过
4. 切换到「统计」Tab 查看历史记录
5. 切换到「设置」Tab 自定义时长和行为

## 安装

在 [Releases](https://github.com/20Tsuki/TomatoBar/releases) 下载最新版本，将 `TomatoBar.app` 拖入 `Applications` 文件夹即可。

或使用 Xcode 自行构建：

```bash
git clone https://github.com/20Tsuki/TomatoBar.git
cd TomatoBar
open TomatoBar.xcodeproj
```

## 技术栈

- **SwiftUI** — UI 框架
- **SwiftData** — 本地持久化
- **Swift Charts** — 统计图表
- **MenuBarExtra** — 菜单栏驻留
- **UserNotifications** — 系统通知
- 最低系统：macOS 14

## License

MIT
