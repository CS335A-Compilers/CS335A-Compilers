package last.example;
import com.Fun.*;

public class School {
    School(){System.out.println("School is created");}  
    
    public static void main(String[] args) {
        School s=new School();
        s.display();  
        Scanner input = new Scanner(System.in);
        int num;
        do {
            num = input.nextInt();
            try {
                if (num <= 0) {
                    throw new IllegalArgumentException("Number cannot be negative");
                }
                System.out.println("Input is  " + num);
            } catch (IllegalArgumentException e) {
                System.out.println("Error: " + e.getMessage());
            }
        } while (num <= 0);

    }
}