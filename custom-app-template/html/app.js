// Function to toggle lock/unlock
function toggleLockUnlock() {
    var lockUnlockButton = document.getElementById('lockUnlockButton');
    $.post('https://custom-app-template/doorLock');
}

// Function to handle impact on a door
function impactOnDoor(doorType) {
    $.post('https://custom-app-template/doorToggle', JSON.stringify({ door: doorType }));
}

// Function to handle impact on a window
function impactOnWindow(windowType, doorType) {
    $.post('https://custom-app-template/windowToggle', JSON.stringify({ window: windowType, door: doorType }));
}

// Function to handle impact on a seat
function impactOnSeat(seatType) {
    $.post('https://custom-app-template/changeSeat', JSON.stringify({ seat: seatType }));
}


// Function to show door buttons
function showDoorButtons() {
    var doorsButtons = document.getElementById('doorsButtons');
    var windowsButtons = document.getElementById('windowsButtons');
    var seatsButtons = document.getElementById('seatsButtons');

    // Show doorsButtons and hide others
    doorsButtons.style.display = 'flex';
    windowsButtons.style.display = 'none';
    seatsButtons.style.display = 'none';
}

// Function to show window buttons
function showWindowButtons() {
    var doorsButtons = document.getElementById('doorsButtons');
    var windowsButtons = document.getElementById('windowsButtons');
    var seatsButtons = document.getElementById('seatsButtons');

    // Show windowsButtons and hide others
    doorsButtons.style.display = 'none';
    windowsButtons.style.display = 'flex';
    seatsButtons.style.display = 'none';
}

// Function to show seat buttons
function showSeatButtons() {
    var doorsButtons = document.getElementById('doorsButtons');
    var windowsButtons = document.getElementById('windowsButtons');
    var seatsButtons = document.getElementById('seatsButtons');

    // Show seatsButtons and hide others
    doorsButtons.style.display = 'none';
    windowsButtons.style.display = 'none';
    seatsButtons.style.display = 'flex';
}

// Function to go back to the home view
function backToHome() {
    // Hide all sub-menus and home bar
    var doorsButtons = document.getElementById('doorsButtons');
    var windowsButtons = document.getElementById('windowsButtons');
    var seatsButtons = document.getElementById('seatsButtons');

    // Hide all sub-menus and home bar
    doorsButtons.style.display = 'none';
    windowsButtons.style.display = 'none';
    seatsButtons.style.display = 'none';
}
