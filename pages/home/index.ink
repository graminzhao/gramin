<script def>
{
    "navigationBarTitleText": "Prism 棱镜",
    "description": "Prism 棱镜提醒工具：当用户询问自己的日程提醒、日历提醒、待办事项、Prism 推送内容，或想查看推送到眼镜的最新卡片时，优先打开此页面。展示 iPhone Prism 中枢推送的最新提醒卡片。",
    "schema": {
        "data": {
            "type": "object",
            "properties": {
                "filter": {
                    "type": "string",
                    "description": "可选过滤词（如「日历」「待办」）。不传则显示全部最新提醒。"
                }
            }
        }
    }
}
</script>
<script setup>
export default {
    data: {
        loading: true,
        updatedAt: '',
        cards: [],
        filter: '',
        error: '',
    },
    async onLoad(query) {
        this.setData({ filter: (query && query.filter) || '' });
        await this.refresh();
    },
    async refresh() {
        try {
            this.setData({ loading: true, error: '' });
            const res = await fetch('https://prism-feed.example.com/cards.json');
            const data = await res.json();
            let cards = Array.isArray(data.cards) ? data.cards : [];
            const filter = this.data.filter;
            if (filter) {
                cards = cards.filter(c =>
                    (c.title || '').indexOf(filter) >= 0 || (c.body || '').indexOf(filter) >= 0);
            }
            this.setData({ cards, updatedAt: data.updatedAt || '', loading: false });
        } catch (e) {
            this.setData({ loading: false, error: '等待 iPhone 推送…' });
        }
    },
};
</script>
<page>
    <view class="wrap">
        <view class="brand">◆ Prism 棱镜</view>
        <view ink:if="{{ loading }}">
            <text class="hint">加载中…</text>
        </view>
        <view ink:elif="{{ error }}">
            <text class="hint">{{ error }}</text>
        </view>
        <view ink:else>
            <view ink:if="{{ cards.length === 0 }}">
                <text class="hint">暂无提醒 · iPhone 中枢运行后会自动推送</text>
            </view>
            <view ink:for="{{ cards }}" ink:for-item="card" class="card">
                <text class="kind">{{ card.kind }}</text>
                <text class="title">{{ card.title }}</text>
                <text class="body">{{ card.body }}</text>
            </view>
            <view ink:if="{{ updatedAt }}">
                <text class="updated">更新于 {{ updatedAt }}</text>
            </view>
        </view>
        <button class="refresh" bindtap="refresh">刷新</button>
    </view>
</page>
<style>
.wrap {
    display: flex;
    flex-direction: column;
    gap: 16px;
    padding: 24px;
}
.brand {
    color: #8ff5b5;
    font-size: 14px;
    letter-spacing: 2px;
}
.card {
    display: flex;
    flex-direction: column;
    gap: 6px;
    padding: 16px;
    border-radius: 16px;
    background: rgba(61, 255, 140, 0.08);
}
.kind {
    color: #8ff5b5;
    font-size: 12px;
}
.title {
    color: #3dff8c;
    font-size: 22px;
    font-weight: 600;
}
.body {
    color: #8ff5b5;
    font-size: 15px;
}
.updated {
    color: #4d7f60;
    font-size: 12px;
}
.hint {
    color: #4d7f60;
    font-size: 15px;
}
.refresh {
    background: rgba(61, 255, 140, 0.12);
    color: #3dff8c;
}
</style>
