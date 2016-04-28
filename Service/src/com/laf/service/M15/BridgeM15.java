package com.laf.service.M15;

import org.springframework.stereotype.Service;

import com.laf.service.IService;

@Service
public class BridgeM15 extends Method15_1_0 {

	public IService  matchVersion(String version){
		
		IService service = super.matchVersion(version);
		
		if(service == null){
			service = this;
		}
		return service;
	}
}
