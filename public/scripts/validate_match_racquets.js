function validateMatchRacquets() {
    // get new racquet divs
    var new_racquet_divs = document.getElementsByClassName("new_racquet");
    if (validateNewRacquets(new_racquet_divs)) {
        if (validateRacquetProvided(new_racquet_divs)) {
            return true;
        } else {
            // if no racquet provided, send alert and return false
            alert("Please select an existing racquet or add a new one");
            return false;
        }
    } else { // if partial information provided on a new racquet, send alert and return false
        alert("Please complete all (or no) fields for new racquets");
        return false;
    }
}

function validateNewRacquets(new_racquet_divs) {
    // iterate over new racquet inputs as many times as there are new racquet divs
    for (let i = 0; i < new_racquet_divs.length; i++) {
        // for each new racquet, check if any of its inputs have values
        if (document.getElementById("frame_brand_" + (i + 1)).value.length > 0 || document.getElementById("frame_model_" + (i + 1)).value.length > 0 || document.getElementById("string_brand_" + (i + 1)).value.length > 0 || document.getElementById("string_model_" + (i + 1)).value.length > 0) {
            // if they do, check if any of its inputs *don't* have values
            if (!(document.getElementById("frame_brand_" + (i + 1)).value.length > 0 && document.getElementById("frame_model_" + (i + 1)).value.length > 0 && document.getElementById("string_brand_" + (i + 1)).value.length > 0 && document.getElementById("string_model_" + (i + 1)).value.length > 0)) {
                // if so, return false
                return false;
            }
        }
    }
    return true;
}

function validateRacquetProvided(new_racquet_divs) {
    // get existing racquet checkboxes
    var existing_racquets = document.getElementsByClassName("existing_racquet_checkbox");
    // iterate over existing racket checkboxes
    for (let er of existing_racquets) {
        // if checked, return true
        if (er.checked) {
            return true;
        }
    }
    // iterate over frame_brands
    for (let i = 0; i < new_racquet_divs.length; i++) {
        // for each new racquet, check if the frame_brand has a value
        if (document.getElementById("frame_brand_" + (i + 1)).value.length > 0) {
            return true;
        }
    }    
    // return false if incomplete racquet information
    return false;
}
  
$('#match_form').on('submit', function(event){
    if (!validateMatchRacquets()){
        event.preventDefault();
    }
});