function extraRacquet() {
    // get all divs with class "new_racquet"
    var new_racquet_divs = document.getElementsByClassName("new_racquet");
    // get the last one
    var last_nrd = new_racquet_divs[new_racquet_divs.length -1];
    // work out what number should be in the next div and its child's IDs
    var next_id_number = parseInt(last_nrd.id.slice(-1)) + 1;
    // clone div
    var new_div = last_nrd.cloneNode(true); // check what true does - might copy input values
    // change ID to "new_racquet" + next_id_number
    new_div.id = new_div.id.slice(0, -1) + next_id_number;
    // find form
    var form = document.getElementsByTagName("form")[0];
    // insert 
    form.insertBefore(new_div, last_nrd.nextSibling);
    // get children of new div with class "new_racquet_child"
    var children = document.getElementById("new_racquet_" + next_id_number).querySelectorAll(":scope > .new_racquet_child");
    // iterate over children, changing their IDs
    for (let child of children) {
        if (child.nodeName === "LABEL") {
            // update for
            child.setAttribute("for", child.getAttribute("for").slice(0, -1) + next_id_number);
        } else if (child.nodeName === "INPUT") {
            // reset value
            child.value = "";
            // update ID
            child.id = child.id.slice(0, -1) + next_id_number;
            // update list
            child.setAttribute("list", child.getAttribute("list").slice(0, -1) + next_id_number);
        } else { // datalist
            // update ID
            child.id = child.id.slice(0, -1) + next_id_number;              
        }
    }

    // add a hr before the new div
    var new_hr = document.createElement("hr");
    form.insertBefore(new_hr, new_div);
}