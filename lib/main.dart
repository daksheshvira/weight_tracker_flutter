import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_tracker/bloc/auth/auth_bloc.dart';
import 'package:weight_tracker/bloc/nav/nav_bloc.dart';
import 'package:weight_tracker/bloc/nav/nav_state.dart';
import 'package:weight_tracker/services/auth_service.dart';
import 'package:weight_tracker/services/get_it_service.dart';
import 'package:weight_tracker/ui/theme/theme.dart';
import 'package:weight_tracker/ui/weight_tracker.dart';

import 'bloc/weight/weight_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  GetItService getIt = GetItService();
  getIt.setup();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage("lib/assets/weighttracker_logo.png"), context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (ctx) => AuthBloc(authService: AuthService()),
        ),
        BlocProvider(
          create: (ctx) => NavBloc(ShowNavState(currentIndex: 0)),
        ),
        BlocProvider(
          create: (ctx) => WeightBloc(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Weight Tracker',
          theme: defaultTheme,
          home: WeightTracker()),
    );
  }
}