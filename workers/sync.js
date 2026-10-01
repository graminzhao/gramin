/**
 * Prism 同步 Worker：页面/Widget 打开期间轮询 Prism 卡片流。
 *
 * 数据源：把 FEED_URL 换成你的卡片 JSON 地址（iPhone 中枢写入）。
 * 格式：{ "updatedAt": "10-02 01:50", "cards": [ { "id","kind","title","body","ts" } ] }
 */
const FEED_URL = 'https://prism-feed.example.com/cards.json';
const POLL_INTERVAL_MS = 15000;

export default {
    latestTs: 0,
    timer: null,

    onOpen(event) {
        event.waitUntil(this.startPolling());
    },

    async startPolling() {
        await this.pollOnce();
        this.timer = setInterval(() => this.pollOnce(), POLL_INTERVAL_MS);
    },

    async pollOnce() {
        try {
            const res = await fetch(FEED_URL);
            const data = await res.json();
            const cards = Array.isArray(data.cards) ? data.cards : [];
            const newest = cards.reduce((max, c) => Math.max(max, c.ts || 0), 0);
            if (newest > this.latestTs) {
                this.latestTs = newest;
                // TODO(后续版本)：接系统通知 API，主动弹出提醒；
                // 当前版本由页面轮询同一 FEED_URL 完成显示更新。
            }
        } catch (e) {
            // 拉取失败静默重试，页面端会显示等待文案
        }
    },
};
