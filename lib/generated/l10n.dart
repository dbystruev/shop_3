// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

class S {
  S(this.localeName);
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final String name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return S(localeName);
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  final String localeName;

  String get homeTitle {
    return Intl.message(
      'Home',
      name: 'homeTitle',
      desc: '',
      args: [],
    );
  }

  String get catTitle {
    return Intl.message(
      'Categories',
      name: 'catTitle',
      desc: '',
      args: [],
    );
  }

  String get offerTitle {
    return Intl.message(
      'Offers',
      name: 'offerTitle',
      desc: '',
      args: [],
    );
  }

  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  String get categoriesNotFound {
    return Intl.message(
      'Categories not found',
      name: 'categoriesNotFound',
      desc: '',
      args: [],
    );
  }

  String get category {
    return Intl.message(
      'Category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  String get cross {
    return Intl.message(
      'Sneakers',
      name: 'cross',
      desc: '',
      args: [],
    );
  }

  String get pants {
    return Intl.message(
      'Track pants',
      name: 'pants',
      desc: '',
      args: [],
    );
  }

  String get jacket {
    return Intl.message(
      'Jumpers',
      name: 'jacket',
      desc: '',
      args: [],
    );
  }

  String get offerLoadError {
    return Intl.message(
      'Unable to load offers',
      name: 'offerLoadError',
      desc: '',
      args: [],
    );
  }

  String get offerId {
    return Intl.message(
      'ID',
      name: 'offerId',
      desc: '',
      args: [],
    );
  }

  String get model {
    return Intl.message(
      'Model',
      name: 'model',
      desc: '',
      args: [],
    );
  }

  String get warranty {
    return Intl.message(
      'Warranty',
      name: 'warranty',
      desc: '',
      args: [],
    );
  }

  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  String get vendor {
    return Intl.message(
      'Vendor',
      name: 'vendor',
      desc: '',
      args: [],
    );
  }

  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  String get property {
    return Intl.message(
      'Property',
      name: 'property',
      desc: '',
      args: [],
    );
  }

  String get value {
    return Intl.message(
      'Value',
      name: 'value',
      desc: '',
      args: [],
    );
  }

  String get notes {
    return Intl.message(
      'Notes',
      name: 'notes',
      desc: '',
      args: [],
    );
  }

  String get buy {
    return Intl.message(
      'Buy',
      name: 'buy',
      desc: '',
      args: [],
    );
  }

  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  String get offerName {
    return Intl.message(
      'Name',
      name: 'offerName',
      desc: '',
      args: [],
    );
  }

  String get minPrice {
    return Intl.message(
      'Min price',
      name: 'minPrice',
      desc: '',
      args: [],
    );
  }

  String get maxPrice {
    return Intl.message(
      'Max price',
      name: 'maxPrice',
      desc: '',
      args: [],
    );
  }

  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  String get offersNotFound {
    return Intl.message(
      'Offers not found',
      name: 'offersNotFound',
      desc: '',
      args: [],
    );
  }

  String get offer {
    return Intl.message(
      'Offer',
      name: 'offer',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'), Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (Locale supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}