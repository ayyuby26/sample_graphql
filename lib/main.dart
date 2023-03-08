import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sample_graphql/utils.dart';

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

  final controller = TextEditingController(text: r"""
        query ExampleQuery($limit: Int) {
          rockets(limit: $limit) {
            company
            name
            mass {
              kg
            }
          }
        }
""");

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
            const Divider(),
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
        options: QueryOptions(document: gql(widget.controller.text)),
        builder: (result, {fetchMore, refetch}) {
          return Column(
            children: [
              Expanded(
                child: (result.data != null)
                    ? ListView(
                        children: [
                          Text((jsonPretty(deleteTypeName(result.data!))))
                        ],
                      )
                    : Center(
                        child: result.hasException
                            ? Text("${result.exception}")
                            : const CircularProgressIndicator()),
              ),
              Padding(
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
                        child: const Text("Re-Fetch")),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
