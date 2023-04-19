class recursives {

    public int fib(int n){
        if(n <= 3) return 1;
        else return fib(n-1) * fib(n-2) + fib(n-3)*n;
    }

    public void main() {
        int f = fib(6);
        System.out.println(f);
    }
}