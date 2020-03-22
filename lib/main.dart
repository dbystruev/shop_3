import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:outfit_shop_client/api/category_client.dart';
import 'package:outfit_shop_client/generated/l10n.dart';
import 'package:outfit_shop_client/offer/bloc/offer_bloc.dart';
import 'package:outfit_shop_client/ui/main_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'api/offer_client.dart';
import 'category/bloc/category_bloc.dart';
import 'home/bloc/home_bloc.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(systemNavigationBarColor: Colors.black, systemNavigationBarIconBrightness: Brightness.light));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(OfferClient(), CategoryClient()),
        ),
        BlocProvider<CategorySearchBloc>(
         create: (context) => CategorySearchBloc(categoryClient: CategoryClient()),
        ),
        BlocProvider<OfferBloc>(
          create: (context) => OfferBloc(offerClient: OfferClient()),
        )
      ],
      child: MaterialApp(
        localizationsDelegates: [S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate
        ],
        supportedLocales: S.delegate.supportedLocales,
        title: 'Get Outfit',
        theme: ThemeData.dark(
        ),
        home: MainPage(),
      ),
    );

  }
}
