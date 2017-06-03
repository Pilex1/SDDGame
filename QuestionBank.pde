import java.util.*;

class QuestionBank {

  ArrayList<LatinEnglishPair> questions;

  QuestionBank(String textFile) {

    questions = new ArrayList<LatinEnglishPair>();

    // hashset for making sure we do not get duplicate entries for latin vocab
    // all latin vocab that has been loaded is stored here
    // just for error checking - not actually important
    HashSet set = new HashSet();

    BufferedReader reader = createReader(textFile);  
    String line;
    try {
      while ((line = reader.readLine()) != null) {
        // parses input string

        // check that the string is in the correct format first
        if (isValid(line)) {
          String[] arr = line.split(";");
          String latin = arr[0];
          String[] english = arr[1].split(",");

          // assert that we do not have a duplicate entry for latin vocab
          assert set.contains(latin) == false;
          set.add(latin);

          LatinEnglishPair pair = new LatinEnglishPair(latin, english);
          questions.add(pair);
        }
      }
    } 
    catch (IOException e) {
      println(e);
    }
  }

  // returns whether the given line is in the correct format to be parsed for Latin to ENglish translations
  boolean isValid(String line) {
    String[] arr = line.split(";");
    if (arr.length != 2) return false;
    return true;
  }
}

class LatinEnglishPair {

  String latin;
  String[] englishTranslations;

  LatinEnglishPair(String latin, String[] englishTranslations) {
    this.latin = latin;
    this.englishTranslations = englishTranslations;
  }
}