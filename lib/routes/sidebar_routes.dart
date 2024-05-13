import 'package:restaurant_management_system/services/SharedPref_Helper.dart';
import 'package:restaurant_management_system/classes/route.dart' as _MyAppRoute;
import 'routes.dart';

late SharedPref pref;

List<_MyAppRoute.Router> getRoleBasedRoutes () {
  initiatePreference();
  String role = pref.getValue("ROLE") ?? "";

  return routeArr
    .where((element) => element.allowedRoles!.contains(role)).toList();
}

void initiatePreference() async {
  pref = SharedPref();
  await pref.init();
}