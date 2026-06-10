// Market Insights Page
function renderInsights() {
    return `
        <div class="insight-grid">
            <div class="card">
                <i class="fas fa-fire" style="color: var(--accent); font-size: 1.5rem;"></i>
                <h3>Trending Topics</h3>
                <p>Chili demand surges +12% this week</p>
                <small>Impact: High | Trend: 📈</small>
            </div>
            <div class="card">
                <i class="fas fa-chart-line" style="color: var(--success); font-size: 1.5rem;"></i>
                <h3>Top Gainers</h3>
                <p>Shallots +4.2% | Rice +2.3%</p>
                <small>Related: Onion, Garlic</small>
            </div>
            <div class="card">
                <i class="fas fa-chart-line" style="color: var(--danger); font-size: 1.5rem;"></i>
                <h3>Top Losers</h3>
                <p>Cooking Oil -1.5% | Sugar -0.8%</p>
                <small>Related: Palm Oil</small>
            </div>
            <div class="card">
                <i class="fas fa-truck" style="color: var(--primary); font-size: 1.5rem;"></i>
                <h3>Supply Chain Alerts</h3>
                <p>Logistics delay in Java region</p>
                <small>Impact: Moderate</small>
            </div>
            <div class="card">
                <i class="fas fa-cloud-rain" style="color: #3B82F6; font-size: 1.5rem;"></i>
                <h3>Weather Impact</h3>
                <p>Heavy rain forecast in production areas</p>
                <small>Commodities: Rice, Chili</small>
            </div>
            <div class="card">
                <i class="fas fa-calendar-alt" style="color: var(--accent); font-size: 1.5rem;"></i>
                <h3>Harvest Season</h3>
                <p>Rice harvest begins in 2 weeks</p>
                <small>Expected price: -3% to -5%</small>
            </div>
        </div>
    `;
}

function initInsights() {
    // No charts to initialize
}