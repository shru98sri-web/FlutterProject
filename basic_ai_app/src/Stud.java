package com.example;

public class Main {
    public static void main(String[] args) {
        System.out.println("=== Generating Student Records (Java) ===");

        StringBuilder buffer = new StringBuilder();
        for (int i = 1; i <= 200; i++) {
            String id = String.format("STU%03d", i);
            String name = "Student_" + i;
            String grade = "Grade " + (1 + (i % 12));

            buffer.append("ID: ").append(id)
                    .append(" | Name: ").append(name)
                    .append(" | Level: ").append(grade)
                    .append("\n");
        }

        System.out.print(buffer.toString());
        System.out.println("=== Successfully Printed 200 Students ===");
    }
}
