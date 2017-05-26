class QuestionBank {

  HashMap<String, ArrayList<String>> questions;

  QuestionBank(String textFile) {

    questions = new HashMap<String, ArrayList<String>>();

    BufferedReader reader = createReader(textFile);  
    String line;
    try {
      while ((line = reader.readLine()) != null) {
        String[] arr = line.split(";");
       
      }
    } 
    catch (IOException e) {
    }
  }

  void loadQuestions() {
  }
}