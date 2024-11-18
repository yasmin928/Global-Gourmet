// Example form validation with smooth scrolling to invalid fields
function validateForm() {
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;
    const errorMessage = document.getElementById('error-message');

    if (username === "" || password === "") {
        errorMessage.innerText = "All fields must be filled out";
        errorMessage.style.display = "block";
        window.scrollTo({ top: 0, behavior: 'smooth' });
        return false;
    }
    errorMessage.style.display = "none";
    return true;
}

// Navigation toggle with smooth animation
function toggleNav() {
    const nav = document.getElementById('nav');
    nav.classList.toggle("responsive");
}

// Smoothly animate button color on hover
document.querySelectorAll(".button").forEach(button => {
    button.addEventListener("mouseover", () => {
        button.style.transition = "background-color 0.3s ease-in-out";
    });
    button.addEventListener("mouseout", () => {
        button.style.transition = "background-color 0.3s ease-in-out";
    });
});
// Example form validation
function validateForm() {
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;

    if (username === "" || password === "") {
        alert("All fields must be filled out");
        return false;
    }
    return true;
}

// Example navigation toggle (if you want to add a mobile menu later)
function toggleNav() {
    const nav = document.getElementById('nav');
    if (nav.className === "topnav") {
        nav.className += " responsive";
    } else {
        nav.className = "topnav";
    }
}


function searchById() {
    // Get the search input
    const input = document.getElementById('searchInput');
    const filter = input.value.toUpperCase();
    const table = document.getElementById('ordersTable');
    const tr = table.getElementsByTagName('tr');

    // Loop through all table rows, and hide those that don't match the search query
    for (let i = 1; i < tr.length; i++) { // Start from 1 to skip the header
        const td = tr[i].getElementsByTagName('td')[0]; // Search only in the first column (Order ID)
        if (td) {
            const txtValue = td.textContent || td.innerText;
            tr[i].style.display = txtValue.toUpperCase().indexOf(filter) > -1 ? "" : "none";
        }       
    }
}