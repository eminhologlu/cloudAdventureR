class Moneydata {
  String currencyName;
  String symbol;
  int unit;
  Map<double, String?> selectedCurrencyTypes;
  Map<double, String> imageBase64Map;

  Moneydata({
    this.currencyName = "",
    this.symbol = "",
    this.unit = 0,
    Map<double, String>? selectedCurrencyTypes,
    Map<double, String>? imageBase64Map,
  })  : selectedCurrencyTypes = selectedCurrencyTypes ?? {},
        imageBase64Map = imageBase64Map ?? {};
}
