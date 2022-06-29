package com.example.register.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.register.entity.Login;
import com.example.register.repository.RegistrationRepository;

@Service
public class RegistrationServicesImpl implements RegistrationServices {
	
	@Autowired
	private RegistrationRepository repo;
	
	@Override
	public void save(Login login) {
		// TODO Auto-generated method stub
		repo.save(login);
	}

	@Override
	public Login login(String username, String password) {
		// TODO Auto-generated method stub
		Login findByUsernameAndPassword = repo.findByUsernameAndPassword(username, password);
		return findByUsernameAndPassword;
		
	}

	@Override
	public Login getLoginById(long id) {
		// TODO Auto-generated method stub
		Optional<Login> log = repo.findById(id);
		Login login = log.get();
		return login;
	}

//	@Override
//	public void find(String email) {
//		// TODO Auto-generated method stub
//		List<Login> find = repo.find(email);
//	}

	@Override
	public List<Login> getAllLogin() {
		// TODO Auto-generated method stub
		List<Login> login = repo.findAll();
		return login;
	}

	@Override
	public void deleteLoginById(long id) {
		// TODO Auto-generated method stub
		repo.deleteById(id);
	}


	

}
