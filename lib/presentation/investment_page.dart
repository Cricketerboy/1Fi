import 'dart:convert';

import 'package:finance/widgets/action_buttons.dart';
import 'package:finance/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class InvestmentPage extends StatefulWidget {
  @override
  _InvestmentPageState createState() => _InvestmentPageState();
}

class _InvestmentPageState extends State<InvestmentPage> {
  int _selectedIndex = 0; // Track the selected index
  Map<String, dynamic> data = {}; // Variable to hold API data

  @override
  void initState() {
    super.initState();
    fetchSheetData(); // Fetch data when the page is initialized
  }

  // Fetch data from the Google Sheets API
  Future<void> fetchSheetData() async {
    final response = await http.get(Uri.parse(
        'https://script.googleusercontent.com/macros/echo?user_content_key=vp-AE9KbILwsPSiuxjSYwBdthdzZaLcEeHj-YkUp5ywPVz3Pm58a6VNMGQworRsiZLier6EuWVPXuWf-gcmvSKWGDGwgy7bNm5_BxDlH2jW0nuo2oDemN9CCS2h10ox_1xSncGQajx_ryfhECjZEnDwQ1dbAUKv2-wwIkm-2p3RKjp9nT6BiGpdrvJHn7I50Y2hWp1MX_dsDmdiY8huYG9hMZ1HBBOX5lWXvqxr8wSAzpm50RqvrZA&lib=MPD442PJ1f8LmKhtiiqNiYH5g-2G6-JsI'));

    if (response.statusCode == 200) {
      final List<dynamic> fetchedData = json.decode(response.body);

      // Process the data and store it
      Map<String, dynamic> parsedData = {};
      for (var item in fetchedData) {
        parsedData[item['Key']] = item['Value'];
      }

      setState(() {
        data = parsedData;
      });
    } else {
      throw Exception('Failed to load investment data');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:
          true, // Allows the body to extend behind the AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Make AppBar transparent
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/1Fi.jpg',
              height: 28,
            ),
            SizedBox(width: 8),
            Text('Invest', style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        actions: [
          Icon(
            Icons.notifications_outlined,
            color: Colors.white,
            size: 28,
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 65, 81, 226),
              Color(0xFFAB47BC), // Lighter Purple
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 80), // Spacing for AppBar
            // Current Value Section
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Current Value',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 2, color: Colors.white), // White border
                        ),
                        child: Text(
                          '₹',
                          style: TextStyle(
                            color: Color.fromARGB(255, 65, 81, 226),
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        data.isNotEmpty ? data['Current Value'] : 'Loading...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Total Returns ',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        TextSpan(
                          text: '↑ ',
                          style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: data.isNotEmpty
                              ? data['Total Returns'].toString()
                              : 'Loading...',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                        TextSpan(
                          text: '(+47.92%)',
                          style: TextStyle(
                              color: Colors.greenAccent, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            // Stats Row (Using Expanded to ensure equal width)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    StatCard(
                        title: 'Invested',
                        value: data.isNotEmpty
                            ? data['Invested'].toString()
                            : 'Loading...'),
                    SizedBox(width: 16),
                    StatCard(
                        title: 'XIRR',
                        value: data.isNotEmpty
                            ? data['XIRR'].toString()
                            : 'Loading...'),
                    SizedBox(width: 16),
                    StatCard(
                      title: '1 Day Return',
                      value: data.isNotEmpty
                          ? data['1 Day Return'].toString()
                          : 'Loading...',
                      additionalText: '(+0.17%)',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Chart Section (Fixed height using Container or SizedBox)
            Flexible(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      // Line Chart with fixed height
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          height: 150, // Fixed height for the chart
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(show: false),
                              titlesData: FlTitlesData(show: false),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: [
                                    FlSpot(0, 1),
                                    FlSpot(1, 2),
                                    FlSpot(2, 1.5),
                                    FlSpot(3, 3),
                                    FlSpot(4, 2.5),
                                  ],
                                  isCurved: true,
                                  color: Colors.green,
                                  dotData: FlDotData(show: false),
                                  belowBarData: BarAreaData(show: false),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: ['1D', '1W', '3M', '6M', '1Y', '5Y', 'All']
                            .map(
                              (label) => Text(
                                label,
                                style: TextStyle(
                                  color: label == 'All'
                                      ? Colors.green
                                      : Colors.black54,
                                  fontWeight: label == 'All'
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(height: 16),
                      // Action Buttons
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            fixedSize: Size(double.infinity, 50),
                          ),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 2,
                                      color: Colors.white), // White border
                                ),
                                child: Icon(Icons.add, color: Colors.green),
                              ),
                              SizedBox(width: 8),
                              Text('Invest more',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 10),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 65, 81, 226),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            fixedSize: Size(double.infinity, 50),
                          ),
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.restaurant, color: Colors.white),
                              SizedBox(width: 8),
                              Text('Get loan against your investments',
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Bottom Actions
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ActionButton(
                                icon: Icons.pie_chart,
                                label: 'Portfolio',
                              ),
                              SizedBox(width: 16),
                              ActionButton(
                                icon: Icons.refresh,
                                label: 'Redeem',
                              ),
                              SizedBox(width: 16),
                              ActionButton(
                                icon: Icons.receipt_long,
                                label: 'Transactions',
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Set the selected index
        onTap: _onItemTapped, // Update the selected index on tap
        selectedItemColor: Color.fromARGB(255, 65, 81, 226),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
