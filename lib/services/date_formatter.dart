import 'package:intl/intl.dart';

/*
* Classe para obter a data atual e alterar para o formato desejado.
* */
class DateService {

  /*
  * Métodoo para obter a data atual
  * */
  static String obterDataFormatadaAtual() {
    final agora = DateTime.now();
    return _formatarData(agora);
  }

  /*
  * Métodoo privado que formatará a data
  * */
  static String _formatarData(DateTime data) {
    final formatter = DateFormat("EEEE, d 'de' MMMM 'de' y", 'pt_BR');
    return formatter.format(data);
  }
}