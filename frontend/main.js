window.addEventListener('DOMContentLoaded', (event) => {
    getVisitCount();
});

const apiApiGateway = ''; // WE WILL PASTE THE API URL HERE IN PHASE 5

const getVisitCount = () => {
    let count = 30; // Default fallback for now
    fetch(apiApiGateway)
        .then(response => {
            return response.json()
        })
        .then(response => {
            console.log("Website called function. API returned: ", response);
            count = response.count;
            document.getElementById('counter').innerText = count;
        }).catch(function (error) {
            console.log(error);
            document.getElementById('counter').innerText = "Running Locally";
        });
    return count;
}