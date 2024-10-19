import 'package:edmusica_admin/PAGES/teachers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_library/COMPONENTS/button_view.dart';
import 'package:flutter_library/COMPONENTS/main_view.dart';
import 'package:flutter_library/COMPONENTS/padding_view.dart';
import 'package:flutter_library/COMPONENTS/pill_view.dart';
import 'package:flutter_library/COMPONENTS/roundedcorners_view.dart';
import 'package:flutter_library/COMPONENTS/text_view.dart';
import 'package:flutter_library/FUNCTIONS/colors.dart';
import 'package:flutter_library/MODELS/DATAMASTER/datamaster.dart';

class Dashboard extends StatefulWidget {
  final DataMaster dm;
  const Dashboard({super.key, required this.dm});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _selectedPage = 'Dashboard';
  bool _toggleMenu = false;

  // Method to build the content for each page
  Widget _buildPageContent() {
    switch (_selectedPage) {
      case 'Teachers':
        return Teachers(dm: widget.dm);
      case 'Dashboard':
      default:
        return Column(
          children: [
            // Add Dashboard page content here
          ],
        );
    }
  }

  // Reusable method for building a menu item
  Widget _buildMenuItem({
    required String label,
    required IconData icon,
    required String page,
  }) {
    bool selected = _selectedPage == page;

    return ButtonView(
      child: PillView(
        backgroundColor: selected ? hexToColor('#375AF6') : Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextView(
              text: label,
              color: Colors.white,
              size: 20,
              weight: FontWeight.w500,
            ),
            Icon(
              icon,
              size: 30,
              color: Colors.white,
            ),
          ],
        ),
      ),
      onPress: () {
        setState(() {
          _selectedPage = page;
          _toggleMenu = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainView(
      dm: widget.dm,
      backgroundColor: Colors.black,
      mobile: [
        // TOP
        PaddingView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextView(
                text: _selectedPage,
                size: 20,
                weight: FontWeight.w400,
                color: Colors.white,
              ),
              ButtonView(
                child: Icon(
                  _toggleMenu ? Icons.close : Icons.menu,
                  size: 30,
                  color: Colors.white,
                ),
                onPress: () {
                  setState(() {
                    _toggleMenu = !_toggleMenu;
                  });
                },
              ),
            ],
          ),
        ),

        // BODY
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // MENU
                if (_toggleMenu)
                  PaddingView(
                    child: Column(
                      children: [
                        _buildMenuItem(
                          label: 'Dashboard',
                          icon: Icons.dashboard_outlined,
                          page: 'Dashboard',
                        ),
                        _buildMenuItem(
                          label: 'Teachers',
                          icon: Icons.group_outlined,
                          page: 'Teachers',
                        ),
                      ],
                    ),
                  ),

                // PAGE CONTENT
                _buildPageContent(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
