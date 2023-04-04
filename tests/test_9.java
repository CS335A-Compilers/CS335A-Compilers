class arrays {  

    public int findSum(){
        int sum = 0;
        int arr[] = new int[5];
        for(int i=0;i<5;i++){
            sum += arr[i];
        }
        return sum;
    }

    public void main() {
        int sum = findSum();
        
    }
}
