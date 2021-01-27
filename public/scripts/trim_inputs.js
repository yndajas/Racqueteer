// after loading the page, add onblur event listener to any text, textarea and password inputs
window.onload = function() {
    var inputs = document.querySelectorAll('input[type=text], textarea, input[type=password]');

    for (let input of inputs) {
        input.setAttribute("onblur", "trimValue(this)");
    }
}

// trim element onblur
function trimValue(element) {
    console.log(element.value);
    element.value = element.value.trim();
}