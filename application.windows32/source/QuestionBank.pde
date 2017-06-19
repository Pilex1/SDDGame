  import java.util.*;

class QuestionBank {

  ShuffledList<LatinEnglishPair> questions;
  ShuffledList<LatinEnglishPair> incorrectAnswers;

  QuestionBank(String textFile) {

    // hashset for making sure we do not get duplicate entries for latin vocab
    // all latin vocab that has been loaded is stored here
    // just for error checking - not actually important
    HashSet set = new HashSet();

    ArrayList<LatinEnglishPair> l = new ArrayList<LatinEnglishPair>();
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
          assert set.contains(latin) == false : latin;
          set.add(latin);

          LatinEnglishPair pair = new LatinEnglishPair(latin, english);
          l.add(pair);
        }
      }
      questions = new ShuffledList<LatinEnglishPair>(l);
      incorrectAnswers = new ShuffledList<LatinEnglishPair>(l);
    } 
    catch (IOException e) {
      println(e);
      assert false;
    }
  }

  // returns whether the given line is in the correct format to be parsed for Latin to ENglish translations
  boolean isValid(String line) {
    String[] arr = line.split(";");
    if (arr.length != 2) return false;
    return true;
  }

  // generates a random multiple choice question and answers
  QuestionAnswerChoice generate() {
    LatinEnglishPair[] answers = new LatinEnglishPair[4];

    // generate the question and answer
    LatinEnglishPair questionPair = questions.getNext();
    answers[0] = questionPair;
    String question = questionPair.latin;
    String correctAnswer = questionPair.englishTranslations[int(random(questionPair.englishTranslations.length))];

    // generate 3 incorrect answers
    LatinEnglishPair incorrectPair1 = generateIncorrectAnswer(answers);
    answers[1] = incorrectPair1;
    String incorrect1 = incorrectPair1.englishTranslations[int(random(incorrectPair1.englishTranslations.length))];

    LatinEnglishPair incorrectPair2 = generateIncorrectAnswer(answers);
    answers[2] = incorrectPair2;
    String incorrect2 = incorrectPair2.englishTranslations[int(random(incorrectPair2.englishTranslations.length))];

    LatinEnglishPair incorrectPair3 = generateIncorrectAnswer(answers);
    answers[3] = incorrectPair3;
    String incorrect3 = incorrectPair3.englishTranslations[int(random(incorrectPair3.englishTranslations.length))];
    
    QuestionAnswerChoice choice = new QuestionAnswerChoice(question, correctAnswer, incorrect1, incorrect2, incorrect3);
    return choice;
  }

  // private method for generating an incorrect answer
  // the generated answer is guaranteed to not be an element in the input array
  LatinEnglishPair generateIncorrectAnswer(LatinEnglishPair[] excluding) {
    while (true) {    
      LatinEnglishPair pair = incorrectAnswers.getNext();

      // find a latinEnglish pair not in the excluded array
      for (LatinEnglishPair exclude : excluding) {
        if (exclude == pair) {
          // the exclude array contains the randomised element
          continue;
        }
      }
      
      boolean flag = false;
      
      // make sure that any of the English translations in the selected pair are not the same as any in the excluding array
      for (String english : pair.englishTranslations) {
        for (LatinEnglishPair p : excluding) {
          if (p == null) continue;
         for (String pEnglish : p.englishTranslations) {
          if (pEnglish.equals(english)) {
           flag = true; 
          }
         }
        }
      }
      
      if (flag) continue;
      
      return pair;
    }
  }
}

// represents a multiple choice question and answer option
// contains the question, four possible answers, and a reference to the correct answer
class QuestionAnswerChoice {

  String question;

  String answerA;
  String answerB;
  String answerC;
  String answerD;

  String correctAnswer;

  QuestionAnswerChoice(String question, String correctAnswer, String incorrect1, String incorrect2, String incorrect3) {
    this.question = question;
    this.correctAnswer = correctAnswer;
    ArrayList<String> l = new ArrayList<String>();
    l.add(correctAnswer);
    l.add(incorrect1);
    l.add(incorrect2);
    l.add(incorrect3);
    Collections.shuffle(l);

    answerA = l.get(0);
    answerB = l.get(1);
    answerC = l.get(2);
    answerD = l.get(3);
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