import 'package:audioplayers/audio_cache.dart';
import 'package:friendstrivia/resources/constances.dart';

final soundPlayer = AudioCache();

String addComma(int score) {
  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';
  return '$score'.replaceAllMapped(reg, mathFunc);
}

// Play Sounds
playCorrectSound(pID) {
  String sound2Play = (pID%3 == 0) ? kCorrectSound3 : (pID.isEven ? kCorrectSound1 : kCorrectSound2);
  soundPlayer.play(sound2Play);
}
playInCorrectSound() {
  soundPlayer.play(kInCorrectSound);
  soundPlayer.clearCache();
}
playFinishSound() {
  soundPlayer.play(kTimedOutSound);
  soundPlayer.clearCache();
}
