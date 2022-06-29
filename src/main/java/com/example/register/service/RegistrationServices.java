package com.example.register.service;

import java.util.List;
import java.util.Optional;

import com.example.register.entity.Login;

public interface RegistrationServices {
	public void save(Login login);

	public Login login(String username, String password);

	public Login getLoginById(long id);
	
	public List<Login> getAllLogin();

	public void deleteLoginById(long id);

	//public void find(String email);

	//public Login login(String username, String password);

}
