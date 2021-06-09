import 'package:azlyrics/azlyrics.dart';

void main(List<String> arguments) async {
  var a = await AzLyrics.init('https://www.azlyrics.com/lyrics/justintimberlake/mirrors.html');

  print(a.singer);
  print(a.lyrics);
}
