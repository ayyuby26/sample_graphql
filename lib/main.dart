import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages, implementation_imports
import 'package:gql/src/ast/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sample_graphql/utils/utils.dart';

import 'const.dart';
import 'view/client/graphql_view.dart';

void main() async {
  await initHiveForFlutter();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final controller = TextEditingController(text: queryDefault);

  @override
  Widget build(BuildContext context) {
    return ClientProvider(
      uri: graphqlEndpoint,
      child: Scaffold(
        appBar: AppBar(title: const Text("Space X API Graphql")),
        body: Column(
          children: [
            const SizedBox(height: 16),
            const Text("Request"),
            TextField(
              controller: controller,
              minLines: 2,
              maxLines: 100,
            ),
            const SizedBox(height: 16),
            const Text("Response"),
            Expanded(child: SpaceX(controller))
          ],
        ),
      ),
    );
  }
}

class SpaceX extends StatefulWidget {
  final TextEditingController controller;
  const SpaceX(this.controller, {super.key});

  @override
  State<SpaceX> createState() => _SpaceXState();
}

class _SpaceXState extends State<SpaceX> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Query(
        options: QueryOptions(document: documentNodeHandler),
        builder: (result, {fetchMore, refetch}) {
          return Column(
            children: [
              Expanded(
                child:
                    result.data != null ? data(result) : dataNull(result),
              ),
              fetchBtn(refetch)
            ],
          );
        },
      ),
    );
  }

  DocumentNode get documentNodeHandler {
    try {
      return gql(widget.controller.text);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return const DocumentNode();
  }

  Widget data(QueryResult<Object?> result) {
    final data = deleteTypeName(result.data!);
    return ListView(
      children: [
        Text(jsonPretty(data)),
      ],
    );
  }

  Widget dataNull(QueryResult<Object?> result) {
    return Center(
      child: result.hasException
          ? Text("${result.exception}")
          : const CircularProgressIndicator(),
    );
  }

  Widget fetchBtn(Refetch<Object?>? refetch) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              if (refetch != null) {
                refetch();
                setState(() {});
              }
            },
            child: const Text("Re-Fetch"),
          ),
        ],
      ),
    );
  }
}
