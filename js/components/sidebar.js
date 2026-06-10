// Sidebar Component
function renderSidebar() {
    return `
        <div class="logo">⚡ ARJUNA AI</div>
        <nav>
            ${MENU_ITEMS.map(item => `
                <div class="nav-item" data-page="${item.page}">
                    <i class="fas ${item.icon}"></i> ${item.label}
                </div>
            `).join('')}
        </nav>
    `;
}