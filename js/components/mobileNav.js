// Mobile Bottom Navigation Component
function renderMobileNav() {
    const mobileItems = MENU_ITEMS.slice(0, 5);
    return mobileItems.map(item => `
        <i class="fas ${item.icon}" data-page="${item.page}"></i>
    `).join('');
}