import localvariable.exapmle;

public class Main {
    public static void main(String[] args) {

        var url = new URL("http://www.example.com/"); 
        var conn = url.openConnection(); 
        var reader = new BufferedReader(
            new InputStreamReader(conn.getInputStream()));
        var message = "Gn"; 
        var today = LocalDate.now(); 
        var names = List.of("Cat","Dog");
        for (var name : names) {
            System.out.println("Hello, " + name + "!");
        }
 }
}

public class SwitchExample {
    public static void main(String[] args) {
        Travel mode = Travel.Train;
        int result = switch (mode) {
            case Train -> {
                yield 1;
            }
            case Flight -> {
                yield 2;
            }
            default -> {
                yield 0;
            }
        };
        int i =6;
        while (i < 10) {
            text += "The number is " + i;
            i++;
            }
        int[] numbers = {1, 2, 3, 4};
        for (int i = 0; i < numbers.length; i++) {
            try {
                int ans = 10 / numbers[i];
                System.out.println("ans: " + result);
            } catch (ArithmeticException e) {
                System.out.println("Error: " + e.getMessage());
            }
        }
    }
}
