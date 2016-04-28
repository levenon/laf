package com.laf.entity;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

import com.laf.util.JSONPropertyFilter;

/**
 * 视频信息
 * 
 * @author tangbiao
 * 
 */
@Entity
@Table(name = "t_video", catalog = "laf")
public class Video implements IEntity {
	/**
	 * 视频ID
	 */
	private Integer id;
	/**
	 * 文件ID
	 */
	private Integer fileId;
	/**
	 * 视频宽度
	 */
	private Integer width = 0;
	/**
	 * 视频高度
	 */
	private Integer height = 0;
	/**
	 * 视频时长
	 */
	private Integer time = 0;
	/**
	 * 视频编码类型
	 */
	private String type = "";
	/**
	 * Record的类型
	 */
	private Integer recordType = 1;
	/**
	 * 创建时间
	 */
	@JSONPropertyFilter
	private Date createTime;
	/**
	 * 修改时间
	 */
	@JSONPropertyFilter
	private Date modifyTime;
	/**
	 * 删除时间
	 */
	@JSONPropertyFilter
	private Date deleteTime;
	/**
	 * 删除状态
	 */
	@JSONPropertyFilter
	private Boolean isDelete = false;

	@Id
	@GeneratedValue
	@Column(name = "id", unique = true, nullable = false, length = 20)
	public Integer getId() {
		return this.id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	@Column(name = "fileId", nullable = false, length = 20)
	public Integer getFileId() {
		return this.fileId;
	}

	public void setFileId(Integer fileId) {
		this.fileId = fileId;
	}

	@Column(name = "width", nullable = false)
	public Integer getWidth() {
		return this.width;
	}

	public void setWidth(Integer width) {
		this.width = width;
	}

	@Column(name = "height", nullable = false)
	public Integer getHeight() {
		return this.height;
	}

	public void setHeight(Integer height) {
		this.height = height;
	}

	@Column(name = "time", nullable = false)
	public Integer getTime() {
		return this.time;
	}

	public void setTime(Integer time) {
		this.time = time;
	}

	@Column(name = "type", nullable = false, length = 20)
	public String getType() {
		return this.type;
	}

	public void setType(String type) {
		this.type = type;
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

	@Transient
	public Integer getRecordType() {
		return recordType;
	}

	public void setRecordType(Integer recordType) {
		this.recordType = recordType;
	}
}
