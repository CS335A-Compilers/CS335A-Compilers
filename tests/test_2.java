class Constructs {
    public static void main(String [] args){
        int x = 5;
        while(x > 0){
            System.out.println(x);
            x--;
        }
        for(int i=0;i<10;i++){
            if(i%2 == 0) continue;
            System.out.println(i);
        }
        x = 5;
        do{
            x++;
            System.out.println(x);
            if(x > 10) break;
        }
        while(true);
        x = 10;
        if(x > 5){
            System.out.println(-1);
        }
        else if(x==5){
            System.out.println(5);
        }
        else {
            System.out.println(1);
        }
        return ;
    }
}