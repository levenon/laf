package com.fileserver.dao;

import java.io.Serializable;
import java.util.Collection;
import java.util.List;

@SuppressWarnings({ "rawtypes" })
public interface IBaseDao {

	public void delete(Object transientObject);

	public void save(Object transientObject);
	
	public void update(Object transientObject);

	public List<?> findAll(Class<?> tableModel);
	
	public Object findObjectByCondition(Object condition);
	
	public Object findById(Class<?> className, Serializable pk);
	
	public List<?> findByExample(Object transientObject);
	
	public List<?> queryForListByPage(Object transientObject,int firstRow,int rowSize);
	
	public List<?> find(String Hql);
	
	public void saveOrUpdate(Object transientObject);
	
	public void batchSaveOrUpdate(Collection<?> transientObjects);
	
	public List<?> findByProperty(String tableModel, String propertyName, Object value, String sort);
	
	/**
	 * 批量删除
	 */
	public void delAll(String[] ids, String str);

	/**
	 * 分页查询
	 * @param hql 
	 * @param page  页码
	 * @param size  页面大小
	 * @return
	 */
	public List<?> findListByPage(String hql, Integer page, Integer size);

	public List<?> executeSQL(Class cls, String sql, Integer page, Integer size);
	
}
