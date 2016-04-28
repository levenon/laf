package com.laf.service.common;

import java.util.List;

import org.springframework.stereotype.Service;

import com.laf.common.constants.DefaultCode;
import com.laf.entity.CommonImage;
import com.laf.service.BaseService;

@Service
public class CommonImageService extends BaseService {

	public CommonImage commonImageById(Integer id) {

		Object object = findById(CommonImage.class, id);
		if (object != null && object instanceof CommonImage) {
			return (CommonImage)object;
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	public List<CommonImage> allCommonImages() {
		
		return find("from CommonImage where isDelete = " + DefaultCode.Code_Zero);
	}

	@SuppressWarnings("unchecked")
	public List<CommonImage> commonImages(Integer page, Integer size) {
		
		return findListByPage("from CommonImage where isDelete = " + DefaultCode.Code_Zero, page, size);
	}
	
	public CommonImage addCommonImage(Integer remoteId, String title) {
		
		CommonImage commonImage = new CommonImage();
		commonImage.setRemoteId(remoteId);
		commonImage.setTitle(title);
		
		save(commonImage);
		
		return commonImage;
	}
	
	public void removeCommonImage(Integer id) {

		CommonImage commonImage = new CommonImage();
		commonImage.setId(id);

		delete(commonImage);
	}
	
	public CommonImage updateCommonImage(Integer id, Integer remoteId, String title) {

		CommonImage commonImage = commonImageById(id);
		
		if (commonImage != null) {

			commonImage.setRemoteId(remoteId);
			commonImage.setTitle(title);

			update(commonImage);
		}
		return commonImage;
	}
}
