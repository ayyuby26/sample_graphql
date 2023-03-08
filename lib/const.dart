const graphqlEndpoint = 'https://spacex-production.up.railway.app/';

const queryDefault = r"""
        query ExampleQuery($limit: Int) {
          rockets(limit: $limit) {
            company
            name
            mass {
              kg
            }
          }
        }
""";
