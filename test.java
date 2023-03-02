import java.lang.annotation.Target;
import java.lang.annotation.ElementType;

interface Foo {}
interface Bar {}

record Person(String name) {
    Person(String name) {
        this.name = name;
    }
}