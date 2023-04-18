class functions {
    public int func1(){
        return 5*5;
    }
    public int func2(int x){
        int z = x*5 + 6;
        return z;
    }
    public void main(){
        int temp = func2(5) + func1();
        System.out.println(temp);    
    }
}