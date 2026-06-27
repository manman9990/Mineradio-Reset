# Mineradio Reset

Mineradio Reset 是由 manman9990 维护的 Windows 桌面音乐播放器重置版，当前版本为 `v1.0.0`。这个版本以沉浸式听歌体验为核心，整合搜索播放、歌词舞台、3D 歌单架、粒子视觉、DIY 视觉控制台、本地音乐库、天气电台和 GitHub 更新能力，目标是做成一款有个人风格、可持续迭代、可独立发布的播放器。

## 当前版本

- 版本号：`1.0.0`
- 作者/维护者：`manman9990`
- 应用名：`Mineradio Reset`
- 包名：`mineradio-reset`
- GitHub 仓库：`https://github.com/manman9990/Mineradio-Reset`

## 核心功能

- 音乐搜索、播放队列、歌词显示和本地音乐库
- 3D 歌单架与歌单详情浏览
- 粒子视觉、电影镜头、视觉预设和 DIY 控制台
- 天气电台、每日推荐、私人电台等入口
- 网易云音乐、QQ 音乐等第三方平台辅助接入
- Windows Electron 桌面端打包发布
- Android Capacitor WebView 调试壳
- GitHub Releases 更新检测

## 开发运行

```powershell
npm install
npm start
```

## Windows 打包

```powershell
npm run build:win
```

打包产物默认输出到 `dist/`。

## Android 调试包

```powershell
npm run build:android:debug
```

Android 版本是 Capacitor WebView 壳。它不会直接运行 Electron 的本地 Node 服务，如需搜索、播放、歌词等接口，需要在 `public/mobile-config.js` 中配置可访问的 API 服务地址。

## 第三方平台说明

Mineradio Reset 不是网易云音乐、QQ 音乐或其他音乐平台的官方客户端，也不隶属于任何第三方音乐平台。项目中的第三方平台接入仅用于个人学习、本地客户端体验和用户自有账号的播放辅助。请遵守对应平台的用户协议、版权规则和会员权益规则。

本项目不提供绕过付费、绕过会员、破解音质或重新分发音乐内容的能力。

## 隐私与本地数据

登录 Cookie、搜索历史、自定义封面、自定义歌词、节奏分析缓存等数据应只保存在本机用户数据目录或浏览器本地存储中，不应提交到仓库。

更多说明见 [PRIVACY.md](./PRIVACY.md)。

## 版权与授权

Copyright (C) 2026 manman9990.

本项目采用 GPL-3.0 授权。详见 [LICENSE](./LICENSE)。
