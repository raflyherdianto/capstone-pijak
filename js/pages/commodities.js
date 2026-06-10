// Commodities Page
let currentSubCommodity = "Premium Rice";

const COMMODITY_CATEGORIES = {
    "Rice": [
        {
            name: "Premium Rice",
            price: 15200,
            changeText: "+3.2%",
            trend: "up",
            data: [14200, 14420, 14550, 14700, 14880, 14990, 15080, 15140, 15190, 15200, 15260, 15310]
        },
        {
            name: "Medium Rice",
            price: 13800,
            changeText: "+1.1%",
            trend: "up",
            data: [12900, 13020, 13100, 13200, 13320, 13400, 13470, 13530, 13600, 13720, 13780, 13800]
        },
        {
            name: "IR64 Rice",
            price: 12900,
            changeText: "-0.8%",
            trend: "down",
            data: [13100, 13090, 13040, 12980, 12930, 12900, 12880, 12860, 12840, 12820, 12810, 12900]
        },
        {
            name: "Pandan Wangi Rice",
            price: 16500,
            changeText: "+2.7%",
            trend: "up",
            data: [15400, 15550, 15620, 15750, 15880, 15960, 16020, 16100, 16200, 16320, 16420, 16500]
        }
    ],
    "Spices": [
        {
            name: "Chili",
            price: 38500,
            changeText: "+5.1%",
            trend: "up",
            data: [35500, 36000, 36400, 36800, 37050, 37300, 37600, 37900, 38150, 38400, 38500, 38700]
        },
        {
            name: "Shallots",
            price: 28000,
            changeText: "-1.2%",
            trend: "down",
            data: [29000, 28900, 28850, 28800, 28750, 28700, 28640, 28580, 28520, 28440, 28250, 28000]
        }
    ],
    "Staples": [
        {
            name: "Cooking Oil",
            price: 18200,
            changeText: "-0.5%",
            trend: "down",
            data: [18600, 18520, 18450, 18400, 18360, 18320, 18290, 18250, 18230, 18210, 18205, 18200]
        },
        {
            name: "Sugar",
            price: 15800,
            changeText: "+0.8%",
            trend: "up",
            data: [15400, 15460, 15520, 15550, 15580, 15610, 15640, 15670, 15700, 15730, 15770, 15800]
        }
    ]
};

const AI_COMMODITY_ANALYSIS = {
    "Premium Rice": {
        trend: "up",
        changeText: "+3.2% this week",
        forecastSummary: "AI expects Premium Rice to remain strong due to steady domestic demand and tighter supply from planting delays.",
        projectedRange: "Rp 14.700 - Rp 15.400",
        confidence: "Confidence 86%",
        volatility: "Moderate volatility",
        supplySignal: "Supply pressure is rising from delayed harvest cycles.",
        demandSignal: "Retail and foodservice demand is stable to rising.",
        buyerRecommendation: "Buy now while the price is below expected peak levels.",
        sellerRecommendation: "Hold inventory and sell on strength.",
        buyerConfidence: "82% confidence",
        sellerConfidence: "78% confidence"
    },
    "Medium Rice": {
        trend: "stable",
        changeText: "+1.1% this week",
        forecastSummary: "Medium Rice remains stable with balanced demand and steady supply, offering lower risk for buyers.",
        projectedRange: "Rp 12.900 - Rp 13.500",
        confidence: "Confidence 80%",
        volatility: "Low volatility",
        supplySignal: "Inventory levels are healthy after recent procurement.",
        demandSignal: "Household consumption keeps demand consistent.",
        buyerRecommendation: "Add small positions for stability.",
        sellerRecommendation: "Sell selectively if additional stock is needed.",
        buyerConfidence: "74% confidence",
        sellerConfidence: "70% confidence"
    },
    "IR64 Rice": {
        trend: "down",
        changeText: "-0.8% this week",
        forecastSummary: "IR64 Rice may see mild downside as excess stock filters through the market.",
        projectedRange: "Rp 12.400 - Rp 13.100",
        confidence: "Confidence 76%",
        volatility: "Moderate volatility",
        supplySignal: "Warehouse stock remains elevated.",
        demandSignal: "Demand is steady but not strong enough to lift prices.",
        buyerRecommendation: "Wait for clearer support near the lower range.",
        sellerRecommendation: "Reduce exposure on rallies.",
        buyerConfidence: "68% confidence",
        sellerConfidence: "75% confidence"
    },
    "Pandan Wangi Rice": {
        trend: "up",
        changeText: "+2.7% this week",
        forecastSummary: "Pandan Wangi Rice is expected to stay elevated because premium demand is rising while supply remains limited.",
        projectedRange: "Rp 16.100 - Rp 16.900",
        confidence: "Confidence 83%",
        volatility: "Moderate volatility",
        supplySignal: "Premium crop availability is limited.",
        demandSignal: "Strong demand from specialty food and export markets.",
        buyerRecommendation: "Buy for premium quality exposure.",
        sellerRecommendation: "Hold and sell on strength.",
        buyerConfidence: "80% confidence",
        sellerConfidence: "76% confidence"
    },
    "Chili": {
        trend: "up",
        changeText: "+5.1% this week",
        forecastSummary: "Chili prices are accelerating as harvest volumes tighten and demand for fresh spice remains elevated.",
        projectedRange: "Rp 38.000 - Rp 39.500",
        confidence: "Confidence 84%",
        volatility: "High volatility",
        supplySignal: "Crop availability is constrained by weather and logistics.",
        demandSignal: "Strong retail and foodservice demand is pushing prices higher.",
        buyerRecommendation: "Buy selectively on pullbacks while volatility persists.",
        sellerRecommendation: "Sell into strength and protect margins.",
        buyerConfidence: "79% confidence",
        sellerConfidence: "81% confidence"
    },
    "Shallots": {
        trend: "down",
        changeText: "-1.2% this week",
        forecastSummary: "Shallots are showing softening pressure as supply recovers from recent disruptions.",
        projectedRange: "Rp 27.500 - Rp 28.400",
        confidence: "Confidence 77%",
        volatility: "Moderate volatility",
        supplySignal: "Warehouse stocks are gradually rebuilding.",
        demandSignal: "Consumer demand remains moderate and seasonal.",
        buyerRecommendation: "Wait for a stabilized range before adding exposure.",
        sellerRecommendation: "Trim positions as prices approach resistance.",
        buyerConfidence: "70% confidence",
        sellerConfidence: "76% confidence"
    },
    "Cooking Oil": {
        trend: "down",
        changeText: "-0.5% this week",
        forecastSummary: "Cooking Oil prices are under slight pressure as production increases and inventory buffers improve.",
        projectedRange: "Rp 18.000 - Rp 18.400",
        confidence: "Confidence 80%",
        volatility: "Low volatility",
        supplySignal: "Processing volumes are steady and distribution is improving.",
        demandSignal: "Demand remains stable but not rising aggressively.",
        buyerRecommendation: "Hold off on new buying until clear support is established.",
        sellerRecommendation: "Sell selectively if inventory is above plan.",
        buyerConfidence: "72% confidence",
        sellerConfidence: "77% confidence"
    },
    "Sugar": {
        trend: "up",
        changeText: "+0.8% this week",
        forecastSummary: "Sugar has modest upside as regional demand remains steady and supply is slightly tighter.",
        projectedRange: "Rp 15.600 - Rp 16.000",
        confidence: "Confidence 79%",
        volatility: "Low volatility",
        supplySignal: "Production is healthy but slower than seasonal expectations.",
        demandSignal: "Food processing demand provides steady support.",
        buyerRecommendation: "Accumulate lightly on dips within the range.",
        sellerRecommendation: "Retain positions for gradual improvement in the coming weeks.",
        buyerConfidence: "75% confidence",
        sellerConfidence: "74% confidence"
    }
};

function getCommodityAnalysis() {
    return AI_COMMODITY_ANALYSIS[currentSubCommodity] || AI_COMMODITY_ANALYSIS["Premium Rice"];
}

function getCommodityData(name) {
    for (const category of Object.values(COMMODITY_CATEGORIES)) {
        const item = category.find(product => product.name === name);
        if (item) return item;
    }
    return COMMODITY_CATEGORIES.Rice[0];
}

function createCategorySummary(categoryName, items) {
    const upCount = items.filter(item => item.trend === 'up').length;
    const downCount = items.filter(item => item.trend === 'down').length;
    const activeLabel = upCount >= downCount ? 'Trending higher' : 'Under pressure';

    return `
        <div class="category-card">
            <div class="category-header">
                <div>
                    <h4>${categoryName}</h4>
                    <p>${activeLabel} across ${items.length} commodities.</p>
                </div>
                <div class="category-pill ${upCount >= downCount ? 'pill-positive' : 'pill-negative'}">
                    <span class="trend-badge up-badge">${upCount}</span> / <span class="trend-badge down-badge">${downCount}</span>
                </div>
            </div>
            <div class="mini-commodities-grid">
                ${items.map(item => `
                    <div class="mini-commodity-card" data-commodity="${item.name}">
                        <div class="mini-commodity-header">
                            <div>
                                <strong>${item.name}</strong>
                                <div class="mini-commodity-price">${formatRupiah(item.price)}</div>
                            </div>
                            <span class="trend-pill ${item.trend === 'down' ? 'pill-negative' : 'pill-positive'}">${item.trend === 'down' ? '↓ ' : '↑ '}${item.changeText}</span>
                        </div>
                        <canvas id="sparkline-${item.name.replace(/\s+/g, '-')}"></canvas>
                    </div>
                `).join('')}
            </div>
        </div>
    `;
}

function renderCommodities() {
    const selected = getCommodityData(currentSubCommodity);
    const analysis = getCommodityAnalysis();
    const commodityOptions = Object.values(COMMODITY_CATEGORIES)
        .flat()
        .map(item => `
            <option value="${item.name}" ${currentSubCommodity === item.name ? 'selected' : ''}>${item.name}</option>
        `).join('');

    return `
        <div class="card commodity-detail-header">
            <div class="commodity-main">
                <div class="commodity-image">
                    <span class="commodity-icon">${selected.name.split(' ')[0][0] || 'C'}</span>
                </div>
                <div class="commodity-main-text">
                    <span class="subtitle">Commodity movement summary</span>
                    <h1>${selected.name}</h1>
                    <div class="price-large">${formatRupiah(selected.price)}</div>
                    <div class="price-trend ${analysis.trend === 'down' ? 'change-negative' : 'change-positive'}">${analysis.changeText}</div>
                </div>
            </div>
            <div class="commodity-actions">
                <div>
                    <label class="select-label" for="commoditySelect">Choose commodity</label>
                    <select id="commoditySelect" class="select-box">
                        ${commodityOptions}
                    </select>
                </div>
                <div class="commodity-buttons">
                    <button class="btn-primary" id="trackCommodityBtn">Track Commodity</button>
                    <button class="btn-outline" id="setAlertBtn">Set Alert</button>
                    <button class="btn-outline" id="downloadReportBtn">Download Report</button>
                </div>
            </div>
        </div>

        <div class="card market-summary-card">
            <div class="section-row">
                <div>
                    <h3>Market movement overview</h3>
                    <p>Ringkasan kondisi harga berdasarkan kategori utama komoditas dan tren harian.</p>
                </div>
            </div>
            <div class="commodity-overview-grid">
                ${Object.entries(COMMODITY_CATEGORIES).map(([categoryName, items]) => createCategorySummary(categoryName, items)).join('')}
            </div>
        </div>

        <div class="card main-chart-panel">
            <div class="section-row">
                <div>
                    <h3>${selected.name} price path</h3>
                    <p>Visualisasi historis harga untuk komoditas yang dipilih.</p>
                </div>
            </div>
            <canvas id="mainChartCanvas" height="260"></canvas>
        </div>

        <div class="card analysis-card">
            <div class="analysis-header">
                <h3>AI Analysis</h3>
                <p>Analisis mendalam membantu menginterpretasikan perubahan harga dan rekomendasi perdagangan.</p>
            </div>
            <div class="analysis-grid">
                <div class="analysis-item">
                    <h4>Price outlook</h4>
                    <p>${analysis.forecastSummary}</p>
                </div>
                <div class="analysis-item">
                    <h4>Supply / demand balance</h4>
                    <p>${analysis.supplySignal} ${analysis.demandSignal}</p>
                </div>
                <div class="analysis-item">
                    <h4>Volatility view</h4>
                    <p>${analysis.volatility} with clear market sensitivity to short-term supply fluctuations.</p>
                </div>
                <div class="analysis-item">
                    <h4>Decision support</h4>
                    <p>${analysis.forecastSummary}</p>
                </div>
            </div>
        </div>

        <div class="card recommendation-group">
            <div class="recommendation-card buyer-card">
                <div class="recommendation-label">For buyers</div>
                <h4>${analysis.buyerRecommendation}</h4>
                <p>${analysis.buyerConfidence}. Recommended entry near support levels with risk control.</p>
            </div>
            <div class="recommendation-card seller-card">
                <div class="recommendation-label">For sellers</div>
                <h4>${analysis.sellerRecommendation}</h4>
                <p>${analysis.sellerConfidence}. Consider reducing exposure on strength into key resistance.</p>
            </div>
        </div>
    `;
}

function initCommodities() {
    const selected = getCommodityData(currentSubCommodity);
    renderMainChart(30, selected.name);

    document.querySelectorAll('canvas[id^="sparkline-"]').forEach(canvas => {
        const commodityKey = canvas.id.replace('sparkline-', '').replace(/-/g, ' ');
        const item = getCommodityData(commodityKey);
        const ctx = canvas.getContext('2d');
        if (ctx && item) {
            createSparkline(ctx, item.data, item.trend === 'down' ? '#EF4444' : '#10B981');
        }
    });

    const commoditySelect = document.getElementById('commoditySelect');
    commoditySelect?.addEventListener('change', (e) => {
        currentSubCommodity = e.target.value;
        if (typeof destroyAllCharts === 'function') destroyAllCharts();
        document.getElementById('pageContent').innerHTML = renderCommodities();
        initCommodities();
    });

    document.querySelectorAll('.mini-commodity-card').forEach(card => {
        card.addEventListener('click', () => {
            const newCommodity = card.dataset.commodity;
            if (newCommodity) {
                currentSubCommodity = newCommodity;
                if (typeof destroyAllCharts === 'function') destroyAllCharts();
                document.getElementById('pageContent').innerHTML = renderCommodities();
                initCommodities();
            }
        });
    });

    document.getElementById('trackCommodityBtn')?.addEventListener('click', () => showNotification(`? ${currentSubCommodity} added to your tracked commodities!`));
    document.getElementById('setAlertBtn')?.addEventListener('click', () => showNotification(`?? Alert created for ${currentSubCommodity}.`));
    document.getElementById('downloadReportBtn')?.addEventListener('click', () => showNotification('?? Report is being generated.'));
}
