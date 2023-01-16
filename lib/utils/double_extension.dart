extension DoubleExtension on double {
  String convertToReal() {
    String valor = this.toStringAsFixed(2).replaceAll('.', ',');
    if (!valor.contains(RegExp(r',[0-9][0-9]'))) {
      valor = '${valor}0';
    }
    return valor;
  }
}
