package com.ibm.cicd.demo.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1")
public class DemoController {

    private final Logger logger = LoggerFactory.getLogger(DemoController.class);

    @GetMapping(value = "/hello")
    public String getHelloMessage() {
        logger.info("==> Received GET request for /api/v1/hello");
        return "Hello from Spring";
    }
}
