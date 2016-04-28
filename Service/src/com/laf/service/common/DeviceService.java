package com.laf.service.common;

import org.springframework.stereotype.Service;

import com.laf.common.constants.DefaultCode;
import com.laf.common.enums.DeviceType;
import com.laf.entity.Device;
import com.laf.service.BaseService;

@Service
public class DeviceService extends BaseService {

	public Device deviceById(Integer id) {

		Object object = findById(Device.class, id);
		if (object != null && object instanceof Device) {
			return (Device) object;
		}
		return null;
	}

	public Device deviceByDeviceNumber(String deviceNumber) {

		Object object = findObjectByCondition("from Device where deviceNumber = '" + deviceNumber + "' and isDelete = " + DefaultCode.Code_Zero);
		if (object != null && object instanceof Device) {
			return (Device) object;
		}
		return null;
	}

	public Device deviceByDeviceToken(String deviceToken) {

		Object object = findObjectByCondition("from Device where deviceToken = '" + deviceToken + "' and isDelete = " + DefaultCode.Code_Zero);
		if (object != null && object instanceof Device) {
			return (Device) object;
		}
		return null;
	}

	public Device addDevice(DeviceType deviceType, String deviceNumber, String deviceToken, String appVersion, String bundleVersion, String systemVersion, String deviceName,
			String deviceModel) {

		Device device = new Device();
		device.setDeviceType(deviceType.value());
		device.setDeviceNumber(deviceNumber);
		device.setDeviceToken(deviceToken);
		device.setAppVersion(appVersion);
		device.setBundleVersion(bundleVersion);
		device.setSystemVersion(systemVersion);
		device.setDeviceName(deviceName);
		device.setDeviceModel(deviceModel);

		save(device);

		return device;
	}

	public void removeDevice(Integer id) {

		Device device = new Device();
		device.setId(id);

		delete(device);
	}

	public Device updateDevice(Integer id, DeviceType deviceType, String deviceNumber, String deviceToken, String appVersion, String bundleVersion, String systemVersion,
			String deviceName, String deviceModel) {

		Device device = deviceById(id);

		if (device != null) {

			device.setDeviceType(deviceType.value());
			device.setDeviceNumber(deviceNumber);
			device.setDeviceToken(deviceToken);
			device.setAppVersion(appVersion);
			device.setBundleVersion(bundleVersion);
			device.setSystemVersion(systemVersion);
			device.setDeviceName(deviceName);
			device.setDeviceModel(deviceModel);

			update(device);
		}
		return device;
	}
}
