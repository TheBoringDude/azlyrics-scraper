import 'package:wyly/src/azlyrics.dart';

void main(List<String> arguments) async {
  var a = AzLyrics();

  final result = await a.search_lyrics('sample');

  for (var i in result) {
    print(i);
  }
}
