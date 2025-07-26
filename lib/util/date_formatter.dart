import 'package:intl/intl.dart';

/// Serviço para manipulação e formatação de datas.
class DateService {

  /// Retorna a data atual formatada.
  static String obterDataFormatadaAtual() {
    final agora = DateTime.now();
    return _formatarData(agora);
  }

  /// Formata uma data no padrão 'quarta-feira, 23 de julho de 2025'.
  static String _formatarData(DateTime data) {
    final formatter = DateFormat("EEEE, d 'de' MMMM 'de' y", 'pt_BR');
    return formatter.format(data);
  }
}