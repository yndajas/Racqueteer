function validateCoaches() {
    // get existing coach inputs
    var existing_coaches = document.getElementsByClassName("existing_coach_checkbox");
    // iterate over existing coach inputs
    for (let ec of existing_coaches) {
        // if checked, return true
        if (ec.checked) {
            return true;
        }
    }
    // get new coach inputs
    var new_coach_inputs = document.getElementsByClassName("new_coach");
    // iterate over new coach inputs
    for (let nc of new_coach_inputs) {
        // if it contains a value, return true
        if (nc.value.length > 0) {
            return true;
        }
    }
    // return false if no coach provided
    alert("Please select an existing coach or add a new one");
    return false;
}

$('#coaching_session_form').on('submit', function(event){
    if (!validateCoaches()){
        event.preventDefault();
    }
});