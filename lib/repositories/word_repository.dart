import 'package:wordstock/model/word.dart';
import 'package:wordstock/repositories/mock_data.dart';

class WordRepository {
  Future<List<WordModel>> getWords() async {
    return mockWordModules;
  }
}
