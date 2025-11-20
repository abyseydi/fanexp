var formatDate = (String dateTime) {
  var date = dateTime.split("T")[0];
  var reverse = date.split('-').reversed;
  return "${reverse.elementAt(0)}/${reverse.elementAt(1)}/${reverse.elementAt(2)}";
};

var getParticipationPercentage = (int participation, int participationGoal) {
  return (participation * 100 / participationGoal).toInt();
};

var formatPickedDate = (String dateTime) {
  var date = dateTime.split(" ")[0];
  var reverse = date.split('-').reversed;
  return "${reverse.elementAt(0)}/${reverse.elementAt(1)}/${reverse.elementAt(2)}";
};
