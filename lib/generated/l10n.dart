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

  /// `Is Japan the country that consumes the most electricity.`
  String get question_1 {
    return Intl.message(
      'Is Japan the country that consumes the most electricity.',
      name: 'question_1',
      desc: '',
      args: [],
    );
  }

  /// `Covid 19 originated in America.`
  String get question_2 {
    return Intl.message(
      'Covid 19 originated in America.',
      name: 'question_2',
      desc: '',
      args: [],
    );
  }

  /// `The Amazon River is the longest river in South America.`
  String get question_3 {
    return Intl.message(
      'The Amazon River is the longest river in South America.',
      name: 'question_3',
      desc: '',
      args: [],
    );
  }

  /// `Ukraine is the largest country in Europe.`
  String get question_4 {
    return Intl.message(
      'Ukraine is the largest country in Europe.',
      name: 'question_4',
      desc: '',
      args: [],
    );
  }

  /// `Sweden is the richest country in islands.`
  String get question_5 {
    return Intl.message(
      'Sweden is the richest country in islands.',
      name: 'question_5',
      desc: '',
      args: [],
    );
  }

  /// `Mount Everest is located in Norway.`
  String get question_6 {
    return Intl.message(
      'Mount Everest is located in Norway.',
      name: 'question_6',
      desc: '',
      args: [],
    );
  }

  /// `Mount Everest is located in Nepal.`
  String get question_7 {
    return Intl.message(
      'Mount Everest is located in Nepal.',
      name: 'question_7',
      desc: '',
      args: [],
    );
  }

  /// `Is Türkiye considered one of the countries bordering the Black Sea.`
  String get question_8 {
    return Intl.message(
      'Is Türkiye considered one of the countries bordering the Black Sea.',
      name: 'question_8',
      desc: '',
      args: [],
    );
  }

  /// `Canberra is the capital of Australia.`
  String get question_9 {
    return Intl.message(
      'Canberra is the capital of Australia.',
      name: 'question_9',
      desc: '',
      args: [],
    );
  }

  /// `Alexander Fleming discovered penicillin in 1928.`
  String get question_10 {
    return Intl.message(
      'Alexander Fleming discovered penicillin in 1928.',
      name: 'question_10',
      desc: '',
      args: [],
    );
  }

  /// `The femur is the strongest bone in the human body.`
  String get question_11 {
    return Intl.message(
      'The femur is the strongest bone in the human body.',
      name: 'question_11',
      desc: '',
      args: [],
    );
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
