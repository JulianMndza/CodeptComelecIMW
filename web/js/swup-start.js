
const swup = new Swup();

swup.on('contentReplaced', (e) => {
    twttr.widgets.load();

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
});