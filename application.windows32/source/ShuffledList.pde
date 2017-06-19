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
  
  ShuffledList() {
    this(new ArrayList<T>());
  }

  ShuffledList(ArrayList<T> originalList) {
    
    firstHalf = new ArrayList<T>();
    secondHalf = new ArrayList<T>();
    
    Collections.shuffle(originalList);
    
    // adding elements
    for (T t : originalList) {
      add(t);
    }
    
    shuffle();
  }
  
  // size of the shuffled list
  int size() {
    return firstHalf.size() + secondHalf.size();
  }

  // shuffles both halves.
  void shuffle() {
    Collections.shuffle(firstHalf);
    Collections.shuffle(secondHalf);
  }
  
  // adds an element to the shuffled list
  void add(T t) {
    if (firstHalf.size() <= secondHalf.size()) {
     firstHalf.add(t); 
    }else{
     secondHalf.add(t); 
    }
  }
  
  // gets a random element
  T getRandom() {
    T result;
    if (random(0, 1) < 0.5) {
      int index = int(random(firstHalf.size()));
      result = firstHalf.get(index);
    } else {
      int index = int(random(secondHalf.size()));
      result = secondHalf.get(index);
    }
    return result;
  }

  T getNext() {
    T result = null;
    if (firstIndex < firstHalf.size()) {
      result = firstHalf.get(firstIndex);
      firstIndex++;
    } else if (secondIndex < secondHalf.size()) {
      result = secondHalf.get(secondIndex);
      secondIndex++;
    } else {
     assert false; 
    }
    assert result != null;
    
    if (secondIndex == secondHalf.size()) {
      firstIndex = 0;
      secondIndex = 0;
      shuffle();
    }
    return result;
  }
}