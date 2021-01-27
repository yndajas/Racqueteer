function togglePasswordVisibility() {
    var password_input = document.getElementById("password");
    if (password_input.type === "password") {
        password_input.type = "text";
    } else {
        password_input.type = "password";
    }
}

function togglePasswordsVisibility() {
    var password_inputs = document.getElementsByClassName("password");
    for (let password_input of password_inputs) {
        if (password_input.type === "password") {
            password_input.type = "text";
        } else {
            password_input.type = "password";
        }    
    }
}