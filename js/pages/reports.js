// Reports Page
const REPORT_TYPES = [
    { label: 'Daily report', value: 'daily', description: 'Summary of today’s price movement' },
    { label: 'Weekly report', value: 'weekly', description: 'Trend review for the past 7 days' },
    { label: 'Monthly report', value: 'monthly', description: 'Month-to-date performance insights' },
    { label: 'Annual report', value: 'annual', description: 'Yearly market summary and outlook' }
];

const EXPORT_FORMATS = [
    { label: 'PDF', value: 'pdf' },
    { label: 'Excel', value: 'excel' },
    { label: 'CSV', value: 'csv' }
];

const RECENT_REPORTS = [
    { title: 'Daily Market Summary', subtitle: 'Rice, Chili, and Cooking Oil', date: 'March 15, 2026', size: '2.4 MB', format: 'PDF' },
    { title: 'Weekly Price Review', subtitle: 'Trend analysis for Week 11', date: 'March 14, 2026', size: '5.1 MB', format: 'Excel' },
    { title: 'Rice Supply Analysis', subtitle: 'February 2026 detailed review', date: 'March 10, 2026', size: '3.8 MB', format: 'CSV' }
];

function renderReportActionButton(report) {
    return `
        <button class="btn-primary report-action-button" data-report="${report.value}">
            <span class="report-action-title">${report.label}</span>
            <span class="report-action-note">${report.description}</span>
        </button>
    `;
}

function renderExportButton(format) {
    return `
        <button class="btn-outline report-export-button" data-export="${format.value}">
            ${format.label}
        </button>
    `;
}

function renderReportRow(report) {
    return `
        <div class="report-file-row">
            <div class="report-file-meta">
                <div class="report-file-name">${report.title}</div>
                <div class="report-file-subtitle">${report.subtitle}</div>
            </div>
            <div class="report-file-details">
                <span class="report-file-size">${report.size}</span>
                <button class="btn-outline report-download-btn">Download</button>
            </div>
        </div>
    `;
}

function renderReports() {
    const actionButtons = REPORT_TYPES.map(renderReportActionButton).join('');
    const exportButtons = EXPORT_FORMATS.map(renderExportButton).join('');
    const recentRows = RECENT_REPORTS.map(renderReportRow).join('');

    return `
        <div class="card">
            <div class="page-header-row">
                <div>
                    <h2>Generate Reports</h2>
                    <p class="page-description">Create and export report packages for selected commodity ranges, time periods, and formats.</p>
                </div>
                <div class="report-summary-card">
                    <span class="report-summary-label">Available report formats</span>
                    <strong>${EXPORT_FORMATS.length}</strong>
                </div>
            </div>

            <div class="report-action-grid">
                ${actionButtons}
            </div>

            <div class="report-section">
                <div class="report-section-header">
                    <h3>Custom report</h3>
                    <p>Choose a custom date range and commodity for a tailored report.</p>
                </div>
                <div class="report-input-row">
                    <div class="control-group">
                        <label for="startDate">Start date</label>
                        <input type="date" id="startDate" class="input-box" />
                    </div>
                    <div class="control-group">
                        <label for="endDate">End date</label>
                        <input type="date" id="endDate" class="input-box" />
                    </div>
                    <div class="control-group">
                        <label for="reportCommodity">Commodity</label>
                        <select id="reportCommodity" class="select-box">
                            <option>All Commodities</option>
                            <option>Rice</option>
                            <option>Chili</option>
                            <option>Sugar</option>
                            <option>Cooking Oil</option>
                        </select>
                    </div>
                    <div class="control-group control-action">
                        <label>&nbsp;</label>
                        <button class="btn-primary" id="generateCustomReport">Generate report</button>
                    </div>
                </div>
            </div>

            <div class="report-section">
                <div class="report-section-header">
                    <h3>Export format</h3>
                    <p>Select the file format for export.</p>
                </div>
                <div class="report-export-grid">
                    ${exportButtons}
                </div>
            </div>

            <div class="report-file-card">
                <div class="report-section-header">
                    <h3>Recent reports</h3>
                    <p>Access the most recently generated report packages.</p>
                </div>
                <div id="recentReportsList">
                    ${recentRows}
                </div>
            </div>
        </div>
    `;
}

function renderReportsList() {
    const list = document.getElementById('recentReportsList');
    if (!list) return;
    list.innerHTML = RECENT_REPORTS.map(renderReportRow).join('');
}

function initReports() {
    document.querySelectorAll('[data-report]').forEach(btn => {
        btn.addEventListener('click', () => {
            const reportType = btn.dataset.report;
            showNotification(`Generating ${reportType} report. This may take a moment.`);
        });
    });

    document.querySelectorAll('[data-export]').forEach(btn => {
        btn.addEventListener('click', () => {
            showNotification(`Exporting report as ${btn.dataset.export.toUpperCase()}.`);
        });
    });

    document.getElementById('generateCustomReport')?.addEventListener('click', () => {
        const startDate = document.getElementById('startDate').value;
        const endDate = document.getElementById('endDate').value;
        const commodity = document.getElementById('reportCommodity').value;

        if (!startDate || !endDate) {
            showNotification('Please select both start and end dates.');
            return;
        }

        showNotification(`Generating custom report for ${commodity} from ${startDate} to ${endDate}.`);
    });

    document.getElementById('recentReportsList')?.addEventListener('click', (event) => {
        const button = event.target.closest('.report-download-btn');
        if (!button) return;
        showNotification('Download started.');
    });
}