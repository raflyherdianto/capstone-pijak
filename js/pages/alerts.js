// Price Alerts Page
const PRICE_ALERTS = [
    {
        commodity: 'Rice',
        condition: 'Greater than',
        threshold: 16000,
        methods: ['Email', 'Push notification'],
        created: '2 days ago'
    },
    {
        commodity: 'Chili',
        condition: 'Less than',
        threshold: 40000,
        methods: ['Push notification'],
        created: '5 days ago'
    },
    {
        commodity: 'Sugar',
        condition: 'Change % more than',
        threshold: 10,
        methods: ['Email'],
        created: '1 week ago'
    }
];

function renderAlertCard(alert) {
    const thresholdLabel = alert.condition === 'Change % more than'
        ? `${alert.threshold}%`
        : `Rp ${parseInt(alert.threshold).toLocaleString()}`;

    const methodBadges = alert.methods.map(method => `
        <span class="alert-method-badge">${method}</span>
    `).join('');

    return `
        <div class="alert-item card" data-alert="${alert.commodity}-${alert.condition}-${alert.threshold}">
            <div class="alert-item-header">
                <div class="alert-item-summary">
                    <span class="alert-title">${alert.commodity}</span>
                    <span class="alert-description">${alert.condition} ${thresholdLabel}</span>
                </div>
                <button type="button" class="alert-delete-btn">Remove</button>
            </div>
            <div class="alert-item-meta">
                <div class="alert-methods">${methodBadges}</div>
                <span class="alert-created">Created ${alert.created}</span>
            </div>
        </div>
    `;
}

function renderAlerts() {
    const alertRows = PRICE_ALERTS.map(alert => renderAlertCard(alert)).join('');

    return `
        <div class="card">
            <div class="page-header-row">
                <div>
                    <h2>Price Alerts</h2>
                    <p class="page-description">Monitor harga komoditas penting dan dapatkan pemberitahuan ketika kondisi harga yang Anda tetapkan terpenuhi.</p>
                </div>
                <div class="alert-summary-card">
                    <span class="alert-summary-label">Active alerts</span>
                    <strong>${PRICE_ALERTS.length}</strong>
                </div>
            </div>

            <div class="alert-form-grid">
                <div class="control-group">
                    <label for="alertCommodity">Commodity</label>
                    <select id="alertCommodity" class="select-box">
                        <option>Rice</option>
                        <option>Chili</option>
                        <option>Sugar</option>
                        <option>Cooking Oil</option>
                        <option>Shallots</option>
                    </select>
                </div>
                <div class="control-group">
                    <label for="alertCondition">Condition</label>
                    <select id="alertCondition" class="select-box">
                        <option value="Greater than">Greater than</option>
                        <option value="Less than">Less than</option>
                        <option value="Change % more than">Change % more than</option>
                    </select>
                </div>
                <div class="control-group">
                    <label for="alertThreshold">Threshold value</label>
                    <input type="number" id="alertThreshold" class="input-box" placeholder="Enter threshold" />
                </div>
                <div class="control-group control-action">
                    <label>&nbsp;</label>
                    <button class="btn-primary" id="createAlertBtn">Create alert</button>
                </div>
            </div>

            <div class="card alert-method-card">
                <h3>Notification methods</h3>
                <p>Select how you want to receive alert notifications.</p>
                <div class="alert-method-grid">
                    <label class="method-checkbox">
                        <input type="checkbox" id="alertEmail" checked />
                        <span>Email</span>
                    </label>
                    <label class="method-checkbox">
                        <input type="checkbox" id="alertWhatsapp" />
                        <span>WhatsApp</span>
                    </label>
                    <label class="method-checkbox">
                        <input type="checkbox" id="alertPush" checked />
                        <span>Push notification</span>
                    </label>
                </div>
            </div>

            <div class="card">
                <div class="section-header">
                    <h3>Active alerts</h3>
                    <p>Alerts are triggered when commodity prices meet your configured criteria.</p>
                </div>
                <div id="alertsList" class="alerts-list">
                    ${alertRows}
                </div>
            </div>
        </div>
    `;
}

function renderAlertsList() {
    const alertsList = document.getElementById('alertsList');
    if (!alertsList) return;

    if (PRICE_ALERTS.length === 0) {
        alertsList.innerHTML = '<p class="empty-alert-message">No active alerts. Create an alert to start monitoring prices.</p>';
        return;
    }

    alertsList.innerHTML = PRICE_ALERTS.map(alert => renderAlertCard(alert)).join('');
}

function removeAlert(index) {
    PRICE_ALERTS.splice(index, 1);
    renderAlertsList();
    showNotification('Alert removed successfully');
}

function initAlerts() {
    renderAlertsList();

    document.getElementById('createAlertBtn')?.addEventListener('click', () => {
        const commodity = document.getElementById('alertCommodity').value;
        const condition = document.getElementById('alertCondition').value;
        const thresholdInput = document.getElementById('alertThreshold');
        const threshold = thresholdInput.value;

        const emailChecked = document.getElementById('alertEmail')?.checked;
        const waChecked = document.getElementById('alertWhatsapp')?.checked;
        const pushChecked = document.getElementById('alertPush')?.checked;

        if (!threshold) {
            showNotification('Please enter a threshold value');
            return;
        }

        const methods = [];
        if (emailChecked) methods.push('Email');
        if (waChecked) methods.push('WhatsApp');
        if (pushChecked) methods.push('Push notification');

        if (methods.length === 0) {
            showNotification('Select at least one notification method');
            return;
        }

        PRICE_ALERTS.unshift({
            commodity,
            condition,
            threshold: Number(threshold),
            methods,
            created: 'just now'
        });

        thresholdInput.value = '';
        renderAlertsList();
        showNotification('Price alert created successfully');
    });

    document.getElementById('alertsList')?.addEventListener('click', (event) => {
        const button = event.target.closest('.alert-delete-btn');
        if (!button) return;

        const alertItem = button.closest('.alert-item');
        const alertKey = alertItem?.getAttribute('data-alert');
        if (!alertKey) return;

        const index = PRICE_ALERTS.findIndex(alert => `${alert.commodity}-${alert.condition}-${alert.threshold}` === alertKey);
        if (index >= 0) removeAlert(index);
    });
}