import java.datatypes.example;
public class Example {
    protected String account_details;
      private static void main(String[] args) {
        
        byte b = 8;        
        short s = -327; 
        int i = 2147483647; 
        long l = -9223372036854775808L; 
        float f = 3.4028235E38f; 
        double d = 1.5848; 
        char c = 'Z';
        boolean bool = false;
        int[] counting = new int[4];
        counting [0] = 1;
        counting [1] = 2;
        counting [2] = 3;
        counting [3] = 4;
        
        for (int i = 0; i < counting.length; i++) {
            System.out.println(counting [i]);
        }
       
    }
    public static void wildcard(List<?> list) {
        for (Object item : list) {
            System.out.println(item);
        }
    }
    public non-sealed class Square extends Shape {
           public double side;
     }   
    public sealed class Shape
     permits Circle, Square, Rectangle {
    }   
}
