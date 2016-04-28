package com.fileserver.entity;

import java.util.Date;

public interface IEntity {

	abstract public Date getCreateTime();

	abstract public void setCreateTime(Date createTime);
	
	abstract public Date getModifyTime();

	abstract public void setModifyTime(Date modifyTime);

	abstract public Date getDeleteTime();
	
	abstract public void setDeleteTime(Date deleteTime);

	abstract public Boolean getIsDelete() ;

	abstract public void setIsDelete(Boolean isDelete) ;
}
