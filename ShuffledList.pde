// represents a data structure where the distribution of elements in a list seem "more random" by making it less random

// IMPLEMENTATION
// initialisation: 
//   the original list is divided into two halves
// 
// runtime: 
//   shuffle each of the two halves
//   all the elements in the first half are iterated through first, then the elements in the second half are iterated
//   process repeats again - i.e. shuffle two halves, iterate through first then second

// this ensure that given a list of length n, the same element k will not be iterated through until at least n/2 other elements have been iterated

class ShuffledList<T> {

  ArrayList<T> firstHalf;
  ArrayList<T> secondHalf;
  
  // stores where we are up to in each of the halves
  int firstIndex;
  int secondIndex;

  ShuffledList(ArrayList<T> originalList) {
    
    firstHalf = new ArrayList<T>();
    secondHalf = new ArrayList<T>();
    
    // splitting the original list
    for (int i = 0; i < originalList.size()/2; i++) {
      firstHalf.add(originalList.get(i));
    }
    for (int i = originalList.size()/2; i < originalList.size(); i++) {
      secondHalf.add(originalList.get(i));
    }
    
    shuffleList();
  }

  // private method to be called when both halves have been iterated through to shuffle both halves.
  void shuffleList() {
    Collections.shuffle(firstHalf);
    Collections.shuffle(secondHalf);
  }

  T getNext() {
    T result = null;
    if (firstIndex < firstHalf.size()) {
      result = firstHalf.get(firstIndex);
      firstIndex++;
    } else if (secondIndex < secondHalf.size()) {
      result = secondHalf.get(secondIndex);
      secondIndex++;
    }
    assert result != null;
    
    if (secondIndex == secondHalf.size()) {
      firstIndex = 0;
      secondIndex = 0;
      shuffleList();
    }
    return result;
  }
}