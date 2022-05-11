class DatesUtils {
  static String format(DateTime? date) {
    if (date == null) return "-- / -- / ----";

    return "${date.day} / ${date.month} / ${date.year}";
  }
}
