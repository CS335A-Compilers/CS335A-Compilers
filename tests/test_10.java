class arrays {
    public static void main(String [] args) {
        int arr[] = new int[10];
        int sum = 0;
        for(int i=0;i<10;i++){
            arr[i] = i;
        }
        for(int i=0;i<10;i++){
            sum +=arr[i];
            arr[i] = arr[i-1] + sum;
        }
        for(int i=0;i<10;i++){
            System.out.println(arr[i]);
        }
        return ;
    }
}