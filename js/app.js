// ==================== CORE APPLICATION ====================
let currentPage = 'dashboard';

// ==================== DARK MODE ====================
function toggleDarkMode() {
    document.body.classList.toggle('dark');
    localStorage.setItem('darkMode', document.body.classList.contains('dark'));
    
    // Refresh current page charts
    setTimeout(() => {
        if (currentPage === 'dashboard' && typeof initDashboard === 'function') {
            initDashboard();
        } else if (currentPage === 'commodities' && typeof initCommodities === 'function') {
            initCommodities();
        } else if (currentPage === 'forecast' && typeof initForecast === 'function') {
            initForecast();
        }
    }, 50);
}

function initDarkMode() {
    const saved = localStorage.getItem('darkMode');
    if (saved === 'true') {
        document.body.classList.add('dark');
    }
}

// ==================== PAGE LOADER ====================
function loadPage(pageName) {
    currentPage = pageName;
    
    if (typeof destroyAllCharts === 'function') {
        destroyAllCharts();
    }
    
    const pageContent = document.getElementById('pageContent');
    
    switch(pageName) {
        case 'dashboard':
            if (typeof renderDashboard === 'function') {
                pageContent.innerHTML = renderDashboard();
                setTimeout(() => {
                    if (typeof initDashboard === 'function') initDashboard();
                }, 50);
            } else {
                pageContent.innerHTML = '<div class="card">Dashboard module not loaded</div>';
            }
            break;
        case 'commodities':
            if (typeof renderCommodities === 'function') {
                pageContent.innerHTML = renderCommodities();
                setTimeout(() => {
                    if (typeof initCommodities === 'function') initCommodities();
                }, 50);
            }
            break;
        case 'forecast':
            if (typeof renderForecast === 'function') {
                pageContent.innerHTML = renderForecast();
                setTimeout(() => {
                    if (typeof initForecast === 'function') initForecast();
                }, 50);
            }
            break;
        case 'insights':
            if (typeof renderInsights === 'function') {
                pageContent.innerHTML = renderInsights();
                setTimeout(() => {
                    if (typeof initInsights === 'function') initInsights();
                }, 50);
            }
            break;
        case 'map':
            if (typeof renderMap === 'function') {
                pageContent.innerHTML = renderMap();
                setTimeout(() => {
                    if (typeof initMap === 'function') initMap();
                }, 50);
            }
            break;
        case 'alerts':
            if (typeof renderAlerts === 'function') {
                pageContent.innerHTML = renderAlerts();
                setTimeout(() => {
                    if (typeof initAlerts === 'function') initAlerts();
                }, 50);
            }
            break;
        case 'reports':
            if (typeof renderReports === 'function') {
                pageContent.innerHTML = renderReports();
                setTimeout(() => {
                    if (typeof initReports === 'function') initReports();
                }, 50);
            }
            break;
        case 'assistant':
            if (typeof renderAssistant === 'function') {
                pageContent.innerHTML = renderAssistant();
                setTimeout(() => {
                    if (typeof initAssistant === 'function') initAssistant();
                }, 50);
            }
            break;
        case 'settings':
            if (typeof renderSettings === 'function') {
                pageContent.innerHTML = renderSettings();
                setTimeout(() => {
                    if (typeof initSettings === 'function') initSettings();
                }, 50);
            }
            break;
        default:
            if (typeof renderDashboard === 'function') {
                pageContent.innerHTML = renderDashboard();
                setTimeout(() => {
                    if (typeof initDashboard === 'function') initDashboard();
                }, 50);
            }
    }
    
    // Update active nav
    document.querySelectorAll('.nav-item').forEach(nav => {
        nav.classList.remove('active');
        if (nav.dataset.page === pageName) nav.classList.add('active');
    });
    
    document.querySelectorAll('.mobile-bottom-nav i').forEach(icon => {
        icon.style.color = 'var(--text-secondary)';
        if (icon.dataset.page === pageName) icon.style.color = 'var(--primary)';
    });
}

// ==================== TOPBAR ====================
function renderTopbar() {
    const topbar = document.getElementById('topbar');
    if (!topbar) return;
    
    topbar.innerHTML = `
        <div><i class="fas fa-bars" id="menuToggle" style="cursor:pointer; font-size:1.4rem;"></i></div>
        <div class="topbar-actions">
            <input type="text" placeholder="Search commodity..." id="searchInput" class="search-input">
            <button id="darkModeToggle" class="btn-primary"><i class="fas fa-moon"></i> Dark/Light</button>
        </div>
    `;
    
    const darkBtn = document.getElementById('darkModeToggle');
    if (darkBtn) darkBtn.addEventListener('click', toggleDarkMode);
    
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('input', (e) => {
            const query = e.target.value.toLowerCase();
            if (query.length > 1) {
                console.log(`Searching for: ${query}`);
            }
        });
    }
}

// ==================== MOBILE MENU ====================
function initMobileMenu() {
    const menuToggle = document.getElementById('menuToggle');
    const sidebar = document.getElementById('sidebar');
    
    if (menuToggle && sidebar) {
        menuToggle.addEventListener('click', () => {
            if (window.innerWidth < 768) {
                sidebar.classList.toggle('mobile-open');
            } else {
                document.querySelector('.main-content')?.classList.toggle('expanded');
                sidebar.classList.toggle('collapsed');
            }
        });
    }
}

// ==================== NAVIGATION ====================
function initNavigation() {
    // Desktop navigation
    document.querySelectorAll('.nav-item').forEach(item => {
        item.addEventListener('click', () => {
            const page = item.dataset.page;
            if (page) loadPage(page);
            // Close mobile sidebar if open
            const sidebar = document.getElementById('sidebar');
            if (window.innerWidth < 768 && sidebar) {
                sidebar.classList.remove('mobile-open');
            }
        });
    });
    
    // Mobile navigation
    document.querySelectorAll('.mobile-bottom-nav i').forEach(icon => {
        icon.addEventListener('click', () => {
            const page = icon.dataset.page;
            if (page) loadPage(page);
        });
    });
}

// ==================== CHECK DEPENDENCIES ====================
function checkDependencies() {
    const required = ['renderDashboard', 'initDashboard', 'renderSidebar', 'renderMobileNav'];
    const missing = required.filter(f => typeof window[f] === 'undefined');
    if (missing.length > 0) {
        console.warn('Missing dependencies:', missing);
        return false;
    }
    return true;
}

// ==================== INITIALIZATION ====================
function init() {
    // Render components
    const sidebar = document.getElementById('sidebar');
    const mobileNav = document.getElementById('mobileBottomNav');
    
    if (sidebar && typeof renderSidebar === 'function') {
        sidebar.innerHTML = renderSidebar();
    }
    
    if (mobileNav && typeof renderMobileNav === 'function') {
        mobileNav.innerHTML = renderMobileNav();
    }
    
    renderTopbar();
    initDarkMode();
    initNavigation();
    initMobileMenu();
    
    // Load default page
    loadPage('dashboard');
}

// Start the application
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}