final class best_class {
    int i,j;
    boolean b;
    long l;
    best_class(int x){
        i = x*5;
    }
    public void main() {
        best_class tt = new best_class(5+6);
        tt.b = true;
        if(tt.b)
            tt.l = tt.i;
        else tt.l = tt.j;
    }
}
