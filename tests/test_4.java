class Classes {
    int x, y;

    public int add(int a, int b){
        return  a+b;
    }
    public static void main(String [] args){
        Classes f = new Classes();
        int a, b;
        f.x = 5;
        f.y = 6;
        a = (f.x * f.y)*2 + f.y;
        b = f.x + f.y;
        System.out.println(f.add(a,b));
    }
}