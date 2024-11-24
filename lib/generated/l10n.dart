// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Finished`
  String get finished_title {
    return Intl.message(
      'Finished',
      name: 'finished_title',
      desc: '',
      args: [],
    );
  }

  /// `You've reached the end of the quiz.`
  String get finished_desc {
    return Intl.message(
      'You\'ve reached the end of the quiz.',
      name: 'finished_desc',
      desc: '',
      args: [],
    );
  }

  /// `True`
  String get trueText {
    return Intl.message(
      'True',
      name: 'trueText',
      desc: '',
      args: [],
    );
  }

  /// `False`
  String get falseText {
    return Intl.message(
      'False',
      name: 'falseText',
      desc: '',
      args: [],
    );
  }

  /// `Quiz App`
  String get appName {
    return Intl.message(
      'Quiz App',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Register as`
  String get registerAs {
    return Intl.message(
      'Register as',
      name: 'registerAs',
      desc: '',
      args: [],
    );
  }

  /// `Admin`
  String get admin {
    return Intl.message(
      'Admin',
      name: 'admin',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get user {
    return Intl.message(
      'User',
      name: 'user',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `register`
  String get register {
    return Intl.message(
      'register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  String get yes {
    return Intl.message(
      'yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  String get no {
    return Intl.message(
      'no',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  String get areYouSure {
    return Intl.message(
      'areYouSure',
      name: 'areYouSure',
      desc: '',
      args: [],
    );
  }

  String get addQuestion {
    return Intl.message(
      'addQuestion',
      name: 'addQuestion',
      desc: '',
      args: [],
    );
  }

  String get choiceOne {
    return Intl.message(
      'choiceOne',
      name: 'choiceOne',
      desc: '',
      args: [],
    );
  }

  String get choiceTwo {
    return Intl.message(
      'choiceTwo',
      name: 'choiceTwo',
      desc: '',
      args: [],
    );
  }

  String get choiceThree {
    return Intl.message(
      'choiceThree',
      name: 'choiceThree',
      desc: '',
      args: [],
    );
  }

  String get choiceFour {
    return Intl.message(
      'choiceFour',
      name: 'choiceFour',
      desc: '',
      args: [],
    );
  }

  String get enterTheQuestion {
    return Intl.message(
      'enterTheQuestion',
      name: 'enterTheQuestion',
      desc: '',
      args: [],
    );
  }

  String get adminPanel {
    return Intl.message(
      'adminPanel',
      name: 'adminPanel',
      desc: '',
      args: [],
    );
  }

  String get analytics {
    return Intl.message(
      'analytics',
      name: 'analytics',
      desc: '',
      args: [],
    );
  }

  String get totalAdmins {
    return Intl.message(
      'totalAdmins',
      name: 'totalAdmins',
      desc: '',
      args: [],
    );
  }

  String get totalUsers {
    return Intl.message(
      'totalUsers',
      name: 'totalUsers',
      desc: '',
      args: [],
    );
  }

  String get yourQuestion {
    return Intl.message(
      'yourQuestion',
      name: 'yourQuestion',
      desc: '',
      args: [],
    );
  }

  String get choices {
    return Intl.message(
      'choices',
      name: 'choices',
      desc: '',
      args: [],
    );
  }

  String get selectTheCorrectAnswer {
    return Intl.message(
      'selectTheCorrectAnswer',
      name: 'selectTheCorrectAnswer',
      desc: '',
      args: [],
    );
  }

  String get selectTheQuestionRating {
    return Intl.message(
      'selectTheQuestionRating',
      name: 'selectTheQuestionRating',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
