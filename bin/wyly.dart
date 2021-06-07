import 'package:wyly/src/azlyrics.dart';

void main(List<String> arguments) async {
  var a = AzLyrics();

  final result = await a.search_songs('sample');

  for (var i in result) {
    print(i);
  }
}
