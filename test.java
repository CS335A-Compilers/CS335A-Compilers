interface Sayable{  
    void say();  
}  
public class InstanceMethodReference {  
    public void saySomething(){  
        System.out.println("Hello, this is non-static method.");  
    }  
    public static void main(String[] args) {  
        InstanceMethodReference methodReference = new InstanceMethodReference(); // Creating object  
        Sayable sayable = methodReference.typenames::saySomething;  
        Sayable sayable2 = super ::saySomething;  
        Sayable sayable4 = super ::<T>saySomething ;  
    }  
}  
