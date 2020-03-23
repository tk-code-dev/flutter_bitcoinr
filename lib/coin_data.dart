import 'package:http/http.dart' as http;
import 'dart:convert';

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '25E4B59D-2963-4EF4-B314-CB563CE14900';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  //  Create the Asynchronous method getCoinData() that returns a Future (the price data).
  Future getCoinData() async {
    //  Create a url combining the coinAPIURL with the currencies, BTC to USD.
    String requestURL = '$coinAPIURL/BTC/USD?apikey=$apiKey';
    //  Make a GET request to the URL and wait for the response.
    http.Response response = await http.get(requestURL);

    //  Check that the request was successful.
    if (response.statusCode == 200) {
      //  Use the 'dart:convert' package to decode the JSON data that comes back from coinapi.io.
      var decodedData = jsonDecode(response.body);
      //  Get the last price of bitcoin with the key 'last'.
      var lastPrice = decodedData['rate'];
      //  Output the lastPrice from the method.
      return lastPrice;
    } else {
      //  Handle any errors that occur during the request.
      print(response.statusCode);
      //  Optional: throw an error if our request fails.
      throw 'Problem with the get request';
    }
  }
}
