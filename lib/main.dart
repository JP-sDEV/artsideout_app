import 'package:flutter/material.dart';
// Theme and Settings
import 'package:artsideout_app/theme.dart';
import 'package:artsideout_app/layout.dart';
// GraphQL
import 'package:graphql_flutter/graphql_flutter.dart';
import "package:artsideout_app/graphql/config.dart";

// Routing
import 'package:artsideout_app/routing/router.dart';
// import 'package:artsideout_app/routing/routing_constants.dart';

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
        client: graphQLConfiguration.client,
        child: MaterialApp(
          title: 'ARTSIDEOUT',
          theme: appTheme,
          home: Layout(),
          // initialRoute: Routes.home,
          onGenerateRoute: Router.generateRoute,
        ));
  }
}
