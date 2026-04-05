// --- CONFIGURATION ---
const API_URL = 'https://1nanbtwnm5.execute-api.us-east-1.amazonaws.com'; // **PASTE YOUR API URL HERE**

// --- LOGIC ---
window.addEventListener('DOMContentLoaded', (event) => {
    handleVisitorCount();
});

const handleVisitorCount = async () => {
    // 1. Check if testing locally
    const isLocalhost = window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1';
    
    // 2. Check localStorage
    const hasVisited = localStorage.getItem('resume_visited');
    
    // 3. The Guard: If testing locally OR they have visited, just "View"
    // Prevents local dev work from adding to total count
    let fetchUrl = API_URL;
    if (isLocalhost || hasVisited) {
        fetchUrl = `${API_URL}?action=view`;
    }

    // 4. Pre-emptive Strike: If this is a real visitor, set the flag IMMEDIATELY
    // Don't wait for the fetch to succeed. This kills the race condition.
    if (!isLocalhost && !hasVisited) {
        localStorage.setItem('resume_visited', 'true');
    }

    try {
        const response = await fetch(fetchUrl);
        const data = await response.json();
        document.getElementById('counter').innerText = data.count;
    } catch (error) {
        console.error("API Error:", error);
        document.getElementById('counter').innerText = "Unvailable";
    }
}