class DateHelper{

  static int daysUntilNxtMonth(){
    var date = new DateTime.now();
    var month = date.month;
    var forYear = date.year;
    DateTime firstOfNextMonth;
    if(month == 12) {
      firstOfNextMonth = DateTime(forYear+1, 1, 1, 12);//year, month, day, hour
    }
    else {
      firstOfNextMonth = DateTime(forYear, month+1, 1, 12);
    }
    int numberOfDaysInMonth = firstOfNextMonth.subtract(Duration(days: 1)).day;
    //.subtract(Duration) returns a DateTime, .day gets the integer for the day of that DateTime

    var today = date.day;
    int daysUntilNxtMonth = numberOfDaysInMonth - today +1;


    return daysUntilNxtMonth;
  }

}