class test {
    int x = 5;
    public static void do_some(int a, int b){
        x = b*5 + 2;
        a = a  + 1;
    }
    public static void main(){
        int x=1, z = 5;
        x++;
        do_some(5 , 6);
        x = 5 + 6*9 + 6;
    }
}