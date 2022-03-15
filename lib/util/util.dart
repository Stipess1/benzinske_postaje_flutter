import 'dart:math';

class Util {

  // Izracunaj udaljenost izmedu dva GPS kordinata (zracna udaljenost)
  static calculateDistance(double? lat1, double? lon1, double? lat, double? lon) {
    double p = 0.017453292519943295;

    var a = 0.5 - cos((lat1! - lat!) * p) /
        2 + cos(lat * p) * cos(lat1 * p) *
        (1 - cos((lon1! - lon!) * p)) / 2;

    return 12742 * asin(sqrt(a));
  }

  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  static String getFuelFromId(int id) {
    if(id == 7) {
      return "EuroDizel+";
    } else if(id == 8) {
      return "EuroDizel";
    } else if(id == 1) {
      return "Eurosuper 95+";
    } else if(id == 2) {
      return "Eurosuper 95";
    } else if(id == 5) {
      return "Eurosuper 100+";
    } else if(id == 6) {
      return "Eurosuper 100";
    } else if(id == 9) {
      return "UNP (autoplin)";
    } else  {
      return "Plavi dizel";
    }
  }
}