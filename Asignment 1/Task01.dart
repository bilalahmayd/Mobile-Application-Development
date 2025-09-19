import 'package:flutter/material.dart';

class MaximumBid extends StatefulWidget {
  @override
  _MaximumBidState createState() => _MaximumBidState();
}

class _MaximumBidState extends State<MaximumBid> {
  int _bidAmount = 100; // initial bid
  final int _initialBid = 100; // to reset later

  void _increaseBid() {
    setState(() {
      _bidAmount += 50;
    });
  }

  void _resetBid() {
    setState(() {
      _bidAmount = _initialBid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bidding Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your Maximum Bid:",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "\$$_bidAmount",
              style: TextStyle(fontSize: 40, color: Colors.green),
            ),
            SizedBox(height: 30),

            // Buttons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _increaseBid,
                  child: Text("Increase Bid by \$50"),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _resetBid,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                  child: Text("Reset", style: TextStyle(color: Colors.white),
                ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MaximumBid(),
  ));
}
