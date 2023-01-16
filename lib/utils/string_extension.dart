extension StringExtension on String {
  dynamic precoToDouble() {
    return double.tryParse(
        this.replaceAll(RegExp(r'[R$]'), '').replaceFirst(',', '.'));
  }
}
