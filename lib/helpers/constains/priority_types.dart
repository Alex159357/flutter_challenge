

enum PriorityTypes{
  HIGH, MIDDLE, LOW;

  factory PriorityTypes.fromId(int val) {
    switch(val){
      case 1: return PriorityTypes.MIDDLE;
      case 2: return PriorityTypes.HIGH;
      default: return PriorityTypes.LOW;
    }
  }

}

extension Value on PriorityTypes{

  String getName(){
    switch(this) {
      case PriorityTypes.HIGH:
        return "High";
      case PriorityTypes.MIDDLE:
        return "Middle";
      case PriorityTypes.LOW:
        return "Low";
    }
  }

  int getId(){
    switch(this) {
      case PriorityTypes.HIGH:
        return 2;
      case PriorityTypes.MIDDLE:
        return 1;
      case PriorityTypes.LOW:
        return 0;
    }
  }

}