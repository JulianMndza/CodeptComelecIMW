var sidebar = document.getElementById("menu");
var btns = sidebar.getElementsByClassName("btn");
let menuIcon = document.querySelector('.menuIcon');
let nav = document.querySelector('.overlay-menu');

for (var i = 0; i < btns.length; i++) {
    btns[i].addEventListener("click", function () {
        var current = sidebar.getElementsByClassName("active");
        current[0].className = current[0].className.replace(" active", "");
        this.className += " active";
    });
}

try {
    function myFunction() {
        document.getElementById("dropdown").classList.toggle("show");
    }
} catch (err) {

}

try {
    window.onclick = function (e) {
        if (!e.target.matches('.dropbtn')) {
            var dropdown = document.getElementById("dropdown");
            if (dropdown.classList.contains('show')) {
                dropdown.classList.remove('show');
            }
        }
    }
} catch (err) {

}

function reset() {
    document.getElementById("unit").selectedIndex = 0;
}

try {
    $('.unit-content').hide();
    $('#unit-1').show();
    $('#unit').change(function () {
        dropdown = $('#unit').val();
        $('.unit-content').hide();
        $('#' + "unit-" + dropdown).show();
    });
} catch (err) {

}

menuIcon.addEventListener('click', () => {
    if (nav.style.transform != 'translateY(0%)') {
        nav.style.transform = 'translateY(0%)';
        nav.style.transition = 'transform 0.2s ease-out';
    } else {
        nav.style.transform = 'translateY(-100%)';
        nav.style.transition = 'transform 0.2s ease-out';
    }
});

menuIcon.addEventListener('click', () => {
    if (menuIcon.className != 'menuIcon toggle') {
        menuIcon.className += ' toggle';
    } else {
        menuIcon.className = 'menuIcon';
    }
});

function test() {
  alert("Processing Request...");
}
