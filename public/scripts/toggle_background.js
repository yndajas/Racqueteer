// if a cookie with a background preference exist, set the body class accoridngly
var background_preference = document.cookie.match(new RegExp('(^| )' + "background" + '=([^;]+)'));
if (background_preference) {
    document.getElementsByTagName("body")[0].className = background_preference[2];
}

function toggleBackground() {
    var body = document.getElementsByTagName("body")[0];
    var classes = ["colour", "mono", "white"];

    // `$.inArray(x, y)` gets the index of x in y
    // 1 is added, then `%classes.length` shifts 3 back to 0, so index 0 = 1, 1 = 2 and 2 = 0
    // the result is used as an index on the classes array
    var new_background_preference = classes[($.inArray(body.className, classes)+1)%classes.length];
    // update body class
    body.className = new_background_preference;
    // save/update background preference in a cookie
    document.cookie = "background=" + new_background_preference;
}
