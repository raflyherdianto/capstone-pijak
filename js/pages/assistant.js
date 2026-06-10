// AI Assistant Page
let chatHistory = [];

function renderAssistant() {
    return `
        <div class="card chat-container">
            <h2>🤖 AI Assistant</h2>
            <div class="chat-messages" id="chatMessages">
                <div class="chat-message bot">👋 Hello! I'm Arjuna AI. Ask me about commodity prices, forecasts, or trading recommendations.</div>
                ${chatHistory.map(msg => `
                    <div class="chat-message ${msg.type}">${msg.content}</div>
                `).join('')}
            </div>
            <div class="chat-input-area">
                <input type="text" class="chat-input" id="chatInput" placeholder="Ask anything...">
                <button class="btn-primary" id="sendChatBtn"><i class="fas fa-paper-plane"></i> Send</button>
            </div>
            <div class="suggested-prompts">
                <span class="suggested-prompt" data-prompt="What is the predicted rice price next week?">📈 Rice price next week?</span>
                <span class="suggested-prompt" data-prompt="Should I buy chili today?">🌶️ Buy chili today?</span>
                <span class="suggested-prompt" data-prompt="What commodities are expected to rise this month?">📊 Rising commodities</span>
                <span class="suggested-prompt" data-prompt="Compare rice and sugar prices">⚖️ Compare commodities</span>
                <span class="suggested-prompt" data-prompt="What is the best time to sell shallots?">🧅 Sell shallots?</span>
            </div>
        </div>
    `;
}

function sendChatMessage(message) {
    const messagesContainer = document.getElementById('chatMessages');
    
    // Add user message
    const userMsgDiv = document.createElement('div');
    userMsgDiv.className = 'chat-message user';
    userMsgDiv.textContent = message;
    messagesContainer.appendChild(userMsgDiv);
    chatHistory.push({ type: 'user', content: message });
    
    // Generate bot response
    setTimeout(() => {
        let botResponse = "";
        
        if (message.toLowerCase().includes('rice')) {
            botResponse = "📊 Based on AI analysis, rice prices are predicted to increase by 5.2% over the next week due to supply constraints. Current price: Rp 14,250/kg. Recommendation: Wait for buying. Confidence: 87%";
        } 
        else if (message.toLowerCase().includes('chili')) {
            botResponse = "🌶️ Chili prices are currently at Rp 38,500/kg with an upward trend. Our forecast suggests a +3% increase in the coming days. Sellers may consider selling now. Probability: 76%";
        }
        else if (message.toLowerCase().includes('sugar')) {
            botResponse = "🍬 Sugar is currently at Rp 15,800/kg, showing a slight upward trend (+0.8%). Due to upcoming harvest season, prices may stabilize. Recommendation: Hold for now.";
        }
        else if (message.toLowerCase().includes('compare')) {
            botResponse = "📊 Price Comparison:\n• Rice: Rp 14,250/kg (+2.3%)\n• Sugar: Rp 15,800/kg (+0.8%)\n• Chili: Rp 38,500/kg (+5.1%)\n• Cooking Oil: Rp 18,200/kg (-0.5%)\n• Shallots: Rp 28,000/kg (-1.2%)";
        }
        else {
            botResponse = "🤖 I'm analyzing the market data... Based on current trends, commodities showing strength are Rice (+2.3%) and Shallots (+4.2%). The AI forecast suggests buying pressure will continue for the next 7 days. Would you like specific price predictions for any commodity?";
        }
        
        const botMsgDiv = document.createElement('div');
        botMsgDiv.className = 'chat-message bot';
        botMsgDiv.textContent = botResponse;
        messagesContainer.appendChild(botMsgDiv);
        chatHistory.push({ type: 'bot', content: botResponse });
        messagesContainer.scrollTop = messagesContainer.scrollHeight;
    }, 500);
    
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
}

function initAssistant() {
    const sendBtn = document.getElementById('sendChatBtn');
    const chatInput = document.getElementById('chatInput');
    
    sendBtn?.addEventListener('click', () => {
        const message = chatInput.value.trim();
        if (message) {
            sendChatMessage(message);
            chatInput.value = '';
        }
    });
    
    chatInput?.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
            const message = chatInput.value.trim();
            if (message) {
                sendChatMessage(message);
                chatInput.value = '';
            }
        }
    });
    
    document.querySelectorAll('.suggested-prompt').forEach(prompt => {
        prompt.addEventListener('click', () => {
            sendChatMessage(prompt.dataset.prompt);
        });
    });
}