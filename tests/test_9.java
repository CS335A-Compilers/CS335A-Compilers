public private class best_class { //should throw error for public private class best_class 
    public void main() {
        
        public int a,b,sum,c; //throw error for Modifier public not allowed in field variable declaration
        a=8;
        b=a+3;
        sum=a+b;
        c=true?a:"Hello";//should throw error for invalid types for assignment, cannot convert from "string" to int"       
       
    }
    
}
