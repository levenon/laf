package com.fileserver.entity;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import com.fileserver.common.enums.ImageKind;

@Entity
@Table(name = "t_imageBinder", catalog = "file")
public class ImageBinderInfo implements IEntity {
	/**
	 * 图片绑定ID
	 */
	private Integer id;
	/**
	 * 默认图片ID
	 */
	private Integer imageId;
	/**
	 * 垂直图片ID
	 */
	private Integer portraitImageId;
	/**
	 * 水平图片ID
	 */
	private Integer landscapeImageId;
	
	/**
	 * 创建时间
	 */
	private Date createTime;
	/**
	 * 修改时间
	 */
	private Date modifyTime;
	/**
	 * 删除时间
	 */
	private Date deleteTime;
	/**
	 * 删除状态
	 */
	private Boolean isDelete = Boolean.FALSE;

	@Id
	@GeneratedValue
	@Column(name = "id", unique = true, nullable = false, length = 20)
	public Integer getId() {
		return id;
	}
	
	public void setId(Integer id) {
		this.id = id;
	}

	@Column(name = "ImageId", nullable = false, length = 20)
	public Integer getImageId() {
		return imageId;
	}

	public void setImageId(Integer imageId) {
		this.imageId = imageId;
	}

	@Column(name = "portraitImageId", length = 20)
	public Integer getPortraitImageId() {
		return portraitImageId;
	}

	public void setPortraitImageId(Integer portraitImageId) {
		this.portraitImageId = portraitImageId;
	}

	@Column(name = "landscapeImageId", length = 20)
	public Integer getLandscapeImageId() {
		return landscapeImageId;
	}

	public void setLandscapeImageId(Integer landscapeImageId) {
		this.landscapeImageId = landscapeImageId;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "createTime", length = 19)
	public Date getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "modifyTime", length = 19)
	public Date getModifyTime() {
		return this.modifyTime;
	}

	public void setModifyTime(Date modifyTime) {
		this.modifyTime = modifyTime;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "deleteTime", length = 19)
	public Date getDeleteTime() {
		return this.deleteTime;
	}

	public void setDeleteTime(Date deleteTime) {
		this.deleteTime = deleteTime;
	}

	@Column(name = "isDelete", nullable = false)
	public Boolean getIsDelete() {
		return this.isDelete;
	}

	public void setIsDelete(Boolean isDelete) {
		this.isDelete = isDelete;
	}

	public Integer destinateImageId(ImageKind imageKind) {
		
		switch (imageKind) {
		case portrait:
			if (portraitImageId != null) {
				return portraitImageId;	
			}
			if (imageId != null) {
				return imageId;
			}
			return landscapeImageId;

		case landscape:
			if (landscapeImageId != null) {
				return landscapeImageId;
			}
			if (imageId != null) {
				return imageId;
			}
			return portraitImageId;
		}
		return imageId;
	}
}
