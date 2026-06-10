// Helper functions
function formatRupiah(value) {
    return "Rp " + value.toLocaleString("id-ID");
}

function formatNumber(value) {
    return value.toLocaleString("id-ID");
}

function showNotification(message, type = "info") {
    alert(message);
}

function getRandomPrice(base, variance = 500) {
    return base + (Math.random() - 0.5) * variance;
}

window.formatRupiah = function(value) {
    return "Rp " + value.toLocaleString("id-ID");
};