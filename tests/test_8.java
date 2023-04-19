class ClassesConstructs {
    int i,j;
    int x;
    public int sqr(int a){
        int y = a*a;
        return y;
    }
    public void main() {
        ClassesConstructs tt = new ClassesConstructs();
        tt.x = 69;
        tt.i = 21;
        int j = sqr(tt.x);
        int y = sqr(tt.i);
        System.out.println(j+y);
        System.out.println(tt.i);
        for(int i=0;true;i++){
            tt.i = tt.i + 1;
            if(i>10) break;
        }
        System.out.println(tt.i);
    }
}
