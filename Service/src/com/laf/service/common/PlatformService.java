package com.laf.service.common;

import org.springframework.stereotype.Service;

import com.laf.entity.Platform;
import com.laf.service.BaseService;

@Service
public class PlatformService extends BaseService {

	public Platform platformById(Integer id) {

		Object object = findById(Platform.class, id);
		if (object != null && object instanceof Platform) {
			return (Platform) object;
		}
		return null;
	}

	public Platform addPlatform(String name, String prefix, Boolean paySupport) {

		Platform platform = new Platform();
		platform.setName(name);
		platform.setPrefix(prefix);
		platform.setPaySupport(paySupport);

		save(platform);

		return platform;
	}

	public void removePlatform(Integer id) {

		Platform platform = new Platform();
		platform.setId(id);

		delete(platform);
	}

	public Platform updatePlatform(Integer id, String name, String prefix, Boolean paySupport) {

		Platform platform = platformById(id);

		if (platform != null) {

			platform.setName(name);
			platform.setPrefix(prefix);
			platform.setPaySupport(paySupport);

			update(platform);
		}
		return platform;
	}
}
