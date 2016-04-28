package com.fileserver.service.commonService;

import org.springframework.stereotype.Service;

import com.fileserver.entity.ImageBinderInfo;
import com.fileserver.service.BaseService;

@Service
public class ImageBinderInfoService extends BaseService {

	public ImageBinderInfo imageBinderInfoById(Integer id) {
		
		return (ImageBinderInfo) findById(ImageBinderInfo.class, id);
	}
	
	public ImageBinderInfo addImageBinderInfo(Integer imageId, Integer portraitImageId, Integer landscapeImageId) {
		
		ImageBinderInfo ImageBinderInfo = new ImageBinderInfo();
		ImageBinderInfo.setImageId(imageId);
		ImageBinderInfo.setPortraitImageId(portraitImageId);
		ImageBinderInfo.setLandscapeImageId(landscapeImageId);

		save(ImageBinderInfo);
		
		return ImageBinderInfo;
	}
	
	public void removeImageBinderInfo(Integer id) {

		ImageBinderInfo file = new ImageBinderInfo();
		file.setId(id);

		delete(file);
	}
	
	public ImageBinderInfo updateImageBinderInfo(Integer id, Integer imageId, Integer portraitImageId, Integer landscapeImageId) {

		ImageBinderInfo ImageBinderInfo = imageBinderInfoById(id);
		
		if (ImageBinderInfo != null) {

			ImageBinderInfo.setImageId(imageId);
			ImageBinderInfo.setPortraitImageId(portraitImageId);
			ImageBinderInfo.setLandscapeImageId(landscapeImageId);

			update(ImageBinderInfo);
		}
		return ImageBinderInfo;
	}
}
