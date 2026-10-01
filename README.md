# prism-aiui · Prism 棱镜眼镜端智能体

AIUI 智能体：运行在 Rokid Glasses 官方智能体框架上，显示 Prism 推送的提醒卡片。

- `pages/home/index.ink` — 沉浸式卡片页 + AI 对话工具入口
- `workers/sync.js` — 打开期间每 15 秒轮询 `FEED_URL`

数据格式：`{ "updatedAt": "...", "cards": [{ "id","kind","title","body","ts" }] }`
