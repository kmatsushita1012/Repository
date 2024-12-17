import 'package:http/http.dart' as http;

Future<http.Response> mockAPI(http.Request request) async {
  if (request.url.queryParameters.containsValue('500')) {
    //一般的なエラー
    return http.Response('', 500);
  } else if (request.url.queryParameters.containsValue('422')) {
    //不適切なクエリのエラー
    return http.Response('', 422);
  } else if (request.url.queryParameters.containsValue('204')) {
    //不適切なクエリのエラー
    return http.Response('''{
          "total_count": 0,
          "items": [
            ]
          }''', 200);
  }
  //正常なリクエスト
  return http.Response('''{
          "total_count": 1,
          "items": [
            {
              "id": 1,
              "name": "q",
              "stargazers_count": 100,
              "watchers_count": 100,
              "forks_count": 10,
              "open_issues_count": 5,
              "owner": {
                "avatar_url": "https://avatars.githubusercontent.com/u/60294?v=4"
              },
              "size": 1428,
              "stargazers_count": 14927,
              "watchers_count": 14927,
              "language": "JavaScript",
              "forks_count": 1199,
              "open_issues_count": 116,
              "forks": 1199,
              "open_issues": 116,
              "watchers": 14927
            }
          ]
        }''', 200);
}
