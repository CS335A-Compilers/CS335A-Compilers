public class TypeCoercion {
    public static void main(String[] args) {
        int intVar = 100;
        long longVar = intVar;
        float floatVar = longVar;
        double doubleVar = longVar;

        double dVar = 3.141596;
        long lVar = (long) dVar;
        int iVar = (int) dVar;

        System.out.println("Dummy print: " + (short) 3.14F);

        double exp = intVar + longVar + dVar * floatVar + lVar + doubleVar + iVar;
        System.out.println("Exp: " + exp);
    }
}
