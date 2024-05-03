package com.ibm.cicd.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DemoApplication {

	public static void main(String[] args) {
		// this is a testing
		System.out.println("Hello world");
		SpringApplication.run(DemoApplication.class, args);
	}

}
