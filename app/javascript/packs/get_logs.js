function getLogs() {
    fetch('http://127.0.0.1:3000/logs')
        .then(response => response.json())
        .then(json => {
            document.getElementById('log_notes').value = json['data'].join('\n');
        })
}

getLogs();
setInterval(getLogs, 5000);
