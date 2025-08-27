import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Conversas'**
  String get appTitle;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @enterValidEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter valid email address'**
  String get enterValidEmailAddress;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, we\'ve missed you'**
  String get welcomeBack;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter password here'**
  String get enterPassword;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter email here'**
  String get enterEmail;

  /// No description provided for @thisFieldIsRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get thisFieldIsRequired;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get termsAndConditions;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAnAccount;

  /// No description provided for @checkSpamFolder.
  ///
  /// In en, this message translates to:
  /// **'Please, Check your inbox or spam folder!'**
  String get checkSpamFolder;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signUpWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Sign Up with email'**
  String get signUpWithEmail;

  /// No description provided for @loginpWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Log In with Google'**
  String get loginpWithGoogle;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @helloAgain.
  ///
  /// In en, this message translates to:
  /// **'You\'ve been missed!'**
  String get helloAgain;

  /// No description provided for @passwordMustHave.
  ///
  /// In en, this message translates to:
  /// **'Password must have at least 7 characters.!'**
  String get passwordMustHave;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @kindlyProvideYourEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Kindly provide the email address to which you would like us to send your password reset information.'**
  String get kindlyProvideYourEmailAddress;

  /// No description provided for @requestLink.
  ///
  /// In en, this message translates to:
  /// **'Request link'**
  String get requestLink;

  /// No description provided for @weSentAnEmailToReset.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent an email to reset your password, check your inbox or spam folder.'**
  String get weSentAnEmailToReset;

  /// No description provided for @lastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last seen'**
  String get lastSeen;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @addContacts.
  ///
  /// In en, this message translates to:
  /// **'Add Contacts'**
  String get addContacts;

  /// No description provided for @noUser.
  ///
  /// In en, this message translates to:
  /// **'There is no user to display yet'**
  String get noUser;

  /// No description provided for @noContactAddedYet.
  ///
  /// In en, this message translates to:
  /// **'There is contact added yet \nstart adding one'**
  String get noContactAddedYet;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get appVersion;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @buildNumber.
  ///
  /// In en, this message translates to:
  /// **'Build number'**
  String get buildNumber;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'Copyright'**
  String get copyright;

  /// No description provided for @incAllRightsReserved.
  ///
  /// In en, this message translates to:
  /// **'Inc. All Rights Reserved'**
  String get incAllRightsReserved;

  /// No description provided for @areYouSureYouWantLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areYouSureYouWantLogout;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @requestSent.
  ///
  /// In en, this message translates to:
  /// **'Request Sent'**
  String get requestSent;

  /// No description provided for @noRequest.
  ///
  /// In en, this message translates to:
  /// **'There is no contact request yet'**
  String get noRequest;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @sentYouContactRequest.
  ///
  /// In en, this message translates to:
  /// **'Sent you a contact request'**
  String get sentYouContactRequest;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @contactRemoved.
  ///
  /// In en, this message translates to:
  /// **'Contact removed successfully'**
  String get contactRemoved;

  /// No description provided for @removedUserFromContact.
  ///
  /// In en, this message translates to:
  /// **'Remove Contact '**
  String get removedUserFromContact;

  /// No description provided for @areYouSureYouWantRemoveFromContact.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {username} from your contact list? '**
  String areYouSureYouWantRemoveFromContact(Object username);

  /// No description provided for @areYouSureYouWantDeleteChat.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this chat? '**
  String get areYouSureYouWantDeleteChat;

  /// No description provided for @chatDeleted.
  ///
  /// In en, this message translates to:
  /// **'Chat deleted successfully'**
  String get chatDeleted;

  /// No description provided for @deleteChat.
  ///
  /// In en, this message translates to:
  /// **'Delete Chat'**
  String get deleteChat;

  /// No description provided for @yourStory.
  ///
  /// In en, this message translates to:
  /// **'Your Story'**
  String get yourStory;

  /// No description provided for @addImage.
  ///
  /// In en, this message translates to:
  /// **'Add Image'**
  String get addImage;

  /// No description provided for @addStory.
  ///
  /// In en, this message translates to:
  /// **'Add Story'**
  String get addStory;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @noStoriesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No stories available'**
  String get noStoriesAvailable;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @writeMessageHere.
  ///
  /// In en, this message translates to:
  /// **'write message here ...'**
  String get writeMessageHere;

  /// No description provided for @thereIsNoMessageYet.
  ///
  /// In en, this message translates to:
  /// **'There is no message between you'**
  String get thereIsNoMessageYet;

  /// No description provided for @thereIsNoChatYet.
  ///
  /// In en, this message translates to:
  /// **'There is no chat yet, create one'**
  String get thereIsNoChatYet;

  /// No description provided for @thereIsNoMessage.
  ///
  /// In en, this message translates to:
  /// **'There is no message'**
  String get thereIsNoMessage;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @photo.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @msgCopied.
  ///
  /// In en, this message translates to:
  /// **'Message copied'**
  String get msgCopied;

  /// No description provided for @copyMsg.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyMsg;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @inviteFriends.
  ///
  /// In en, this message translates to:
  /// **'Invite Your Friends'**
  String get inviteFriends;

  /// No description provided for @inviteText.
  ///
  /// In en, this message translates to:
  /// **'Join our app and get amazing conversation! Download it from {appLink}.'**
  String inviteText(Object appLink);

  /// No description provided for @joinedDate.
  ///
  /// In en, this message translates to:
  /// **'Joined date'**
  String get joinedDate;

  /// No description provided for @changeImage.
  ///
  /// In en, this message translates to:
  /// **'Change Image'**
  String get changeImage;

  /// No description provided for @updateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get updateProfile;

  /// No description provided for @profileUpdateSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile update successfully'**
  String get profileUpdateSuccessfully;

  /// No description provided for @anErrorOccurredWhileSavingTheImage.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while saving the image'**
  String get anErrorOccurredWhileSavingTheImage;

  /// No description provided for @imageSavedTo.
  ///
  /// In en, this message translates to:
  /// **'Image saved to gallery'**
  String get imageSavedTo;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get deleteAccountQuestion;

  /// No description provided for @ifDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'If you delete your account:'**
  String get ifDeleteAccount;

  /// No description provided for @iWantDeleteMyAccount.
  ///
  /// In en, this message translates to:
  /// **'Yes, I want to delete my account.'**
  String get iWantDeleteMyAccount;

  /// No description provided for @deleteAccountAlter1.
  ///
  /// In en, this message translates to:
  /// **'Once you delete your account, you\'ll be logged out of this app.'**
  String get deleteAccountAlter1;

  /// No description provided for @deleteAccountAlter2.
  ///
  /// In en, this message translates to:
  /// **'You\'ll lose all data in associated Conversas App accounts that use the same email address.'**
  String get deleteAccountAlter2;

  /// No description provided for @deleteAccountAlter3.
  ///
  /// In en, this message translates to:
  /// **'You won\'t be able to access your posts, chats, app contacts and other benefits'**
  String get deleteAccountAlter3;

  /// No description provided for @deleteAccountAlter4.
  ///
  /// In en, this message translates to:
  /// **'If you change your mind, you can always come back and open a new account with Us.'**
  String get deleteAccountAlter4;

  /// No description provided for @cantBeUndoneDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? (This can\'t be undone)'**
  String get cantBeUndoneDeleteAccount;

  /// No description provided for @deleteAccountLastAlert.
  ///
  /// In en, this message translates to:
  /// **'After you submit your request, we will disable your account. It may take up to 30 days to fully delete and remove all of your data.'**
  String get deleteAccountLastAlert;

  /// No description provided for @accountDeleted.
  ///
  /// In en, this message translates to:
  /// **'Account deleted'**
  String get accountDeleted;

  /// No description provided for @newChat.
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get newChat;

  /// No description provided for @createGroup.
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get createGroup;

  /// No description provided for @newGroup.
  ///
  /// In en, this message translates to:
  /// **'New Group'**
  String get newGroup;

  /// No description provided for @searchName.
  ///
  /// In en, this message translates to:
  /// **'Search name'**
  String get searchName;

  /// No description provided for @aboutMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello, it\'s me on Conversas'**
  String get aboutMessage;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @tellAboutYou.
  ///
  /// In en, this message translates to:
  /// **'Tell about yourself'**
  String get tellAboutYou;

  /// No description provided for @portuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get portuguese;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @deleteContact.
  ///
  /// In en, this message translates to:
  /// **'Delete Contact'**
  String get deleteContact;

  /// No description provided for @sendMsg.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMsg;

  /// No description provided for @contactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact Info'**
  String get contactInfo;

  /// No description provided for @msgDeleted.
  ///
  /// In en, this message translates to:
  /// **'Message deleted'**
  String get msgDeleted;

  /// No description provided for @reachedGroupMemberLimit.
  ///
  /// In en, this message translates to:
  /// **'Reached the group members limit.'**
  String get reachedGroupMemberLimit;

  /// No description provided for @addParticipants.
  ///
  /// In en, this message translates to:
  /// **'Add Participants'**
  String get addParticipants;

  /// No description provided for @participants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participants;

  /// No description provided for @oF.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get oF;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @groupName.
  ///
  /// In en, this message translates to:
  /// **'Group name'**
  String get groupName;

  /// No description provided for @addContact.
  ///
  /// In en, this message translates to:
  /// **'Add contact'**
  String get addContact;

  /// No description provided for @groupCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Group created successfully'**
  String get groupCreatedSuccessfully;

  /// No description provided for @aboutGroup.
  ///
  /// In en, this message translates to:
  /// **'About group (optional)'**
  String get aboutGroup;

  /// No description provided for @aboutGroupMsg.
  ///
  /// In en, this message translates to:
  /// **'Hello, it\'s us on Conversas'**
  String get aboutGroupMsg;

  /// No description provided for @individualChats.
  ///
  /// In en, this message translates to:
  /// **'Individual Chats'**
  String get individualChats;

  /// No description provided for @groupChats.
  ///
  /// In en, this message translates to:
  /// **'Group Chats'**
  String get groupChats;

  /// No description provided for @thereIsNoGroupYet.
  ///
  /// In en, this message translates to:
  /// **'There is no group yet, create one'**
  String get thereIsNoGroupYet;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @groupInfo.
  ///
  /// In en, this message translates to:
  /// **'Group Info'**
  String get groupInfo;

  /// No description provided for @lastActivity.
  ///
  /// In en, this message translates to:
  /// **'Last activity'**
  String get lastActivity;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @updateGroup.
  ///
  /// In en, this message translates to:
  /// **'Update Group'**
  String get updateGroup;

  /// No description provided for @groupDescription.
  ///
  /// In en, this message translates to:
  /// **'Add Group Description'**
  String get groupDescription;

  /// No description provided for @groupUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Group updated successfully'**
  String get groupUpdatedSuccessfully;

  /// No description provided for @participantsPlural.
  ///
  /// In en, this message translates to:
  /// **'{count,plural,=0{1 Participant} =1{Participant 1} other{{count} Participants}}'**
  String participantsPlural(num count);

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get joined;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @createdBy.
  ///
  /// In en, this message translates to:
  /// **'Created by'**
  String get createdBy;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @deleteGroup.
  ///
  /// In en, this message translates to:
  /// **'Delete Group'**
  String get deleteGroup;

  /// No description provided for @areYouSureYouWantDeleteGroup.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {groupName} group? '**
  String areYouSureYouWantDeleteGroup(Object groupName);

  /// No description provided for @areYouSureYouWantExitGroup.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit {groupName} group? '**
  String areYouSureYouWantExitGroup(Object groupName);

  /// No description provided for @areYouSureYouWantRemoveUserFromGroup.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this user from group?'**
  String get areYouSureYouWantRemoveUserFromGroup;

  /// No description provided for @areYouSureYouWantMakeAdminGroup.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to make this user group admin?'**
  String get areYouSureYouWantMakeAdminGroup;

  /// No description provided for @areYouSureYouWantRemoveAdmin.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this user as admin?'**
  String get areYouSureYouWantRemoveAdmin;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @makeGroupAdmin.
  ///
  /// In en, this message translates to:
  /// **'Make Group Admin'**
  String get makeGroupAdmin;

  /// No description provided for @removeAsGroupAdmin.
  ///
  /// In en, this message translates to:
  /// **'Remove as Group Admin'**
  String get removeAsGroupAdmin;

  /// No description provided for @removeFromGroup.
  ///
  /// In en, this message translates to:
  /// **'Remove from Group'**
  String get removeFromGroup;

  /// No description provided for @userRemoveFromGroup.
  ///
  /// In en, this message translates to:
  /// **'User remove from Group'**
  String get userRemoveFromGroup;

  /// No description provided for @userAddedAsGroupAdmin.
  ///
  /// In en, this message translates to:
  /// **'User added as Group Admin'**
  String get userAddedAsGroupAdmin;

  /// No description provided for @userRemovedAsGroupAdmin.
  ///
  /// In en, this message translates to:
  /// **'User removed as Group Admin'**
  String get userRemovedAsGroupAdmin;

  /// No description provided for @exitGroup.
  ///
  /// In en, this message translates to:
  /// **'Exit Group'**
  String get exitGroup;

  /// No description provided for @groupDeleted.
  ///
  /// In en, this message translates to:
  /// **'Group deleted successfully'**
  String get groupDeleted;

  /// No description provided for @exitGroupSuccess.
  ///
  /// In en, this message translates to:
  /// **'Exited from Group successfully'**
  String get exitGroupSuccess;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
