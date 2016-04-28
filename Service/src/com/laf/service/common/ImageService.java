package com.laf.service.common;

import java.util.List;

import org.springframework.stereotype.Service;

import com.laf.common.constants.DefaultCode;
import com.laf.entity.Image;
import com.laf.service.BaseService;

@Service
public class ImageService extends BaseService {

	public Image imageById(Integer id) {

		Object object = findById(Image.class, id);
		if (object != null && object instanceof Image) {
			return (Image)object;
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	public List<Image> imagesByNoticeId(Integer noticeId) {
		
		return find(" from Image where noticeId = " + noticeId + " and isDelete = " + DefaultCode.Code_Zero);
	}
	
	public Image addImage(Integer noticeId, Integer remoteId, String title) {
		
		Image image = new Image();
		image.setNoticeId(noticeId);
		image.setRemoteId(remoteId);
		image.setTitle(title);
		
		save(image);
		
		return image;
	}
	
	public Image addBindImage(Integer noticeId, Integer remoteBinderId, String title) {
		
		Image image = new Image();
		image.setNoticeId(noticeId);
		image.setRemoteBinderId(remoteBinderId);
		image.setTitle(title);
		
		save(image);
		
		return image;
	}
	
	public void removeImage(Integer id) {

		Image image = new Image();
		image.setId(id);

		delete(image);
	}
	
	public Image updateImage(Integer id, Integer noticeId, Integer remoteId, String title) {

		Image image = imageById(id);
		
		if (image != null) {

			image.setNoticeId(noticeId);
			image.setRemoteId(remoteId);
			image.setTitle(title);

			update(image);
		}
		return image;
	}
	
	public Image updateBindImage(Integer id, Integer noticeId, Integer remoteBinderId, String title) {

		Image image = imageById(id);
		
		if (image != null) {

			image.setNoticeId(noticeId);
			image.setRemoteBinderId(remoteBinderId);
			image.setTitle(title);

			update(image);
		}
		return image;
	}
}
