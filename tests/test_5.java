class FunctionCalls {
    public static int func1(){
        return 5*5;
    }
    public static int func2(int x){
        int z = x*5 + 6;
        return z;
    }
    public static void main(String [] args){
        int temp = func2(5) + func1();
        System.out.println(temp);    
    }
}