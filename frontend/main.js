const API_URL = 'https://1nanbtwnm5.execute-api.us-east-1.amazonaws.com';

window.addEventListener('DOMContentLoaded', (event) => {
    getVisitCount();
});

const getVisitCount = () => {
    fetch(API_URL)
        .then(response => response.json())
        .then(data => {
            console.log("API Success:", data);
            document.getElementById('counter').innerText = data.count;
        })
        .catch(error => console.error("API Error:", error));
}