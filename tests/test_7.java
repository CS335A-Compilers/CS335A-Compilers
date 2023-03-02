package expression.swtch;
import example.switch_expression;    
import java.example;
public class check {
    public static void check(String[] args) {
        int month = 1;
        /** Multiline comment 
         * present here
         * ////
         */
        int good_days = switch (month) {
            case 1,2,7,12 -> 6;
            case 3,4,6 -> 9;
            default -> {
                String msg = "No good day for you ";
                throw new Exception(message);
            }
        };

        int bits = 2;
        String quality;
        switch (bits) {
            case 1: 
                quality = "good";
                break;
            case 2:
                quality = "bad";
                break;
            default:
                quality = "can't say anything";
        }
    }
}