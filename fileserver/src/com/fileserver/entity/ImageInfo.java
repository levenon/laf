package com.fileserver.entity;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * 图片信息
 * @author tangbiao
 *
 */
@Entity
@Table(name = "t_image", catalog = "file")
public class ImageInfo implements IEntity {
	/**
	 * 图片ID
	 */
	private Integer id;
	/**
	 * 默认文件ID
	 */
	private Integer fileId;
	
	/**
	 * 图片宽度
	 */
	private Integer width = 0;
	/**
	 * 图片高度
	 */
	private Integer height = 0;
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

	@Column(name = "fileId", nullable = false, length = 20)
	public Integer getFileId() {
		return fileId;
	}

	public void setFileId(Integer fileId) {
		this.fileId = fileId;
	}

	@Column(name = "width", nullable = false, length = 10)
	public Integer getWidth() {
		return width;
	}

	public void setWidth(Integer width) {
		this.width = width;
	}

	@Column(name = "height", nullable = false, length = 10)
	public Integer getHeight() {
		return height;
	}

	public void setHeight(Integer height) {
		this.height = height;
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
}
