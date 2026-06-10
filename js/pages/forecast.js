let currentForecastCommodity = Object.keys(SUB_COMMODITIES)[0] || 'Premium Rice';
let currentForecastWindow = 7;

const FORECAST_DETAILS = {
    "Premium Rice": {
        summary: "AI models project premium rice to advance as domestic consumption remains firm while harvest volumes remain below seasonal averages.",
        projectedRange: "Rp 14.600 - Rp 15.800",
        confidence: "87% confidence",
        riskLevel: "Moderate",
        drivers: [
            "Domestic demand momentum remains strong.",
            "Planting delays are tightening supply.",
            "Export inquiries are increasing for premium grades."
        ],
        buyerGuidance: "Build positions gradually while monitoring support near the lower range.",
        sellerGuidance: "Hold current inventory and look to sell into strength above Rp 15.500."
    },
    "Medium Rice": {
        summary: "Medium rice is expected to trade within a narrow corridor supported by stable household demand and balanced supply conditions.",
        projectedRange: "Rp 12.900 - Rp 13.600",
        confidence: "82% confidence",
        riskLevel: "Low",
        drivers: [
            "Procurement activity has stabilized inventories.",
            "Retail demand remains consistent.",
            "Price pressure is limited by available feedstock."
        ],
        buyerGuidance: "Add small positions for steady exposure as the market remains range-bound.",
        sellerGuidance: "Consider selective selling if inventory levels exceed plan."
    },
    "IR64 Rice": {
        summary: "IR64 rice may face mild downside pressure as supply clears existing stocks and consumer demand stays stable.",
        projectedRange: "Rp 12.400 - Rp 13.100",
        confidence: "78% confidence",
        riskLevel: "Medium",
        drivers: [
            "Warehouse stocks remain elevated.",
            "Demand is steady but muted.",
            "Seasonal harvest flows are expected to keep pressure on prices."
        ],
        buyerGuidance: "Wait for better support around the lower end of the range before entering new positions.",
        sellerGuidance: "Use short-term rallies to trim exposure."
    },
    "Pandan Wangi Rice": {
        summary: "Pandan Wangi rice is likely to stay elevated as premium demand outstrips limited available supply.",
        projectedRange: "Rp 16.100 - Rp 17.000",
        confidence: "85% confidence",
        riskLevel: "Moderate",
        drivers: [
            "Premium grade demand is rising.",
            "Harvest volumes remain constrained.",
            "Price support is reinforced by specialty buyers."
        ],
        buyerGuidance: "Buy selectively for premium exposure and target support near Rp 16.200.",
        sellerGuidance: "Hold for strength and consider selling when momentum peaks."
    }
};

function getForecastDetails() {
    return FORECAST_DETAILS[currentForecastCommodity] || FORECAST_DETAILS['Premium Rice'];
}

function renderForecast() {
    const details = getForecastDetails();
    const commodityOptions = Object.keys(SUB_COMMODITIES).map(name => `
                <option value="${name}" ${currentForecastCommodity === name ? 'selected' : ''}>${name}</option>
            `).join('');

    return `
        <div class="card forecast-card">
            <div class="section-row">
                <div>
                    <p class="subtitle">AI Price Forecast</p>
                    <h2>${currentForecastCommodity}</h2>
                </div>
                <div class="select-group">
                    <label for="forecastCommodity">Commodity</label>
                    <select id="forecastCommodity" class="select-box">
                        ${commodityOptions}
                    </select>
                </div>
            </div>

            <div class="forecast-status-grid">
                <div class="status-item">
                    <span class="status-label">Projected range</span>
                    <strong>${details.projectedRange}</strong>
                </div>
                <div class="status-item">
                    <span class="status-label">Confidence</span>
                    <strong>${details.confidence}</strong>
                </div>
                <div class="status-item">
                    <span class="status-label">Risk level</span>
                    <strong>${details.riskLevel}</strong>
                </div>
            </div>

            <div class="tab-group">
                <span class="tab ${currentForecastWindow === 7 ? 'active' : ''}" data-forecast="7">7 Days</span>
                <span class="tab ${currentForecastWindow === 14 ? 'active' : ''}" data-forecast="14">14 Days</span>
                <span class="tab ${currentForecastWindow === 30 ? 'active' : ''}" data-forecast="30">30 Days</span>
            </div>

            <div class="chart-container">
                <canvas id="forecastChart" height="280"></canvas>
            </div>
        </div>

        <div class="card analysis-card">
            <div class="section-row">
                <div>
                    <p class="subtitle">AI Analysis</p>
                    <h3>Market intelligence for ${currentForecastCommodity}</h3>
                </div>
            </div>
            <p class="analysis-intro">${details.summary}</p>
            <div class="analysis-grid">
                <div class="analysis-item">
                    <h4>Key Drivers</h4>
                    <ul>
                        ${details.drivers.map(item => `<li>${item}</li>`).join('')}
                    </ul>
                </div>
                <div class="analysis-item">
                    <h4>Trading outlook</h4>
                    <p>Model signals favor a disciplined approach with clear support and resistance levels. Monitor supply updates and demand momentum to validate the path.</p>
                </div>
            </div>
        </div>

        <div class="card recommendation-panel">
            <h3>Recommendations</h3>
            <div class="recommendation-grid">
                <div class="recommendation-card buyer-card">
                    <div class="recommendation-label">For buyers</div>
                    <h4>${details.buyerGuidance}</h4>
                    <p>Strategy: enter gradually if price stays above support and confidence remains high.</p>
                    <div class="recommendation-footnote">Actionability: maintain exposure for the next 2-3 weeks.</div>
                </div>
                <div class="recommendation-card seller-card">
                    <div class="recommendation-label">For sellers</div>
                    <h4>${details.sellerGuidance}</h4>
                    <p>Strategy: reduce inventory on rallies and keep an eye on the upper range.</p>
                    <div class="recommendation-footnote">Timing: consider selling when momentum reaches resistance.</div>
                </div>
            </div>
        </div>
    `;
}

function initForecast() {
    renderForecastChart(currentForecastWindow, currentForecastCommodity);

    const commoditySelect = document.getElementById('forecastCommodity');
    commoditySelect?.addEventListener('change', (e) => {
        currentForecastCommodity = e.target.value;
        document.getElementById('pageContent').innerHTML = renderForecast();
        initForecast();
    });

    document.querySelectorAll('.tab[data-forecast]').forEach(tab => {
        tab.addEventListener('click', () => {
            document.querySelectorAll('.tab[data-forecast]').forEach(t => t.classList.remove('active'));
            tab.classList.add('active');
            currentForecastWindow = parseInt(tab.dataset.forecast);
            renderForecastChart(currentForecastWindow, currentForecastCommodity);
        });
    });
}
