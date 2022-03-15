import 'package:benzinske_postaje/model/gorivo.dart';
import 'package:benzinske_postaje/model/postaja.dart';

class IHome {
  void onSuccessFetch(List<Postaja> list, List<Gorivo> goriva, bool sorted) {}

  void onFailureFetch(String message) {}
}