package brett.testing.stuff;

class First {
	  public static void main(String[] arguments) {
	    System.out.println("Let's do something using Java technology.");
	  }
	}

/* CallingMethodsInSameClass.java
*
* illustrates how to call static methods a class
* from a method in the same class
*/

class CallingMethodsInSameClass
{
	public static void main(String[] args) {
		printOne();
		printOne();
		printTwo();
	}

	public static void printOne() {
		System.out.println("Hello World");
	}

	public static void printTwo() {
		printOne();
		printOne();
	}
}
