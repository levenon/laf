package com.laf.service.M1;

import org.springframework.stereotype.Service;

import com.laf.service.IService;

@Service
public class BridgeM1 extends Method1_1_0 {

	public IService  matchVersion(String version){
	
		IService service = super.matchVersion(version);
		
		if(service == null){
			service = this;
		}
		return service;
	}
}
