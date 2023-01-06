let menuIcon = document.querySelector('.menuIcon');
let nav = document.querySelector('.overlay-menu');

var navbar = document.getElementById("menu");
var btns = navbar.getElementsByClassName("btn");
var ovBtns = nav.getElementsByClassName("btn");
var overlay = document.getElementsByClassName("over");

var homeBtn = document.getElementsByClassName("home-btn");
var home = navbar.getElementsByClassName("home");
var ovHome = nav.getElementsByClassName("home");

homeBtn[0].addEventListener("click", function () {
    var actb1 = navbar.getElementsByClassName("active");
    var actb2 = nav.getElementsByClassName("active");
    actb1[0].className = actb1[0].className.replace(" active", "");
    actb2[0].className = actb2[0].className.replace(" active", "");
    home[0].className += " active";
    ovHome[0].className += " active";
});

for (var i = 0; i < btns.length; i++) {
    btns[i].addEventListener("click", function () {
        var actv1 = navbar.getElementsByClassName("active");
        actv1[0].className = actv1[0].className.replace(" active", "");
        this.className += " active";
    });
}

for (var j = 0; j < ovBtns.length; j++) {
    ovBtns[j].addEventListener("click", function () {
        var actv2 = nav.getElementsByClassName("active");
        actv2[0].className = actv2[0].className.replace(" active", "");
        this.className += " active";
    });
}

for (var k = 0; k < overlay.length; k++) {
    overlay[k].addEventListener("click", function () {
        var current1 = document.querySelector('.overlay-menu');
        var current2 = document.querySelector('.menuIcon');
        current1.style.transform = 'translateY(-100%)';
        current1.style.transition = 'transform 0.2s ease-out';
        current2.className = 'menuIcon';
    });
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

const mediaQuery = window.matchMedia('(max-width: 480px)');
let slides = document.getElementsByClassName("img-container");
let slidesCount = new Array(slides.length);
let maxLeft = new Array(slides.length);
let maxLeft2 = new Array(slides.length);
let current = new Array(slides.length);
for (let ss = 0; ss < slides.length; ss++) {
    slidesCount[ss] = slides[ss].childElementCount;
    maxLeft[ss] = (slidesCount[ss] - 1) * 414 * -1;
    maxLeft2[ss] = (slidesCount[ss] - 1) * 264 * -1;
    current[ss] = 0;
}
function changeSlide(button, owo) {
    if (mediaQuery.matches) {
        if (button) {
            current[owo] += current[owo] > maxLeft2[owo] ? -264 : current[owo] * -1;
        } else {
            current[owo] = current[owo] < 0 ? current[owo] + 264 : maxLeft2[owo];
        }
        slides[owo].style.left = (24 + current[owo]) + "px";
    } else {
        if (button) {
            current[owo] += current[owo] > maxLeft[owo] ? -414 : current[owo] * -1;
        } else {
            current[owo] = current[owo] < 0 ? current[owo] + 414 : maxLeft[owo];
        }
        slides[owo].style.left = (32 + current[owo]) + "px";
    }
}
let next = document.getElementsByClassName("next");
let prev = document.getElementsByClassName("prev");
for (let nn = 0; nn < next.length; nn++) {
    next[nn].addEventListener("click", function () {
        changeSlide(true, nn);
    });
}
for (let pp = 0; pp < prev.length; pp++) {
    prev[pp].addEventListener("click", function () {
        changeSlide(false, pp);
    });
}