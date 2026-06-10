// Chart helpers are provided by js/utils/charts.js

// Dashboard page render + init
window.renderDashboard = function() {
    return `
        <div class="kpi-grid">
            ${Object.keys(KPI_DATA).map(k => `
                <div class="card kpi-card">
                    <div class="kpi-title">${k.replace(/_/g, ' ')}</div>
                    <div class="kpi-value">${KPI_DATA[k].value}</div>
                    <div class="kpi-change">${KPI_DATA[k].change}</div>
                    <canvas class="sparkline-canvas" data-key="${k}" width="80" height="30"></canvas>
                </div>
            `).join('')}
        </div>

        <div class="card">
            <h3>Main Price Chart</h3>
            <div style="max-width:100%; overflow:hidden;"><canvas id="mainChartCanvas" height="220"></canvas></div>
        </div>

        <div class="card">
            <h3>Trending Commodities</h3>
            <div class="trending-grid">
                ${TRENDING_COMMODITIES.map((t, i) => {
                    const imgMap = { 'Rice': 'assets/rice.svg', 'Chili': 'assets/chili.svg', 'Shallots': 'assets/shallots.svg', 'Cooking Oil': 'assets/oil.svg', 'Sugar': 'assets/sugar.svg' };
                    const key = Object.keys(imgMap).find(k => t.name.includes(k)) || null;
                    const src = key ? imgMap[key] : 'assets/placeholder.svg';
                    return `
                    <div class="card trending-card">
                        <div class="trending-item">
                            <div class="trending-left">
                                <div class="trending-avatar"><img src="${src}" alt="${t.name}"></div>
                                <div class="trending-content">
                                    <strong>${t.name}</strong>
                                    <div class="muted">${t.price} · ${t.change}</div>
                                </div>
                            </div>
                            <canvas class="sparkline-canvas" data-key="tr${i}" width="120" height="36"></canvas>
                        </div>
                    </div>
                `
                }).join('')}
            </div>
        </div>
    `;
};

window.initDashboard = function() {
    // Render main chart
    try { renderMainChart(30); } catch (e) { console.warn(e); }

    // Render sparklines for KPI and trending
    document.querySelectorAll('.sparkline-canvas').forEach((canvas) => {
        const key = canvas.dataset.key;
        const ctx = canvas.getContext('2d');
        let data = [];
        if (key && KPI_DATA[key]) data = KPI_DATA[key].sparkline || [];
        else if (key && key.startsWith('tr')) {
            const idx = parseInt(key.replace('tr','')) || 0;
            data = TRENDING_COMMODITIES[idx]?.sparkline || [];
        }
        if (data.length > 0) {
            try {
                let color = null;
                if (key && KPI_DATA[key]) {
                    color = KPI_DATA[key].trend === 'down' ? '#EF4444' : '#10B981';
                } else if (key && key.startsWith('tr')) {
                    const idx = parseInt(key.replace('tr','')) || 0;
                    color = TRENDING_COMMODITIES[idx]?.up ? '#10B981' : '#EF4444';
                }
                createSparkline(ctx, data, color);
            } catch (e) { console.warn(e); }
        }
    });

    // Make trending cards clickable to select commodity for main chart
    document.querySelectorAll('.trending-card').forEach((card, idx) => {
        card.addEventListener('click', () => {
            const name = TRENDING_COMMODITIES[idx]?.name;
            if (name) {
                try { renderMainChart(30, name); } catch (e) { console.warn(e); }
                // mark selected
                document.querySelectorAll('.trending-card').forEach(c => c.classList.remove('selected'));
                card.classList.add('selected');
            }
        });
    });
};