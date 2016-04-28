package com.fileserver.service.commonService;

import org.springframework.stereotype.Service;

import com.fileserver.entity.FileInfo;
import com.fileserver.service.BaseService;

@Service
public class FileInfoService extends BaseService {

	public FileInfo fileInfoById(Integer id) {
		
		return (FileInfo) findById(FileInfo.class, id);
	}
	
	public FileInfo addFileInfo(String filePath, String fileName, long size, String contentType) {
		
		FileInfo fileInfo = new FileInfo();
		fileInfo.setFilePath(filePath);
		fileInfo.setFileName(fileName);
		fileInfo.setSize(size);
		fileInfo.setContentType(contentType);

		save(fileInfo);
		
		return fileInfo;
	}
	
	public void removeFileInfo(Integer id) {

		FileInfo file = new FileInfo();
		file.setId(id);

		delete(file);
	}
	
	public FileInfo updateFileInfo(Integer id, String filePath, long size, String contentType) {

		FileInfo fileInfo = fileInfoById(id);
		
		if (fileInfo != null) {

			fileInfo.setFilePath(filePath);
			fileInfo.setSize(size);
			fileInfo.setContentType(contentType);

			update(fileInfo);
		}
		return fileInfo;
	}
}
