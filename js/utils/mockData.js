// Mock Data untuk seluruh aplikasi
const KPI_DATA = {
    total: { value: 24, change: "+3.2%", trend: "up", sparkline: [22, 23, 24, 23.5, 24] },
    rising: { value: 8, change: "+1.4%", trend: "up", sparkline: [6, 7, 7.5, 8, 8.2] },
    falling: { value: 5, change: "-0.9%", trend: "down", sparkline: [6, 5.5, 5.2, 5, 4.8] },
    accuracy: { value: "94.2%", change: "+2.1%", trend: "up", sparkline: [91, 92, 93, 94, 94.2] }
};

const TRENDING_COMMODITIES = [
    { name: "Rice", price: "Rp 14,250", change: "+2.3%", up: true, sparkline: [12, 13, 14, 13.5, 14.2] },
    { name: "Chili", price: "Rp 38,500", change: "+5.1%", up: true, sparkline: [35, 36, 38, 37, 38.5] },
    { name: "Shallots", price: "Rp 28,000", change: "-1.2%", up: false, sparkline: [29, 28.5, 28, 27.8, 28] },
    { name: "Cooking Oil", price: "Rp 18,200", change: "-0.5%", up: false, sparkline: [18.5, 18.3, 18.2, 18.1, 18.2] },
    { name: "Sugar", price: "Rp 15,800", change: "+0.8%", up: true, sparkline: [15.6, 15.7, 15.75, 15.8, 15.82] }
];

const SUB_COMMODITIES = {
    "Premium Rice": { price: 15200, data: [13500, 14000, 14500, 15000, 15200] },
    "Medium Rice": { price: 13800, data: [12500, 12800, 13200, 13500, 13800] },
    "IR64 Rice": { price: 12900, data: [11800, 12100, 12400, 12700, 12900] },
    "Pandan Wangi Rice": { price: 16500, data: [14800, 15200, 15600, 16000, 16500] }
};

const MENU_ITEMS = [
    { page: "dashboard", icon: "fa-tachometer-alt", label: "Dashboard" },
    { page: "commodities", icon: "fa-boxes", label: "Commodities" },
    { page: "forecast", icon: "fa-chart-line", label: "AI Forecast" },
    { page: "insights", icon: "fa-newspaper", label: "Market Insights" },
    { page: "map", icon: "fa-map-marked-alt", label: "Indonesia Price Map" },
    { page: "alerts", icon: "fa-bell", label: "Price Alerts" },
    { page: "reports", icon: "fa-file-alt", label: "Reports" },
    { page: "assistant", icon: "fa-robot", label: "AI Assistant" },
    { page: "settings", icon: "fa-cog", label: "Settings" }
];