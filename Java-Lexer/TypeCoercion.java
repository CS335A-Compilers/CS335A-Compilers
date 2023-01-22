public class TypeCoercion {
    public static void main(String[] args) {
        int intVar = 100;
        double floatVarr;
        floatVarr = 52.5e+9;
        floatVarr = 52.5-9;
        floatVarr = 52e+9;
        floatVarr = .526e6;
        floatVarr = .52e+9;

        String str = """
                hello \\ \\
                """;

        double dVar = 3.141596;
        long lVar = (long) dVar;
        int iVar = (int) dVar;

        System.out.println("Dummy print: " + (short) 3.14F);
    }
}
