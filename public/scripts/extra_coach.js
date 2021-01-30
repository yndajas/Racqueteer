function extraCoach() {
    // get all inputs with class "new_coach"
    var new_coach_inputs = document.getElementsByClassName("new_coach");
    // get the last one
    var last_nci = new_coach_inputs[new_coach_inputs.length -1];
    // work out what number should be in the next input
    var next_id_number = parseInt(last_nci.id.slice(-1)) + 1;
    // clone input
    var new_input = last_nci.cloneNode(false);
    // change ID to "new_coach" + next_id_number
    new_input.id = new_input.id.slice(0, -1) + next_id_number;
    // find form
    var form = document.getElementsByTagName("form")[0];
    // insert 
    form.insertBefore(new_input, last_nci.nextSibling);

    // add two brs before the new div
    for (let i = 0; i < 2; i++) {
        var new_br = document.createElement("br");
        form.insertBefore(new_br, new_input);
    }
}