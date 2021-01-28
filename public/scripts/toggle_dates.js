function toggleDates() {
  // if currently single date
  if (!!document.getElementById("date")) {
    // update date label
    var start_date_label = document.getElementById("date_label");
    setAttributes(start_date_label, {"id": "start_date_label", "for": "start_date"});
    start_date_label.firstElementChild.innerHTML = "Start date";

    // update date input
    var start_date = document.getElementById("date");
    setAttributes(start_date, {"id": "start_date", "name": "start_date", "placeholder": "Start date"});

    // find form
    var form = document.getElementsByTagName("form")[0];

    // create and insert end date input
    var end_date = document.createElement("input");
    setAttributes(end_date, {"id": "end_date", "type": "date", "name": "end_date", "placeholder": "End date"});
    form.insertBefore(end_date, start_date.nextSibling);
    end_date.required = true;

    var first_br = document.createElement("br");
    form.insertBefore(first_br, end_date)

    // create and insert end date label
    var end_date_label = document.createElement("label");
    setAttributes(end_date_label, {"id": "end_date_label", "for": "end_date"});
    end_date_label.innerHTML = "<b>End date</b>";
    form.insertBefore(end_date_label, first_br);

    // create and insert <br> elements between start and end date inputs
    var next_brs = [document.createElement("br"), document.createElement("br")];
    for (let br of next_brs) {
      form.insertBefore(br, end_date_label);
    }
  } else { // if currently multi-date
    // remove end date elements
    document.getElementById("end_date_label").previousSibling.remove();
    document.getElementById("end_date_label").previousSibling.remove();
    document.getElementById("end_date_label").remove();
    document.getElementById("end_date").previousSibling.remove();
    document.getElementById("end_date").remove();

    // change start date elements to date elements
    var date_label = document.getElementById("start_date_label");
    setAttributes(date_label, {"id": "date_label", "for": "date"});
    date_label.firstElementChild.innerHTML = "Date";

    // update date input
    var date = document.getElementById("start_date");
    setAttributes(date, {"id": "date", "name": "date", "placeholder": "Date"});
  }
}

function setAttributes(element, attributes) {
  for(let key in attributes) {
    element.setAttribute(key, attributes[key]);
  }
}
  