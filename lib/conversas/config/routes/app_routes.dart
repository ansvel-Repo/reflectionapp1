import 'package:ansvel/conversas/common/common.dart';
import 'package:ansvel/conversas/features/settings/pages/delete_account.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ansvel/conversas/config/config.dart';
import 'package:ansvel/conversas/features/features.dart';

final appRoutes = [
  GoRoute(
    path: RouteLocation.splash,
    parentNavigatorKey: navigationKey,
    builder: SplashPage.builder,
  ),
  GoRoute(
    path: RouteLocation.login,
    parentNavigatorKey: navigationKey,
    builder: LoginPage.builder,
  ),
  GoRoute(
    path: RouteLocation.signup,
    parentNavigatorKey: navigationKey,
    builder: SignUpPage.builder,
  ),
  GoRoute(
    path: RouteLocation.forgetPassword,
    parentNavigatorKey: navigationKey,
    builder: ForgetPasswordPage.builder,
  ),

  GoRoute(
    path: RouteLocation.addContact,
    parentNavigatorKey: navigationKey,
    builder: AddContactPage.builder,
  ),
  //delete account
  GoRoute(
    path: RouteLocation.deleteAccount,
    parentNavigatorKey: navigationKey,
    builder: DeleteAccountPage.builder,
  ),

  GoRoute(
    path: RouteLocation.appVersion,
    parentNavigatorKey: navigationKey,
    builder: AppVersionInfo.builder,
  ),

  //story
  GoRoute(
    path: RouteLocation.addStory,
    parentNavigatorKey: navigationKey,
    builder: AddStoryPage.builder,
  ),
  GoRoute(
    name: RouteLocation.userStories,
    path: RouteLocation.userStories,
    parentNavigatorKey: navigationKey,
    pageBuilder: (context, state) {
      return _buildCommonTransitionPage(
        state: state,
        context: context,
        child: WatchUserStories.builder(state.extra as AppUser, context, state),
      );
    },
  ),

  //chats
  GoRoute(
    name: RouteLocation.personalChat,
    path: '${RouteLocation.personalChat}/:${AppKeys.receiverId}',
    parentNavigatorKey: navigationKey,
    pageBuilder: (context, state) {
      return _buildCommonTransitionPage(
        state: state,
        context: context,
        child: PersonalChatPage.builder(
          '${state.pathParameters[AppKeys.receiverId]}',
          context,
          state,
        ),
      );
    },
  ),
  GoRoute(
    name: RouteLocation.groups,
    path: '${RouteLocation.groups}/:${AppKeys.groupId}',
    parentNavigatorKey: navigationKey,
    pageBuilder: (context, state) {
      return _buildCommonTransitionPage(
        state: state,
        context: context,
        child: GroupChatPage.builder(
          '${state.pathParameters[AppKeys.groupId]}',
          context,
          state,
        ),
      );
    },
  ),
  GoRoute(
    name: RouteLocation.groupInfo,
    path: '${RouteLocation.groupInfo}/:${AppKeys.groupId}',
    parentNavigatorKey: navigationKey,
    pageBuilder: (context, state) {
      return _buildCommonTransitionPage(
        state: state,
        context: context,
        child: GroupInfoPage.builder(
          '${state.pathParameters[AppKeys.groupId]}',
          context,
          state,
        ),
      );
    },
  ),
  GoRoute(
    path: RouteLocation.addParticipants,
    parentNavigatorKey: navigationKey,
    builder: AddParticipantsPage.builder,
  ),
  GoRoute(
    path: RouteLocation.createGroup,
    parentNavigatorKey: navigationKey,
    builder: CreateGroupPage.builder,
  ),

  //contactDetails
  GoRoute(
    name: RouteLocation.contactDetails,
    path: '${RouteLocation.contactDetails}/:${AppKeys.userId}',
    parentNavigatorKey: navigationKey,
    pageBuilder: (context, state) {
      return _buildCommonTransitionPage(
        state: state,
        context: context,
        child: ContactDetailsPage.builder(
          '${state.pathParameters[AppKeys.userId]}',
          context,
          state,
        ),
      );
    },
  ),

  //Bottom Nav bar shell
  StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return ScaffoldWithNavBar(
        key: state.pageKey,
        navigationShell: navigationShell,
      );
    },
    branches: <StatefulShellBranch>[
      StatefulShellBranch(
        routes: <RouteBase>[
          GoRoute(path: RouteLocation.contacts, builder: ContactsPage.builder),
        ],
      ),
      StatefulShellBranch(
        routes: <RouteBase>[
          GoRoute(path: RouteLocation.chats, builder: ChatsPage.builder),
        ],
      ),
      StatefulShellBranch(
        routes: <RouteBase>[
          GoRoute(
            path: RouteLocation.notification,
            builder: NotificationPage.builder,
          ),
        ],
      ),
      StatefulShellBranch(
        routes: <RouteBase>[
          GoRoute(path: RouteLocation.settings, builder: SettingsPage.builder),
        ],
      ),
    ],
  ),
];

CustomTransitionPage<dynamic> _buildCommonTransitionPage({
  required GoRouterState state,
  required BuildContext context,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    transitionsBuilder:
        (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
            child: child,
          );
        },
    child: child,
  );
}
