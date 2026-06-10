// Chart management
let mainChart = null;
let subChartInstance = null;
let forecastChartInstance = null;
let sparklineInstances = [];

function destroyAllCharts() {
    if (mainChart) { mainChart.destroy(); mainChart = null; }
    if (subChartInstance) { subChartInstance.destroy(); subChartInstance = null; }
    if (forecastChartInstance) { forecastChartInstance.destroy(); forecastChartInstance = null; }
    sparklineInstances.forEach(chart => { if (chart) chart.destroy(); });
    sparklineInstances = [];
}

function createSparkline(ctx, data, color) {
    // determine trend color if not specified
    let trendColor = color;
    if (!trendColor) {
        const first = data[0] ?? 0;
        const last = data[data.length - 1] ?? 0;
        trendColor = (last >= first) ? '#10B981' : '#EF4444';
    }
    const bg = trendColor === '#10B981' ? 'rgba(16,185,129,0.08)' : 'rgba(239,68,68,0.08)';

    const chart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: Array.from({ length: data.length }, () => ''),
            datasets: [{
                data: data,
                borderColor: trendColor,
                backgroundColor: bg,
                borderWidth: 2,
                fill: true,
                pointRadius: 0,
                tension: 0.3
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: { legend: { display: false }, tooltip: { enabled: false } },
            scales: { x: { display: false }, y: { display: false } },
            elements: { line: { capBezierPoints: true } }
        }
    });
    sparklineInstances.push(chart);
    return chart;
}

function renderMainChart(days = 30, commodity = null) {
    const canvas = document.getElementById('mainChartCanvas');
    if (!canvas) return;
    
    const ctx = canvas.getContext('2d');
    if (mainChart) mainChart.destroy();
    
    const labels = Array.from({ length: days }, (_, i) => {
        if (days <= 30) return `Day ${i + 1}`;
        if (days <= 90) return `Week ${Math.floor(i / 7) + 1}`;
        return `Month ${Math.floor(i / 30) + 1}`;
    });
    
    let actual = [];
    // derive base price from commodity if provided
    let basePrice = 14000;
    if (commodity) {
        // try SUB_COMMODITIES first
        if (typeof SUB_COMMODITIES !== 'undefined' && SUB_COMMODITIES[commodity]) {
            basePrice = SUB_COMMODITIES[commodity].price || basePrice;
        } else if (typeof TRENDING_COMMODITIES !== 'undefined') {
            const found = TRENDING_COMMODITIES.find(t => t.name === commodity);
            if (found && found.price) {
                // price might be string like 'Rp 14,250'
                const p = String(found.price).replace(/[^0-9]/g, '');
                if (p) basePrice = parseInt(p, 10);
            }
        }
    }
    for (let i = 0; i < days; i++) {
        let trend = Math.sin(i / (days / 3)) * 800;
        let noise = (Math.random() - 0.5) * 300;
        actual.push(basePrice + trend + noise);
    }
    
    let forecast = actual.map((v, i) => i > days * 0.7 ? v * (1 + (Math.random() * 0.05)) : null);
    
    // choose color based on trend (last vs first)
    const mainFirst = actual[0] ?? 0;
    const mainLast = actual[actual.length - 1] ?? 0;
    const mainUp = mainLast >= mainFirst;
    const mainColor = mainUp ? '#10B981' : '#EF4444';
    const mainBg = mainUp ? 'rgba(16,185,129,0.06)' : 'rgba(239,68,68,0.06)';

    mainChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [
                { label: 'Actual Price (Rp)', data: actual, borderColor: mainColor, backgroundColor: mainBg, tension: 0.3, fill: true, borderWidth: 2 },
                { label: 'AI Forecast', data: forecast, borderColor: '#F59E0B', borderDash: [8, 4], tension: 0.3, fill: false, borderWidth: 2, pointRadius: 0 }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                tooltip: { callbacks: { label: (ctx) => `${ctx.dataset.label}: ${formatRupiah(ctx.raw)}` } }
            },
            scales: { y: { ticks: { callback: (value) => formatRupiah(value) } } }
        }
    });
    return mainChart;
}

function renderSubChart(commodity, data, mode = 'line') {
    const canvas = document.getElementById('subChart');
    if (!canvas) return;
    
    const ctx = canvas.getContext('2d');
    if (subChartInstance) subChartInstance.destroy();
    
    const labels = ['Week 1', 'Week 2', 'Week 3', 'Week 4', 'Current'];
    
    subChartInstance = new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: `${commodity} Price`,
                data: data,
                borderColor: '#F59E0B',
                backgroundColor: mode === 'area' ? 'rgba(245, 158, 11, 0.1)' : 'transparent',
                borderWidth: 2,
                fill: mode === 'area',
                tension: 0.3
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: { tooltip: { callbacks: { label: (ctx) => formatRupiah(ctx.raw) } } },
            scales: { y: { ticks: { callback: (value) => formatRupiah(value) } } }
        }
    });
    return subChartInstance;
}

function renderForecastChart(days = 7, commodity = null) {
    const canvas = document.getElementById('forecastChart');
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    if (forecastChartInstance) forecastChartInstance.destroy();

    const basePrice = (typeof SUB_COMMODITIES !== 'undefined' && commodity && SUB_COMMODITIES[commodity])
        ? SUB_COMMODITIES[commodity].price
        : 14400;

    let labels, forecastData, upperBound, lowerBound;

    if (days === 7) {
        labels = ['Today', 'Day 2', 'Day 3', 'Day 4', 'Day 5', 'Day 6', 'Day 7'];
        forecastData = [basePrice, basePrice + 150, basePrice + 300, basePrice + 450, basePrice + 580, basePrice + 700, basePrice + 820];
        upperBound = forecastData.map((value, index) => value + 180 + index * 10);
        lowerBound = forecastData.map((value, index) => value - 120 - index * 10);
    } else if (days === 14) {
        labels = Array.from({ length: 14 }, (_, i) => `Day ${i + 1}`);
        forecastData = Array.from({ length: 14 }, (_, i) => basePrice + i * 110 + (i > 7 ? 40 : 0));
        upperBound = forecastData.map(v => v + 360);
        lowerBound = forecastData.map(v => v - 260);
    } else {
        labels = Array.from({ length: 30 }, (_, i) => `Day ${i + 1}`);
        forecastData = Array.from({ length: 30 }, (_, i) => basePrice + i * 70 + (i > 14 ? 55 : 0));
        upperBound = forecastData.map(v => v + 420);
        lowerBound = forecastData.map(v => v - 320);
    }

    forecastChartInstance = new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [
                { label: `${commodity || 'AI'} Forecast`, data: forecastData, borderColor: '#0F766E', borderWidth: 2.5, fill: false, tension: 0.28, pointRadius: 2, pointBackgroundColor: '#0F766E' },
                { label: 'Upper Bound (85% CI)', data: upperBound, borderColor: 'rgba(15, 118, 110, 0.25)', backgroundColor: 'rgba(15, 118, 110, 0.08)', borderWidth: 1, fill: '+1', tension: 0.28, pointRadius: 0 },
                { label: 'Lower Bound (85% CI)', data: lowerBound, borderColor: 'rgba(15, 118, 110, 0.25)', backgroundColor: 'rgba(15, 118, 110, 0.05)', borderWidth: 1, fill: false, tension: 0.28, pointRadius: 0 }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            plugins: {
                tooltip: {
                    callbacks: {
                        label: (ctx) => `${ctx.dataset.label}: ${formatRupiah(ctx.raw)}`
                    }
                },
                legend: {
                    labels: {
                        boxWidth: 12,
                        padding: 16,
                        color: getComputedStyle(document.body).getPropertyValue('--text-primary')
                    }
                }
            },
            scales: {
                x: { grid: { display: false }, ticks: { color: getComputedStyle(document.body).getPropertyValue('--text-secondary') } },
                y: { ticks: { callback: (value) => formatRupiah(value), color: getComputedStyle(document.body).getPropertyValue('--text-secondary') }, grid: { color: 'rgba(229, 231, 235, 0.8)' } }
            }
        }
    });
    return forecastChartInstance;
}