function background() {
    var body = document.getElementsByTagName("body")[0];
    var classes = ["colour", "mono", "white"];

    // `$.inArray(x, y)` gets the index of x in y
    // 1 is added, then `%classes.length` shifts 3 back to 0, so index 0 = 1, 1 = 2 and 2 = 0
    // the result is used as an index on the classes array
    body.className = classes[($.inArray(body.className, classes)+1)%classes.length]; 
}
