// Settings Page
function renderSettings() {
    const isDark = document.body.classList.contains('dark');
    const chartTheme = localStorage.getItem('settingsChartTheme') || 'Professional';
    const selectedLanguage = localStorage.getItem('settingsLanguage') || 'English';
    const selectedTimezone = localStorage.getItem('settingsTimezone') || 'GMT+7';
    const autoRefresh = localStorage.getItem('settingsAutoRefresh') || '60';
    const dataRetention = localStorage.getItem('settingsDataRetention') || '12';
    const emailNotifications = localStorage.getItem('settingsEmailNotifications') !== 'false';
    const smsNotifications = localStorage.getItem('settingsSmsNotifications') === 'true';
    const pushNotifications = localStorage.getItem('settingsPushNotifications') !== 'false';
    const alertSound = localStorage.getItem('settingsAlertSound') !== 'false';

    return `
        <div class="card">
            <div class="page-header-row">
                <div>
                    <h2>Settings</h2>
                    <p class="page-description">Configure application appearance, notification preferences, security, and data handling for a polished dashboard experience.</p>
                </div>
            </div>

            <div class="settings-grid">
                <div class="settings-card">
                    <div class="section-header">
                        <h3>Appearance & localization</h3>
                        <p>Adjust the dashboard look and default regional settings.</p>
                    </div>

                    <div class="settings-row">
                        <div class="control-group">
                            <label for="settingsDarkToggle">Theme</label>
                            <button id="settingsDarkToggle" class="btn-outline">${isDark ? 'Light mode' : 'Dark mode'}</button>
                        </div>

                        <div class="control-group">
                            <label for="chartTheme">Chart theme</label>
                            <select id="chartTheme" class="select-box">
                                <option${chartTheme === 'Professional' ? ' selected' : ''}>Professional</option>
                                <option${chartTheme === 'Vibrant' ? ' selected' : ''}>Vibrant</option>
                                <option${chartTheme === 'Minimal' ? ' selected' : ''}>Minimal</option>
                            </select>
                        </div>

                        <div class="control-group">
                            <label for="settingsLanguage">Language</label>
                            <select id="settingsLanguage" class="select-box">
                                <option${selectedLanguage === 'English' ? ' selected' : ''}>English</option>
                                <option${selectedLanguage === 'Indonesian' ? ' selected' : ''}>Indonesian</option>
                                <option${selectedLanguage === 'Bahasa Indonesia' ? ' selected' : ''}>Bahasa Indonesia</option>
                            </select>
                        </div>

                        <div class="control-group">
                            <label for="settingsTimezone">Timezone</label>
                            <select id="settingsTimezone" class="select-box">
                                <option${selectedTimezone === 'GMT+7' ? ' selected' : ''}>GMT+7</option>
                                <option${selectedTimezone === 'GMT+8' ? ' selected' : ''}>GMT+8</option>
                                <option${selectedTimezone === 'GMT+9' ? ' selected' : ''}>GMT+9</option>
                                <option${selectedTimezone === 'UTC' ? ' selected' : ''}>UTC</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="settings-card">
                    <div class="section-header">
                        <h3>Notifications</h3>
                        <p>Manage alert delivery, sound settings, and notification channels.</p>
                    </div>

                    <div class="settings-row">
                        <div class="settings-switch-row">
                            <span>Email notifications</span>
                            <input type="checkbox" id="emailNotify" ${emailNotifications ? 'checked' : ''} />
                        </div>

                        <div class="settings-switch-row">
                            <span>SMS alerts</span>
                            <input type="checkbox" id="smsNotify" ${smsNotifications ? 'checked' : ''} />
                        </div>

                        <div class="settings-switch-row">
                            <span>Push notifications</span>
                            <input type="checkbox" id="pushNotify" ${pushNotifications ? 'checked' : ''} />
                        </div>

                        <div class="settings-switch-row">
                            <span>Alert sound</span>
                            <input type="checkbox" id="alertSound" ${alertSound ? 'checked' : ''} />
                        </div>
                    </div>
                </div>

                <div class="settings-card">
                    <div class="section-header">
                        <h3>Account & security</h3>
                        <p>Update account details and enforce stronger security controls.</p>
                    </div>

                    <div class="settings-row">
                        <div class="control-group">
                            <label>Account name</label>
                            <input type="text" class="input-box" value="Arjuna User" disabled />
                        </div>

                        <div class="control-group">
                            <label>Email address</label>
                            <input type="email" class="input-box" value="user@example.com" disabled />
                        </div>

                        <div class="control-group">
                            <label>Two-factor authentication</label>
                            <div class="settings-switch-row">
                                <span>Enabled</span>
                                <input type="checkbox" id="twoFactorToggle" checked />
                            </div>
                        </div>

                        <div class="control-group control-action">
                            <label>&nbsp;</label>
                            <button id="changePasswordBtn" class="btn-primary">Change password</button>
                        </div>
                    </div>
                </div>

                <div class="settings-card">
                    <div class="section-header">
                        <h3>Data & privacy</h3>
                        <p>Control data refresh intervals and local storage policy.</p>
                    </div>

                    <div class="settings-row">
                        <div class="control-group">
                            <label for="autoRefresh">Auto-refresh interval</label>
                            <select id="autoRefresh" class="select-box">
                                <option${autoRefresh === '30' ? ' selected' : ''}>30</option>
                                <option${autoRefresh === '60' ? ' selected' : ''}>60</option>
                                <option${autoRefresh === '120' ? ' selected' : ''}>120</option>
                                <option${autoRefresh === 'Off' ? ' selected' : ''}>Off</option>
                            </select>
                        </div>

                        <div class="control-group">
                            <label for="dataRetention">Retention period</label>
                            <select id="dataRetention" class="select-box">
                                <option${dataRetention === '1' ? ' selected' : ''}>1 month</option>
                                <option${dataRetention === '3' ? ' selected' : ''}>3 months</option>
                                <option${dataRetention === '6' ? ' selected' : ''}>6 months</option>
                                <option${dataRetention === '12' ? ' selected' : ''}>12 months</option>
                            </select>
                        </div>

                        <div class="control-group">
                            <label>Local storage</label>
                            <button id="clearDataBtn" class="btn-outline btn-danger">Clear storage</button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="settings-info-card">
                <div class="section-header">
                    <h3>Application details</h3>
                    <p>Review version information and data source details.</p>
                </div>

                <div class="settings-info-grid">
                    <div class="settings-info-item">
                        <strong>Version</strong>
                        <span>2.0.0</span>
                    </div>
                    <div class="settings-info-item">
                        <strong>Currency</strong>
                        <span>Indonesian Rupiah (IDR)</span>
                    </div>
                    <div class="settings-info-item">
                        <strong>Data source</strong>
                        <span>Real-time market API and AI forecast engine</span>
                    </div>
                    <div class="settings-info-item">
                        <strong>Last update</strong>
                        <span>${new Date().toLocaleDateString()}</span>
                    </div>
                </div>
            </div>
        </div>
    `;
}

function initSettings() {
    const settingsDarkToggle = document.getElementById('settingsDarkToggle');
    if (settingsDarkToggle) {
        settingsDarkToggle.addEventListener('click', () => {
            toggleDarkMode();
            const isDark = document.body.classList.contains('dark');
            settingsDarkToggle.textContent = isDark ? 'Light mode' : 'Dark mode';
            showNotification(`Theme updated to ${isDark ? 'dark' : 'light'}.`);
        });
    }

    function bindToggle(id, storageKey, labelTrue, labelFalse) {
        const element = document.getElementById(id);
        if (!element) return;
        element.addEventListener('change', () => {
            const isChecked = element.checked;
            localStorage.setItem(storageKey, isChecked);
            showNotification(`${labelTrue} ${isChecked ? 'enabled' : 'disabled'}.`);
        });
    }

    function bindSelect(id, storageKey, label) {
        const element = document.getElementById(id);
        if (!element) return;
        element.addEventListener('change', () => {
            localStorage.setItem(storageKey, element.value);
            showNotification(`${label} set to ${element.value}.`);
        });
    }

    bindToggle('emailNotify', 'settingsEmailNotifications', 'Email notifications', 'Email notifications');
    bindToggle('smsNotify', 'settingsSmsNotifications', 'SMS alerts', 'SMS alerts');
    bindToggle('pushNotify', 'settingsPushNotifications', 'Push notifications', 'Push notifications');
    bindToggle('alertSound', 'settingsAlertSound', 'Alert sound', 'Alert sound');
    bindToggle('twoFactorToggle', 'settingsTwoFactorEnabled', 'Two-factor authentication', 'Two-factor authentication');

    bindSelect('chartTheme', 'settingsChartTheme', 'Chart theme');
    bindSelect('settingsLanguage', 'settingsLanguage', 'Language');
    bindSelect('settingsTimezone', 'settingsTimezone', 'Timezone');
    bindSelect('autoRefresh', 'settingsAutoRefresh', 'Auto-refresh interval');
    bindSelect('dataRetention', 'settingsDataRetention', 'Retention period');

    document.getElementById('changePasswordBtn')?.addEventListener('click', () => {
        showNotification('Password change flow has been requested.');
    });

    document.getElementById('clearDataBtn')?.addEventListener('click', () => {
        if (confirm('Are you sure you want to clear all local settings and cached data?')) {
            localStorage.clear();
            showNotification('Local storage cleared. Reloading dashboard.');
            setTimeout(() => location.reload(), 1200);
        }
    });
}