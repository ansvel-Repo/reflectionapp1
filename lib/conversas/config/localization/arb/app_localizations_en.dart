// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Conversas';

  @override
  String get contacts => 'Contacts';

  @override
  String get chats => 'Chats';

  @override
  String get more => 'More';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get enterValidEmailAddress => 'Enter valid email address';

  @override
  String get welcomeBack => 'Welcome back, we\'ve missed you';

  @override
  String get enterPassword => 'Enter password here';

  @override
  String get enterEmail => 'Enter email here';

  @override
  String get thisFieldIsRequired => 'This field is required';

  @override
  String get password => 'Password';

  @override
  String get logout => 'Log out';

  @override
  String get login => 'Log In';

  @override
  String get email => 'Email';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get username => 'Username';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get createAccount => 'Create Account';

  @override
  String get termsAndConditions => 'Terms and conditions';

  @override
  String get alreadyHaveAnAccount => 'Already have an account?';

  @override
  String get checkSpamFolder => 'Please, Check your inbox or spam folder!';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signUpWithEmail => 'Sign Up with email';

  @override
  String get loginpWithGoogle => 'Log In with Google';

  @override
  String get or => 'or';

  @override
  String get helloAgain => 'You\'ve been missed!';

  @override
  String get passwordMustHave => 'Password must have at least 7 characters.!';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get kindlyProvideYourEmailAddress =>
      'Kindly provide the email address to which you would like us to send your password reset information.';

  @override
  String get requestLink => 'Request link';

  @override
  String get weSentAnEmailToReset =>
      'We\'ve sent an email to reset your password, check your inbox or spam folder.';

  @override
  String get lastSeen => 'Last seen';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get online => 'Online';

  @override
  String get add => 'Add';

  @override
  String get search => 'Search';

  @override
  String get addContacts => 'Add Contacts';

  @override
  String get noUser => 'There is no user to display yet';

  @override
  String get noContactAddedYet =>
      'There is contact added yet \nstart adding one';

  @override
  String get appVersion => 'App version';

  @override
  String get version => 'Version';

  @override
  String get buildNumber => 'Build number';

  @override
  String get copyright => 'Copyright';

  @override
  String get incAllRightsReserved => 'Inc. All Rights Reserved';

  @override
  String get areYouSureYouWantLogout => 'Are you sure you want to logout?';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get notifications => 'Notifications';

  @override
  String get requestSent => 'Request Sent';

  @override
  String get noRequest => 'There is no contact request yet';

  @override
  String get confirm => 'Confirm';

  @override
  String get remove => 'Remove';

  @override
  String get sentYouContactRequest => 'Sent you a contact request';

  @override
  String get message => 'Message';

  @override
  String get contactRemoved => 'Contact removed successfully';

  @override
  String get removedUserFromContact => 'Remove Contact ';

  @override
  String areYouSureYouWantRemoveFromContact(Object username) {
    return 'Are you sure you want to remove $username from your contact list? ';
  }

  @override
  String get areYouSureYouWantDeleteChat =>
      'Are you sure you want to delete this chat? ';

  @override
  String get chatDeleted => 'Chat deleted successfully';

  @override
  String get deleteChat => 'Delete Chat';

  @override
  String get yourStory => 'Your Story';

  @override
  String get addImage => 'Add Image';

  @override
  String get addStory => 'Add Story';

  @override
  String get close => 'Close';

  @override
  String get noStoriesAvailable => 'No stories available';

  @override
  String get save => 'Save';

  @override
  String get writeMessageHere => 'write message here ...';

  @override
  String get thereIsNoMessageYet => 'There is no message between you';

  @override
  String get thereIsNoChatYet => 'There is no chat yet, create one';

  @override
  String get thereIsNoMessage => 'There is no message';

  @override
  String get you => 'You';

  @override
  String get photo => 'Photo';

  @override
  String get delete => 'Delete';

  @override
  String get privacy => 'Privacy';

  @override
  String get help => 'Help';

  @override
  String get msgCopied => 'Message copied';

  @override
  String get copyMsg => 'Copy';

  @override
  String get language => 'Language';

  @override
  String get inviteFriends => 'Invite Your Friends';

  @override
  String inviteText(Object appLink) {
    return 'Join our app and get amazing conversation! Download it from $appLink.';
  }

  @override
  String get joinedDate => 'Joined date';

  @override
  String get changeImage => 'Change Image';

  @override
  String get updateProfile => 'Update Profile';

  @override
  String get profileUpdateSuccessfully => 'Profile update successfully';

  @override
  String get anErrorOccurredWhileSavingTheImage =>
      'An error occurred while saving the image';

  @override
  String get imageSavedTo => 'Image saved to gallery';

  @override
  String get cancel => 'Cancel';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountQuestion =>
      'Are you sure you want to delete your account?';

  @override
  String get ifDeleteAccount => 'If you delete your account:';

  @override
  String get iWantDeleteMyAccount => 'Yes, I want to delete my account.';

  @override
  String get deleteAccountAlter1 =>
      'Once you delete your account, you\'ll be logged out of this app.';

  @override
  String get deleteAccountAlter2 =>
      'You\'ll lose all data in associated Conversas App accounts that use the same email address.';

  @override
  String get deleteAccountAlter3 =>
      'You won\'t be able to access your posts, chats, app contacts and other benefits';

  @override
  String get deleteAccountAlter4 =>
      'If you change your mind, you can always come back and open a new account with Us.';

  @override
  String get cantBeUndoneDeleteAccount =>
      'Are you sure you want to delete your account? (This can\'t be undone)';

  @override
  String get deleteAccountLastAlert =>
      'After you submit your request, we will disable your account. It may take up to 30 days to fully delete and remove all of your data.';

  @override
  String get accountDeleted => 'Account deleted';

  @override
  String get newChat => 'New Chat';

  @override
  String get createGroup => 'Create Group';

  @override
  String get newGroup => 'New Group';

  @override
  String get searchName => 'Search name';

  @override
  String get aboutMessage => 'Hello, it\'s me on Conversas';

  @override
  String get about => 'About';

  @override
  String get tellAboutYou => 'Tell about yourself';

  @override
  String get portuguese => 'Portuguese';

  @override
  String get english => 'English';

  @override
  String get deleteContact => 'Delete Contact';

  @override
  String get sendMsg => 'Send Message';

  @override
  String get contactInfo => 'Contact Info';

  @override
  String get msgDeleted => 'Message deleted';

  @override
  String get reachedGroupMemberLimit => 'Reached the group members limit.';

  @override
  String get addParticipants => 'Add Participants';

  @override
  String get participants => 'Participants';

  @override
  String get oF => 'of';

  @override
  String get create => 'Create';

  @override
  String get next => 'Next';

  @override
  String get groupName => 'Group name';

  @override
  String get addContact => 'Add contact';

  @override
  String get groupCreatedSuccessfully => 'Group created successfully';

  @override
  String get aboutGroup => 'About group (optional)';

  @override
  String get aboutGroupMsg => 'Hello, it\'s us on Conversas';

  @override
  String get individualChats => 'Individual Chats';

  @override
  String get groupChats => 'Group Chats';

  @override
  String get thereIsNoGroupYet => 'There is no group yet, create one';

  @override
  String get members => 'Members';

  @override
  String get groupInfo => 'Group Info';

  @override
  String get lastActivity => 'Last activity';

  @override
  String get edit => 'Edit';

  @override
  String get updateGroup => 'Update Group';

  @override
  String get groupDescription => 'Add Group Description';

  @override
  String get groupUpdatedSuccessfully => 'Group updated successfully';

  @override
  String participantsPlural(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Participants',
      one: 'Participant 1',
      zero: '1 Participant',
    );
    return '$_temp0';
  }

  @override
  String get update => 'Update';

  @override
  String get joined => 'Joined';

  @override
  String get created => 'Created';

  @override
  String get createdBy => 'Created by';

  @override
  String get admin => 'Admin';

  @override
  String get deleteGroup => 'Delete Group';

  @override
  String areYouSureYouWantDeleteGroup(Object groupName) {
    return 'Are you sure you want to delete $groupName group? ';
  }

  @override
  String areYouSureYouWantExitGroup(Object groupName) {
    return 'Are you sure you want to exit $groupName group? ';
  }

  @override
  String get areYouSureYouWantRemoveUserFromGroup =>
      'Are you sure you want to remove this user from group?';

  @override
  String get areYouSureYouWantMakeAdminGroup =>
      'Are you sure you want to make this user group admin?';

  @override
  String get areYouSureYouWantRemoveAdmin =>
      'Are you sure you want to remove this user as admin?';

  @override
  String get info => 'Info';

  @override
  String get makeGroupAdmin => 'Make Group Admin';

  @override
  String get removeAsGroupAdmin => 'Remove as Group Admin';

  @override
  String get removeFromGroup => 'Remove from Group';

  @override
  String get userRemoveFromGroup => 'User remove from Group';

  @override
  String get userAddedAsGroupAdmin => 'User added as Group Admin';

  @override
  String get userRemovedAsGroupAdmin => 'User removed as Group Admin';

  @override
  String get exitGroup => 'Exit Group';

  @override
  String get groupDeleted => 'Group deleted successfully';

  @override
  String get exitGroupSuccess => 'Exited from Group successfully';
}
