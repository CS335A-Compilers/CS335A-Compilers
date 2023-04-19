class Operators {
    public static void main(String [] args){
        int x=1, y=2, z=3, f=4, m=5;
        // arthimetic operators
        x += (x+y*z)*(f + 4*x);
        System.out.println(x);
        y = (y+6*x)/(m+2);
        System.out.println(y);
        // Shift operators
        z <<= x + 6;
        System.out.println(z);
        // Bitwise operators
        m = ((f & z) | x) ^ y;
        System.out.println(m);
        // postfix expressions
        f = x++;
        System.out.println(f);
    }
}