package com.laf.service.M2;

import org.springframework.stereotype.Service;

import com.laf.service.IService;

@Service
public class BridgeM2 extends Method2_1_0{

	@Override
	public IService matchVersion(String version) {

		IService service = super.matchVersion(version);

		if (service != null) {
			service = this;
		}
		return service;
	}
	
}
