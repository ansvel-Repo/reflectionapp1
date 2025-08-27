import 'rive_model.dart';

class NavItemModel {
  final String title;
  final RiveModel rive;

  NavItemModel({required this.title, required this.rive});
}

List<NavItemModel> buttomNavItems2 = [
  NavItemModel(
      title: "Home",
      rive: RiveModel(
          src: "assets/rivepodanimation/RiveAssets/icons.riv",
          artboard: "HOME",
          stateMachineName: "HOME_Interactivity")),
  NavItemModel(
      title: "Search",
      rive: RiveModel(
          src: "assets/rivepodanimation/RiveAssets/icons.riv",
          artboard: "SEARCH",
          stateMachineName: "SEARCH_Interactivity")),
  NavItemModel(
      title: "Chat",
      rive: RiveModel(
          src: "assets/rivepodanimation/RiveAssets/icons.riv",
          artboard: "CHAT",
          stateMachineName: "CHAT_Interactivity")),
  NavItemModel(
      title: "Notification",
      rive: RiveModel(
          src: "assets/rivepodanimation/RiveAssets/icons.riv",
          artboard: "BELL",
          stateMachineName: "BELL_Interactivity")),
  NavItemModel(
      title: "Profile",
      rive: RiveModel(
          src: "assets/rivepodanimation/RiveAssets/icons.riv",
          artboard: "USER",
          stateMachineName: "USER_Interactivity")),
  NavItemModel(
      title: "Settings",
      rive: RiveModel(
          src: "assets/rivepodanimation/RiveAssets/icons.riv",
          artboard: "SETTINGS",
          stateMachineName: "SETTINGS_Interactivity")),
];
