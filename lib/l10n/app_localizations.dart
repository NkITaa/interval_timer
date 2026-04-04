import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fi'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('nb'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('sv'),
    Locale('tr'),
    Locale('uk'),
    Locale('zh'),
  ];

  /// No description provided for @tap_tutorial.
  ///
  /// In en, this message translates to:
  /// **'If you click on the number you can set the values in more detail.'**
  String get tap_tutorial;

  /// No description provided for @restart_app.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get restart_app;

  /// No description provided for @training.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get training;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @sets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get sets;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @countdown.
  ///
  /// In en, this message translates to:
  /// **'Countdown'**
  String get countdown;

  /// No description provided for @countdown_description.
  ///
  /// In en, this message translates to:
  /// **'The countdown beeps before a new interval.'**
  String get countdown_description;

  /// No description provided for @system_language.
  ///
  /// In en, this message translates to:
  /// **'System Language'**
  String get system_language;

  /// No description provided for @system_default.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get system_default;

  /// No description provided for @dialog_required_field.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name!'**
  String get dialog_required_field;

  /// No description provided for @start_workout.
  ///
  /// In en, this message translates to:
  /// **'Start Workout'**
  String get start_workout;

  /// No description provided for @save_workout.
  ///
  /// In en, this message translates to:
  /// **'Save Workout'**
  String get save_workout;

  /// No description provided for @workout_training_time.
  ///
  /// In en, this message translates to:
  /// **'Set Training Time'**
  String get workout_training_time;

  /// No description provided for @workout_training_time_save.
  ///
  /// In en, this message translates to:
  /// **'Save Training Time'**
  String get workout_training_time_save;

  /// No description provided for @workout_edited.
  ///
  /// In en, this message translates to:
  /// **'Workout edited'**
  String get workout_edited;

  /// No description provided for @workout_added.
  ///
  /// In en, this message translates to:
  /// **'Workout added'**
  String get workout_added;

  /// No description provided for @workout_pause_time.
  ///
  /// In en, this message translates to:
  /// **'Set Pause Time'**
  String get workout_pause_time;

  /// No description provided for @workout_pause_time_save.
  ///
  /// In en, this message translates to:
  /// **'Save Pause Time'**
  String get workout_pause_time_save;

  /// No description provided for @workout_sets.
  ///
  /// In en, this message translates to:
  /// **'Set Number'**
  String get workout_sets;

  /// No description provided for @workout_sets_save.
  ///
  /// In en, this message translates to:
  /// **'Save Set Number'**
  String get workout_sets_save;

  /// No description provided for @title_workouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get title_workouts;

  /// No description provided for @workouts_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get workouts_search;

  /// No description provided for @workouts_search_no_results_one.
  ///
  /// In en, this message translates to:
  /// **'no workouts available'**
  String get workouts_search_no_results_one;

  /// No description provided for @workouts_search_no_results_two.
  ///
  /// In en, this message translates to:
  /// **'Create your first workout now and start your training!'**
  String get workouts_search_no_results_two;

  /// No description provided for @workouts_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit Workout'**
  String get workouts_edit;

  /// No description provided for @workouts_create.
  ///
  /// In en, this message translates to:
  /// **'Create Workout'**
  String get workouts_create;

  /// No description provided for @workouts_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete Workout'**
  String get workouts_delete;

  /// No description provided for @workouts_save.
  ///
  /// In en, this message translates to:
  /// **'Save Workout'**
  String get workouts_save;

  /// No description provided for @workouts_delete_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this workout? This action cannot be undone.'**
  String get workouts_delete_confirm;

  /// No description provided for @workouts_delete_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get workouts_delete_cancel;

  /// No description provided for @workouts_delete_ok.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get workouts_delete_ok;

  /// No description provided for @workouts_add.
  ///
  /// In en, this message translates to:
  /// **'Add Workout'**
  String get workouts_add;

  /// No description provided for @workouts_duration.
  ///
  /// In en, this message translates to:
  /// **'Workout Duration'**
  String get workouts_duration;

  /// No description provided for @workouts_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get workouts_name;

  /// No description provided for @title_jump_in.
  ///
  /// In en, this message translates to:
  /// **'Quick Start'**
  String get title_jump_in;

  /// No description provided for @jump_in_total_time.
  ///
  /// In en, this message translates to:
  /// **'Total Time'**
  String get jump_in_total_time;

  /// No description provided for @jump_in_save_workout.
  ///
  /// In en, this message translates to:
  /// **'Save as Workout'**
  String get jump_in_save_workout;

  /// No description provided for @run_preparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get run_preparing;

  /// No description provided for @run_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get run_skip;

  /// No description provided for @run_remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining Time'**
  String get run_remaining;

  /// No description provided for @run_set_from_one.
  ///
  /// In en, this message translates to:
  /// **'Set: '**
  String get run_set_from_one;

  /// No description provided for @run_set_from_two.
  ///
  /// In en, this message translates to:
  /// **' of '**
  String get run_set_from_two;

  /// No description provided for @run_finish_one.
  ///
  /// In en, this message translates to:
  /// **'Training successfully completed!'**
  String get run_finish_one;

  /// No description provided for @run_finish_two.
  ///
  /// In en, this message translates to:
  /// **'Training Duration: '**
  String get run_finish_two;

  /// No description provided for @run_home.
  ///
  /// In en, this message translates to:
  /// **'Back Home'**
  String get run_home;

  /// No description provided for @run_resume_workout.
  ///
  /// In en, this message translates to:
  /// **'Resume Workout'**
  String get run_resume_workout;

  /// No description provided for @run_exit_workout.
  ///
  /// In en, this message translates to:
  /// **'End Workout'**
  String get run_exit_workout;

  /// No description provided for @run_exit_workout_info.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to end the workout? Your progress will not be saved.'**
  String get run_exit_workout_info;

  /// No description provided for @title_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get title_profile;

  /// No description provided for @profile_rate_us.
  ///
  /// In en, this message translates to:
  /// **'Rate us'**
  String get profile_rate_us;

  /// No description provided for @profile_settings.
  ///
  /// In en, this message translates to:
  /// **'System Settings'**
  String get profile_settings;

  /// No description provided for @profile_settings_darkmode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get profile_settings_darkmode;

  /// No description provided for @profile_settings_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profile_settings_language;

  /// No description provided for @profile_settings_sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get profile_settings_sound;

  /// No description provided for @profile_settings_vibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get profile_settings_vibration;

  /// No description provided for @profile_help.
  ///
  /// In en, this message translates to:
  /// **'Help and Contact'**
  String get profile_help;

  /// No description provided for @profile_help_faq.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get profile_help_faq;

  /// No description provided for @profile_help_feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get profile_help_feedback;

  /// No description provided for @profile_help_info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get profile_help_info;

  /// No description provided for @profile_legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get profile_legal;

  /// No description provided for @profile_legal_privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get profile_legal_privacy;

  /// No description provided for @profile_legal_imprint.
  ///
  /// In en, this message translates to:
  /// **'Imprint'**
  String get profile_legal_imprint;

  /// No description provided for @profile_legal_terms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get profile_legal_terms;

  /// No description provided for @profile_settings_sound_dialog.
  ///
  /// In en, this message translates to:
  /// **'Select Sound'**
  String get profile_settings_sound_dialog;

  /// No description provided for @error_not_enough_space.
  ///
  /// In en, this message translates to:
  /// **'Not Enough Space on Device'**
  String get error_not_enough_space;

  /// No description provided for @onboarding_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboarding_skip;

  /// No description provided for @onboarding_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboarding_next;

  /// No description provided for @onboarding_get_started.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboarding_get_started;

  /// No description provided for @onboarding_welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Interval Timer'**
  String get onboarding_welcome;

  /// No description provided for @onboarding_welcome_desc.
  ///
  /// In en, this message translates to:
  /// **'Your personal companion for interval training. Set your pace, stay on track, and crush your goals.'**
  String get onboarding_welcome_desc;

  /// No description provided for @onboarding_features_title.
  ///
  /// In en, this message translates to:
  /// **'How It Works'**
  String get onboarding_features_title;

  /// No description provided for @onboarding_features_desc.
  ///
  /// In en, this message translates to:
  /// **'Configure your workout in three simple steps.'**
  String get onboarding_features_desc;

  /// No description provided for @onboarding_feature_training.
  ///
  /// In en, this message translates to:
  /// **'Set your active training duration'**
  String get onboarding_feature_training;

  /// No description provided for @onboarding_feature_pause.
  ///
  /// In en, this message translates to:
  /// **'Define your rest period between sets'**
  String get onboarding_feature_pause;

  /// No description provided for @onboarding_feature_sets.
  ///
  /// In en, this message translates to:
  /// **'Choose how many rounds to complete'**
  String get onboarding_feature_sets;

  /// No description provided for @onboarding_ready_title.
  ///
  /// In en, this message translates to:
  /// **'Ready to Train?'**
  String get onboarding_ready_title;

  /// No description provided for @onboarding_ready_desc.
  ///
  /// In en, this message translates to:
  /// **'Set up your first interval workout and get moving. You can always save your favorite routines for later.'**
  String get onboarding_ready_desc;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'cs',
    'da',
    'de',
    'en',
    'es',
    'fi',
    'fr',
    'hi',
    'it',
    'ja',
    'ko',
    'nb',
    'nl',
    'pl',
    'pt',
    'ru',
    'sv',
    'tr',
    'uk',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'nb':
      return AppLocalizationsNb();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'sv':
      return AppLocalizationsSv();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
