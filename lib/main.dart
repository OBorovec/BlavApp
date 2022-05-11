import 'package:blavapp/bloc/auth/auth_bloc.dart';
import 'package:blavapp/bloc/localization/localization_bloc.dart';
import 'package:blavapp/bloc/theme/theme_bloc.dart';
import 'package:blavapp/bloc/user_data/user_data_bloc.dart';
import 'package:blavapp/bloc/user_prems/user_prems_bloc.dart';
import 'package:blavapp/route_generator.dart';
import 'package:blavapp/services/auth_repo.dart';
import 'package:blavapp/services/prefs_repo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocOverrides.runZoned(
    () => runApp(const BlavApp()),
    blocObserver: AppBlocObserver(),
  );
}

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print(change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

class BlavApp extends StatefulWidget {
  const BlavApp({Key? key}) : super(key: key);

  @override
  State<BlavApp> createState() => _BlavAppState();
}

class _BlavAppState extends State<BlavApp> {
  late final Future<List> _future = Future.wait(
    [
      SharedPreferences.getInstance(),
      Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return _buildMaterialError(snapshot.error.toString());
        } else if (snapshot.connectionState == ConnectionState.done) {
          final SharedPreferences sharedPreferences =
              snapshot.requireData[0] as SharedPreferences;
          // final FirebaseApp firebaseApp =
          //     snapshot.requireData[1] as FirebaseApp;
          return MultiRepositoryProvider(
            providers: [
              RepositoryProvider(
                create: (context) => PrefsRepo(sharedPreferences),
              ),
              RepositoryProvider(
                create: (context) => AuthRepo(),
              ),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => LocalizationBloc(
                    prefs: context.read<PrefsRepo>(),
                    initState: LocalizationBloc.loadLang(
                      context.read<PrefsRepo>(),
                    ),
                  ),
                ),
                BlocProvider(
                  create: (context) => ThemeBloc(
                    prefs: context.read<PrefsRepo>(),
                    initState: ThemeBloc.loadTheme(
                      context.read<PrefsRepo>(),
                    ),
                  ),
                ),
                BlocProvider(
                  create: (context) => AuthBloc(
                    authRepo: context.read<AuthRepo>(),
                  ),
                ),
              ],
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => UserDataBloc(
                      authBloc: context.read<AuthBloc>(),
                    ),
                  ),
                  BlocProvider(
                    create: (context) => UserPremsBloc(
                      authBloc: context.read<AuthBloc>(),
                    ),
                  ),
                  BlocProvider(
                    create: (context) => UserDataBloc(
                      authBloc: context.read<AuthBloc>(),
                    ),
                  )
                ],
                child: BlocBuilder<ThemeBloc, ThemeState>(
                  builder: (context, themeState) {
                    return BlocBuilder<LocalizationBloc, LocalizationState>(
                      builder: (context, localizationState) {
                        return BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, authState) {
                            return _buildMaterialApp(
                              context,
                              themeState,
                              localizationState,
                              authState,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildMaterialApp(
    BuildContext context,
    ThemeState themeState,
    LocalizationState localizationState,
    AuthState authState,
  ) {
    return MaterialApp(
      title: 'BlavApp',
      theme: themeState.themeData,
      locale: localizationState.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      initialRoute: RoutePaths.gwint,
      onGenerateRoute: (settings) => RouteGenerator.generateRoute(
        settings,
        authState is UserAuthenticated,
        false, // TODO: load from user permissions
      ),
    );
  }

  Widget _buildMaterialError(
    String message,
  ) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(message),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
