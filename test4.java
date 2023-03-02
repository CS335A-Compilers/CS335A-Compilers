package com.example.latest;


public class Latest {

    public static Integer divideBy2(Integer x) {
        return x / 2;
    }

    public static void main(String[] args) {
        List<Integer> list = new ArrayList<>();
        list.add(4);
        list.add(5);
        list.add(7);

        // Assuming func2 takes a list and a function as arguments
        func2(list, new Function<Integer, String>() {
            public String apply(Integer i) {
                return OpsUtil.doHalf(i).toString();
            }
        });

        func2(list, Latest::divideBy2);
    }

    private static void func2(List<Integer> list, Function<Integer, ?> func) {
        // Implementation 
    }
}