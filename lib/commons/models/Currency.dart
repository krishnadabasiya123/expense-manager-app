
class Currency {
  // ₹, $, €

  const Currency({required this.code, required this.name, required this.symbol});
  final String code; // ISO code (INR, USD)
  final String name; // Currency name
  final String symbol;
}

// const currencyModels = {
//   'INR': Currency(code: 'INR', name: 'Indian Rupee', symbol: '₹'),
//   'USD': Currency(code: 'USD', name: 'United States Dollar', symbol: r'$'),
//   'AED': Currency(code: 'AED', name: 'United Arab Emirates', symbol: 'د.إ'),
//   'EUR': Currency(code: 'EUR', name: 'Euro', symbol: '€'),
//   'GBP': Currency(code: 'GBP', name: 'British Pound', symbol: '£'),
//   'AUD': Currency(code: 'AUD', name: 'Australian Dollar', symbol: r'$'),
// };
final currecyList = [
  {'name': 'Dollar', 'symbol': r'$'},
  {'name': 'Euro', 'symbol': '€'},
  {'name': 'Rupee', 'symbol': '₹'},
];
