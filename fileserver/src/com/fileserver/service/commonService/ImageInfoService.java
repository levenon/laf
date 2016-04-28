package com.fileserver.service.commonService;

import org.springframework.stereotype.Service;

import com.fileserver.entity.ImageInfo;
import com.fileserver.service.BaseService;

@Service
public class ImageInfoService extends BaseService {

	public ImageInfo imageInfoById(Integer id) {
		
		return (ImageInfo) findById(ImageInfo.class, id);
	}
	
	public ImageInfo addImageInfo(Integer fileId, Integer width, Integer height) {
		
		ImageInfo image = new ImageInfo();
		
		image.setFileId(fileId);
		image.setWidth(width);
		image.setHeight(height);
		
		save(image);
		
		return image;
	}
	
	public void removeImageInfo(Integer id) {

		ImageInfo image = new ImageInfo();
		image.setId(id);

		delete(image);
	}
	
	public ImageInfo updateImageInfo(Integer id, Integer fileId, Integer width, Integer height) {

		ImageInfo image = imageInfoById(id);
		
		if (image != null) {

			image.setFileId(fileId);
			image.setWidth(width);
			image.setHeight(height);

			update(image);
		}
		return image;
	}
}
