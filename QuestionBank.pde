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
        String[] arr = line.split(";");
        String latin = arr[0];
        String[] english = arr[1].split(",");
        println(line);
        
        // assert that we do not have a duplicate entry for latin vocab
        assert set.contains(latin) == false;
        set.add(latin);
        
        LatinEnglishPair pair = new LatinEnglishPair(latin, english);
        questions.add(pair);
      }
    } 
    catch (IOException e) {
      println(e);
    }
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