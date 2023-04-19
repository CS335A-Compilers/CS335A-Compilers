class FieldVariables {
    int x, y;
    public static void main(String [] args){
        FieldVariables f = new FieldVariables();
        f.x = 5;
        f.y = 6;
        f.x = (f.x + f.y)*2 + f.y;
        System.out.println(f.x);
    }
}