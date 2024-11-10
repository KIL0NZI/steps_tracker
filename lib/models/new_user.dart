import 'package:steps_tracker/tabs/home_page_tab.dart';
import 'package:steps_tracker/screens/landing_screen.dart';

class NewUser {
  final bool _isNew = false;

  firstPage() {
    return _isNew ? LandinPage() : HomeScreen();
  }
}
