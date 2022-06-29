package com.example.register.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.example.register.entity.Login;



public interface RegistrationRepository extends JpaRepository<Login, Long> {
	Login findByUsernameAndPassword(String username, String password);
	
//	 @Query("SELECT p FROM Person p WHERE LOWER(p.email) = LOWER(:email)")
//	    public List<Login> find(@Param("email") String email);
	
}
