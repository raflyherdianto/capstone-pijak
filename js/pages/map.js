// Indonesia Price Map Page with Leaflet.js

const INDONESIA_PROVINCES = [
    "All Provinces",
    "Aceh", "Bali", "Banten", "Bengkulu", "Gorontalo", "DKI Jakarta",
    "Jambi", "Jawa Barat", "Jawa Tengah", "Jawa Timur",
    "Kalimantan Barat", "Kalimantan Selatan", "Kalimantan Tengah", "Kalimantan Timur", "Kalimantan Utara",
    "Kepulauan Bangka Belitung", "Kepulauan Riau", "Lampung",
    "Maluku", "Maluku Utara",
    "Nusa Tenggara Barat", "Nusa Tenggara Timur",
    "Papua", "Papua Barat", "Papua Barat Daya", "Papua Pegunungan", "Papua Selatan", "Papua Tengah",
    "Riau", "Sulawesi Barat", "Sulawesi Selatan", "Sulawesi Tengah", "Sulawesi Tenggara", "Sulawesi Utara",
    "Sumatera Barat", "Sumatera Selatan", "Sumatera Utara"
];

const PROVINCE_COMMODITY_DATA = {
    // Sumatra region
    "Aceh": { rice: 14800, chili: 39800, shallots: 29200, oil: 19100, center: [5.0, 95.3] },
    "Sumatera Utara": { rice: 14300, chili: 38800, shallots: 28500, oil: 18600, center: [3.0, 100.0] },
    "Sumatera Barat": { rice: 14100, chili: 38500, shallots: 28200, oil: 18400, center: [-0.5, 100.5] },
    "Riau": { rice: 14200, chili: 38600, shallots: 28300, oil: 18500, center: [1.0, 101.5] },
    "Jambi": { rice: 13900, chili: 38100, shallots: 28000, oil: 18250, center: [-1.5, 103.0] },
    "Sumatera Selatan": { rice: 13700, chili: 37400, shallots: 27100, oil: 17950, center: [-3.5, 103.5] },
    "Lampung": { rice: 13600, chili: 37200, shallots: 26900, oil: 17800, center: [-5.0, 104.8] },
    "Kepulauan Bangka Belitung": { rice: 14500, chili: 39200, shallots: 28900, oil: 18800, center: [-2.5, 107.0] },
    "Kepulauan Riau": { rice: 14700, chili: 39500, shallots: 29000, oil: 19000, center: [0.5, 104.5] },
    
    // Java region
    "DKI Jakarta": { rice: 14200, chili: 38200, shallots: 27800, oil: 18300, center: [-6.2, 106.8] },
    "Jawa Barat": { rice: 13800, chili: 37500, shallots: 27200, oil: 18100, center: [-6.8, 107.5] },
    "Jawa Tengah": { rice: 13600, chili: 37200, shallots: 26900, oil: 17900, center: [-7.5, 110.2] },
    "Jawa Timur": { rice: 13900, chili: 38000, shallots: 27600, oil: 18200, center: [-7.2, 112.7] },
    "Banten": { rice: 13850, chili: 37800, shallots: 27400, oil: 18150, center: [-6.0, 105.5] },
    
    // Kalimantan region
    "Kalimantan Barat": { rice: 14400, chili: 39000, shallots: 28700, oil: 18700, center: [-0.2, 109.3] },
    "Kalimantan Tengah": { rice: 14600, chili: 39400, shallots: 29000, oil: 18900, center: [-1.5, 113.0] },
    "Kalimantan Selatan": { rice: 14300, chili: 39100, shallots: 28800, oil: 18750, center: [-3.5, 114.5] },
    "Kalimantan Timur": { rice: 14500, chili: 39200, shallots: 28900, oil: 18850, center: [0.5, 116.0] },
    "Kalimantan Utara": { rice: 14700, chili: 39600, shallots: 29200, oil: 19050, center: [2.5, 115.0] },
    
    // Sulawesi region
    "Sulawesi Utara": { rice: 14600, chili: 39400, shallots: 29100, oil: 18950, center: [1.5, 124.5] },
    "Sulawesi Tengah": { rice: 14400, chili: 39000, shallots: 28700, oil: 18700, center: [-1.0, 121.0] },
    "Sulawesi Barat": { rice: 14300, chili: 38900, shallots: 28600, oil: 18650, center: [-2.0, 119.0] },
    "Sulawesi Selatan": { rice: 14200, chili: 38100, shallots: 28000, oil: 18350, center: [-5.0, 120.0] },
    "Sulawesi Tenggara": { rice: 14350, chili: 38700, shallots: 28400, oil: 18550, center: [-4.0, 123.0] },
    "Gorontalo": { rice: 14500, chili: 39100, shallots: 28800, oil: 18800, center: [0.5, 122.5] },
    
    // Nusa Tenggara region
    "Bali": { rice: 13500, chili: 37000, shallots: 26800, oil: 17850, center: [-8.6, 115.2] },
    "Nusa Tenggara Barat": { rice: 13700, chili: 37300, shallots: 27000, oil: 17900, center: [-8.5, 117.0] },
    "Nusa Tenggara Timur": { rice: 13900, chili: 37600, shallots: 27200, oil: 18050, center: [-8.5, 121.0] },
    
    // Maluku region
    "Maluku": { rice: 15200, chili: 40200, shallots: 29500, oil: 19300, center: [-3.2, 127.5] },
    "Maluku Utara": { rice: 15350, chili: 40400, shallots: 29700, oil: 19450, center: [0.5, 127.5] },
    
    // Papua region
    "Papua": { rice: 15600, chili: 41000, shallots: 30200, oil: 19800, center: [-4.0, 138.0] },
    "Papua Barat": { rice: 15700, chili: 41100, shallots: 30300, oil: 19900, center: [-2.0, 133.0] },
    "Papua Barat Daya": { rice: 15800, chili: 41300, shallots: 30500, oil: 20050, center: [-3.0, 131.0] },
    "Papua Pegunungan": { rice: 16000, chili: 41600, shallots: 30800, oil: 20250, center: [-5.0, 139.0] },
    "Papua Selatan": { rice: 15850, chili: 41400, shallots: 30600, oil: 20150, center: [-8.0, 135.0] },
    "Papua Tengah": { rice: 15900, chili: 41500, shallots: 30700, oil: 20200, center: [-4.5, 137.0] }
};

let map;
let geoJsonLayer;
let selectedProvinceName = 'All Provinces';
let selectedCommodity = 'rice';

function renderMap() {
    const provinceOptions = INDONESIA_PROVINCES.map(province => `
        <option value="${province}">${province}</option>
    `).join('');

    return `
        <div class="card map-header-card">
            <div class="map-title-section">
                <h2>Indonesia Commodity Price Map</h2>
                <p>Visualisasi harga komoditas di seluruh Indonesia berdasarkan wilayah geografis. Warna lebih hijau = harga lebih murah, warna lebih merah = harga lebih mahal.</p>
            </div>
            <div class="map-controls">
                <div class="control-group">
                    <label for="commodityFilterMap">Commodity</label>
                    <select id="commodityFilterMap" class="select-box">
                        <option value="rice">Rice</option>
                        <option value="chili">Chili</option>
                        <option value="shallots">Shallots</option>
                        <option value="oil">Cooking Oil</option>
                    </select>
                </div>
                <div class="control-group">
                    <label for="provinceFilterMap">Province Filter</label>
                    <select id="provinceFilterMap" class="select-box">
                        ${provinceOptions}
                    </select>
                </div>
            </div>
        </div>

        <div class="card map-container">
            <div id="mapVisualization" class="map-visualization-leaflet"></div>
            <div class="map-legend">
                <div class="legend-title">Price Legend</div>
                <div class="legend-item">
                    <span class="legend-color" style="background: #10B981;"></span>
                    <span>Low price</span>
                </div>
                <div class="legend-item">
                    <span class="legend-color" style="background: #84CC16;"></span>
                    <span>Low-Moderate</span>
                </div>
                <div class="legend-item">
                    <span class="legend-color" style="background: #F59E0B;"></span>
                    <span>Moderate price</span>
                </div>
                <div class="legend-item">
                    <span class="legend-color" style="background: #EF7C3A;"></span>
                    <span>Moderate-High</span>
                </div>
                <div class="legend-item">
                    <span class="legend-color" style="background: #EF4444;"></span>
                    <span>High price</span>
                </div>
            </div>
        </div>

        <div class="card map-details-card">
            <h3>Province Information</h3>
            <div id="provinceDetails" class="province-details-grid">
                <p style="color: var(--text-secondary);">Click on a province on the map to view detailed commodity prices</p>
            </div>
        </div>
    `;
}

function getPriceColor(price, commodity) {
    const priceRanges = {
        rice: { low: 12000, high: 16000 },
        chili: { low: 35000, high: 41600 },
        shallots: { low: 26000, high: 30800 },
        oil: { low: 17500, high: 20250 }
    };

    const range = priceRanges[commodity] || priceRanges.rice;
    const ratio = (price - range.low) / (range.high - range.low);

    if (ratio < 0.1) return '#10B981';      // Green
    if (ratio < 0.3) return '#84CC16';      // Light green
    if (ratio < 0.5) return '#F59E0B';      // Yellow
    if (ratio < 0.75) return '#EF7C3A';     // Orange
    return '#EF4444';                        // Red
}

function createProvinceCircle(provinceName, lat, lng, price, commodity) {
    const color = getPriceColor(price, commodity);
    const radius = 50000 + (price / 100);
    
    const circle = L.circle([lat, lng], {
        color: color,
        fill: true,
        fillColor: color,
        fillOpacity: 0.8,
        weight: 2,
        radius: radius,
        opacity: 0.8
    });

    const popup = `
        <div class="map-popup">
            <strong>${provinceName}</strong><br>
            ${commodity.charAt(0).toUpperCase() + commodity.slice(1)}: ${formatRupiah(price)}<br>
            <small>Click to view all commodities</small>
        </div>
    `;

    circle.bindPopup(popup);
    circle.on('click', () => {
        if (provinceName !== selectedProvinceName) {
            selectedProvinceName = provinceName;
            document.getElementById('provinceFilterMap').value = provinceName;
            updateMapVisualization(provinceName, selectedCommodity);
            updateProvinceDetails(provinceName);
        }
    });

    return circle;
}

function initializeMap() {
    const mapContainer = document.getElementById('mapVisualization');
    if (!mapContainer) return;

    // Initialize map centered on Indonesia
    if (map) {
        map.remove();
    }

    map = L.map('mapVisualization').setView([-2.0, 113.5], 5);

    // Add tile layer (OpenStreetMap)
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '© OpenStreetMap contributors',
        maxZoom: 19,
        minZoom: 4,
        opacity: 0.8
    }).addTo(map);

    // Render province circles
    if (geoJsonLayer) {
        map.removeLayer(geoJsonLayer);
    }

    const featureGroup = L.featureGroup();

    Object.entries(PROVINCE_COMMODITY_DATA).forEach(([province, data]) => {
        const price = data[selectedCommodity];
        const [lat, lng] = data.center;
        const circle = createProvinceCircle(province, lat, lng, price, selectedCommodity);
        featureGroup.addLayer(circle);
    });

    featureGroup.addTo(map);
    geoJsonLayer = featureGroup;
}

function updateMapVisualization(province = 'All Provinces', commodity = 'rice') {
    selectedProvinceName = province;
    selectedCommodity = commodity;

    // Re-render map with new commodity
    initializeMap();

    // If specific province selected, zoom to it
    if (province !== 'All Provinces' && PROVINCE_COMMODITY_DATA[province]) {
        const data = PROVINCE_COMMODITY_DATA[province];
        map.setView(data.center, 8);
    }
}

function updateProvinceDetails(provinceName) {
    const detailsDiv = document.getElementById('provinceDetails');
    
    if (provinceName === 'All Provinces') {
        detailsDiv.innerHTML = '<p style="color: var(--text-secondary);">Click on a province on the map to view detailed commodity prices</p>';
        return;
    }

    const priceData = PROVINCE_COMMODITY_DATA[provinceName];
    if (!priceData) return;

    const detailsHtml = `
        <div class="price-info-item">
            <span class="commodity-name">Rice</span>
            <span class="commodity-price">${formatRupiah(priceData.rice)}</span>
        </div>
        <div class="price-info-item">
            <span class="commodity-name">Chili</span>
            <span class="commodity-price">${formatRupiah(priceData.chili)}</span>
        </div>
        <div class="price-info-item">
            <span class="commodity-name">Shallots</span>
            <span class="commodity-price">${formatRupiah(priceData.shallots)}</span>
        </div>
        <div class="price-info-item">
            <span class="commodity-name">Cooking Oil</span>
            <span class="commodity-price">${formatRupiah(priceData.oil)}</span>
        </div>
    `;

    detailsDiv.innerHTML = detailsHtml;
}

function initMap() {
    setTimeout(() => {
        initializeMap();

        document.getElementById('commodityFilterMap')?.addEventListener('change', (e) => {
            selectedCommodity = e.target.value;
            updateMapVisualization(selectedProvinceName, selectedCommodity);
        });

        document.getElementById('provinceFilterMap')?.addEventListener('change', (e) => {
            selectedProvinceName = e.target.value;
            updateMapVisualization(selectedProvinceName, selectedCommodity);
            updateProvinceDetails(selectedProvinceName);
        });
    }, 100);
}
