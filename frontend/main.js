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
    console.log("Localhost:", isLocalhost, "Already Visited:", !!hasVisited);
    
    // 3. The Guard: If testing locally OR they have visited, just "View"
    // Prevents local dev work from adding to total count
    let fetchUrl = API_URL;
    if (isLocalhost || hasVisited) {
        fetchUrl = `${API_URL}?action=view`;
    }

    try {
        const response = await fetch(fetchUrl);
        const data = await response.json();
        document.getElementById('counter').innerText = data.count;

        // ONLY set the flag if this was a fresh, non-localhost visit that successfully incremented
        if (!isLocalhost && !hasVisited) {
            localStorage.setItem('resume_visited', 'true');
            console.log("First time visitor! Flag set in localStorage.");
        }
    } catch (error) {
        console.error("API Error:", error);
    }
}