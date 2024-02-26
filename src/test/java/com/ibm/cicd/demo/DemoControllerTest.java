package com.ibm.cicd.demo;

import com.ibm.cicd.demo.controller.DemoController;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.slf4j.Logger;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.web.servlet.MockMvc;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(DemoController.class)
public class DemoControllerTest {

	@Autowired
	private MockMvc mockMvc;

	@MockBean
	private Logger logger;

	@Test
	public void testGetHelloMessage() throws Exception {
		mockMvc.perform(get("/api/v1/hello"))
				.andExpect(status().isOk());
	}
}