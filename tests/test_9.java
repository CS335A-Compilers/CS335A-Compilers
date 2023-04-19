class Arrays {  
    public static int findSum(){
        int sum = 0;
        int arr[] = new int[5];
        for(int i=0;i<5;i++){
            arr[i] = 2*i+1;
            // sum{1 3 5 7 9} = 25
        }
        for(int i=0;i<5;i++){
            sum += arr[i];
        }
        return sum;
    }

    public static void main(String [] args) {
        int sum = findSum();
        System.out.println(sum); 
    }
}
