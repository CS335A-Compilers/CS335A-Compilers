class recursives {

    public int fib(int n){
        if(n <= 2) return 1;
        else return fib(n-1) + fib(n-2);
    }

    public void main() {
        int f = fib(6);
        System.out.println(f);
    }
}