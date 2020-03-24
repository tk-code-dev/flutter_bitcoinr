import 'package:flutter/material.dart';
import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }
    return DropdownButton(
      value: selectedCurrency,
      icon: Icon(Icons.expand_more),
      iconSize: 30,
      elevation: 40,
      style: TextStyle(
        color: Colors.white70,
        fontSize: 30.0,
      ),
      items: dropdownItems,
      onChanged: (value) {
        setState(
          () {
            selectedCurrency = value;
            //  Call getData() when the picker/dropdown changes.
            getData();
          },
        );
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(
        currency,
        style: TextStyle(color: Colors.white),
      ));
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(currenciesList[selectedIndex]);
        setState(() {
          //  Save the selected currency to the property selectedCurrency
          selectedCurrency = currenciesList[selectedIndex];
          //  Call getData() when the picker/dropdown changes.
          getData();
        });
      },
      children: pickerItems,
    );
  }

  //  value had to be updated into a Map to store the values of all three cryptocurrencies.
  Map<String, String> coinValues = {};
  //  Figure out a way of displaying a '?' on screen while we're waiting for the price data to come back. First we have to create a variable to keep track of when we're waiting on the request to complete.
  bool isWaiting = false;

  void getData() async {
    //  Second, we set it to true when we initiate the request for prices.
    isWaiting = true;
    try {
      //  Update this method to receive a Map containing the crypto:price key value pairs.
      var data = await CoinData().getCoinData(selectedCurrency);
      //  Third, as soon the above line of code completes, we now have the data and no longer need to wait. So we can set isWaiting to false.
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    //  Call getData() when the screen loads up. We can't call CoinData().getCoinData() directly here because can't make initState() async.
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, //  Center the title of an appbar
        title: Text('Coin Ticker'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black87,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //  use a Column Widget to contain the three CryptoCards.
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  CryptoCard(
                    cryptoCurrency: 'BTC',
                    //  Finally, use a ternary operator to check if waiting and if so, display a '?' otherwise show the actual price data.
                    value: isWaiting
                        ? '?'
                        : coinValues['BTC'].replaceAllMapped(
                            new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (Match m) => '${m[1]},'),
                    selectedCurrency: selectedCurrency,
                  ),
                  CryptoCard(
                    cryptoCurrency: 'ETH',
                    value: isWaiting
                        ? '?'
                        : coinValues['ETH'].replaceAllMapped(
                            new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (Match m) => '${m[1]},'),
                    selectedCurrency: selectedCurrency,
                  ),
                  CryptoCard(
                    cryptoCurrency: 'LTC',
                    value: isWaiting
                        ? '?'
                        : coinValues['LTC'].replaceAllMapped(
                            new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (Match m) => '${m[1]},'),
                    selectedCurrency: selectedCurrency,
                  ),
                ],
              ),
            ),
            Container(
              height: 150.0,
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.black54,
              child: Platform.isIOS ? iOSPicker() : androidDropdown(),
            ),
          ],
        ),
      ),
    );
  }
}

//  Refactor this Padding Widget into a separate Stateless Widget called CryptoCard, so we can create 3 of them, one for each cryptocurrency.
class CryptoCard extends StatelessWidget {
  //  You'll need to able to pass the selectedCurrency, value and cryptoCurrency to the constructor of this CryptoCard Widget.
  const CryptoCard({
    this.value,
    this.selectedCurrency,
    this.cryptoCurrency,
  });

  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
