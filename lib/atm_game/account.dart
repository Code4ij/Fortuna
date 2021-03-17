class Account{

  static final Account _instance = Account._internal();

  static double balance = 100000;
  static String password = "1234";

  factory Account(){
    return _instance;
  }
  Account._internal();

  void setPassword(pass){
    password = pass;
  }

  bool withdraw(amount){
    if(amount <= balance)
      return true;
    return false;
  }
}