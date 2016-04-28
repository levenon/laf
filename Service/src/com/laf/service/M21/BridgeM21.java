package com.laf.service.M21;

import org.springframework.stereotype.Service;

import com.laf.service.IService;

@Service
public class BridgeM21 extends Method21_1_0 {

	public IService matchVersion(String version) {

		IService service = super.matchVersion(version);

		if (service == null) {
			service = this;
		}
		return service;
	}
}
