import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../Account/profile_screen.dart';
import '../common/Constants.dart';
import '../main.dart';
import '../products/View/product_list_widget.dart';
import '../request/AddNewRequestWidget.dart';
import '../request/pending_requests/pending_request_list_widget.dart';
import '../request/request_history/request_history_list_widget.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    ProductListWidget(),
    PendingRequestListWidget(List.empty()),
    //RequestCalenderWidget(title: 'Calender'),
    RequestHistoryListWidget(""),
    // MyAccountTabScreen()
    ProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // Simulating obtaining the user name from some local storage
    super.initState();
    var userUUID = FirebaseAuth.instance.currentUser!.uid;
    GetStorage().write(userUUIDKey, userUUID);
  }

  @override
  Widget build(BuildContext context) {
    var selectedItemColor = Colors.amber[800];
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(_title),
      // ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _getFloatingActionButton(),
      bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Container(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.list_alt),
                    color:
                        _selectedIndex == 0 ? selectedItemColor : Colors.black,
                    onPressed: () {
                      _onItemTapped(0);
                    }),
                IconButton(
                    icon: Icon(Icons.pending_actions),
                    color:
                        _selectedIndex == 1 ? selectedItemColor : Colors.black,
                    onPressed: () {
                      _onItemTapped(1);
                    }),
                // IconButton(
                //     icon: Icon(Icons.calendar_today),
                //     color:
                //         _selectedIndex == 1 ? selectedItemColor : Colors.black,
                //     onPressed: () {
                //       _onItemTapped(1);
                //     }),
                SizedBox(width: 30), // The dummy child
                IconButton(
                    icon: Icon(Icons.history),
                    color:
                        _selectedIndex == 2 ? selectedItemColor : Colors.black,
                    onPressed: () {
                      _onItemTapped(2);
                    }),
                IconButton(
                    icon: Icon(Icons.account_box),
                    color:
                        _selectedIndex == 3 ? selectedItemColor : Colors.black,
                    onPressed: () {
                      _onItemTapped(3);
                    }),
              ],
            ),
          )),
    );
  }

  _getFloatingActionButton() {
    var userRole = currentUserDetails?.userRole ?? "";
    if (userRole.isEmpty || userRole == UserRoles.serviceEngineer.toString()) {
      return null;
    }
    return new FloatingActionButton(
      onPressed: () {
        Get.to(() => AddNewRequestWidget());
      },
      tooltip: 'Add',
      child: new Icon(Icons.add),
      elevation: 4.0,
    );
  }
}
