package com.example.register.controller;

import java.util.List;
import java.util.Objects;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.example.register.entity.Login;
import com.example.register.repository.RegistrationRepository;
import com.example.register.service.RegistrationServices;

@Controller
@ComponentScan
public class Register {
	
	@Autowired
	private RegistrationServices service;
	
	@RequestMapping("/view")
	public String viewJvnPage() {
		return "jnvpage";
	}
	
	
	
	
	@RequestMapping("/savejnv")
	public String savejnv(@ModelAttribute("jnv") Login login,ModelMap model) {
		service.save(login);
		System.out.println(login.getCity());
		System.out.println(login.getId());
		model.addAttribute("jnv", login);
		return "jnvpage";
	}
	
	@RequestMapping("/listall")
	public String listAll(ModelMap model) {
		List<Login> login = service.getAllLogin();
		System.out.println(login);
		model.addAttribute("login", login );
		return "search";
	}
	
	
	
//	@RequestMapping("/update")
//	public String updateLogin(@RequestParam("id") long id, ModelMap model) {
//		Login login = service.getLoginById(id);
//		model.addAttribute("login", login);
//		return "updatepage";
//	}
	
	
	@RequestMapping("/updateData")
	public String update(@ModelAttribute("jnv") Login login,ModelMap model) {
		service.save(login);
		model.addAttribute("login" ,login);
		return "updatepage";
	}
	
	@RequestMapping("/delete")
	public String deleteLoginById(@RequestParam("id") long id, ModelMap model) {
		service.deleteLoginById(id);
		List<Login> login = service.getAllLogin();
		System.out.println(login);
		model.addAttribute("login", login );
		return "search";
	}
	
	
//	@SuppressWarnings("unlikely-arg-type")
//	@GetMapping("/jnvlogin")
//	public String matchLogin( @ModelAttribute("jnv") Login login, ModelMap model) {
//		if(login.equals(login.getUsername())&& login.equals(login.getPassword())) {
//			return "welcome";
//		}else {
//			return "jnvpage";
//		}
		
//	}
	
	@GetMapping("/jnvlogin")
	public ModelAndView login() {
		ModelAndView mav = new ModelAndView("login");
		mav.addObject("user", new Login());
		return mav;
	}
	
	@SuppressWarnings("unlikely-arg-type")
	@PostMapping("/jnvlogin")
	public String login(@ModelAttribute("jnv") Login login, ModelMap model) {
		Login user = service.login(login.getUsername(), login.getPassword());
		System.out.println(user);
		System.out.println(login.getUsername());
		System.out.println(login.getPassword());
		model.addAttribute("jnv", login);
		System.out.println(login);
		if(Objects.nonNull(user)) {
			return "jnvpage";
		}else  {
			return "welcome";
		}
		
		
		
		
		
//		if(user.getUsername().equals(login.getUsername())&& user.getPassword().equals(login.getPassword())) {
//			return "welcome";
//		}else {
//			return "jnvpage";
//		}
//	
	
	}	
	
	
}
