class Completeness {
    public static void main(String[] args) {
        int a=0, b=1, c=2, d=3, e=4, f=5, g=6;
        a = a & b;
        System.out.println(a);
        b *= a*c;
        System.out.println(b);
        d = ~(a+b*d);
        System.out.println(d);
        e = (a*b)+c*d*e*f*g;
        System.out.println(e);
        b = a--;
        System.out.println(b);
        c = ++a;
        System.out.println(++c);
        d <<= b;
        System.out.println(++d);
        e >>= a;
        System.out.println(++e);
        
    }
}