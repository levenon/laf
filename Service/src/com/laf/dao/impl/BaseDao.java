package com.laf.dao.impl;

import java.io.Serializable;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.transform.Transformers;
import org.springframework.orm.hibernate3.HibernateCallback;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;
import org.springframework.stereotype.Repository;

import com.laf.common.constants.DefaultCode;
import com.laf.dao.IBaseDao;

@Repository(value = "baseDao")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class BaseDao extends HibernateDaoSupport implements IBaseDao {

	@Resource
	public void setSessionFactory0(SessionFactory sessionFactory) {
		super.setSessionFactory(sessionFactory);
	}

	public HibernateTemplate getHibernate() {
		return getHibernateTemplate();
	}

	// 增加
	public void save(Object transientObject) {
		getHibernate().save(transientObject);
	}

	// 删除
	public void delete(Object transientObject) {
		getHibernate().save(transientObject);
	}

	// 修改
	public void update(Object transientObject) {
		getHibernate().update(transientObject);
	}

	// 修改或保存
	public void saveOrUpdate(Object transientObject) {
		getHibernate().saveOrUpdate(transientObject);
	}

	// 批量修改
	public void batchSaveOrUpdate(Collection<?> transientObjects) {
		getHibernate().saveOrUpdateAll(transientObjects);
	}

	// 通过id查找
	public Object findById(Class<?> className, Serializable pk) {
		return getHibernate().get(className, pk);
	}

	// 查询一组数据，判定后，返回的是单个数据
	public Object findObjectByCondition(Object condition) {
		List list = getHibernate().find((String) condition); // 按照条件查询list集合
		Object obj = null;
		if (list.size() == 1) { // 如果list的长度为1的时候，确定为单个数据
			obj = list.get(0);
		}
		return obj;
	}

	// 通过hql查找
	public List find(String Hql) {
		List list = getHibernate().find(Hql);
		if (list == null) {
			list = new ArrayList();
		}
		return list;
	}

	public List findByNamedParam(final String hql, final String paramNames[], final Object values[]) {
		List list = getHibernate().findByNamedParam(hql, paramNames, values);
		if (list == null) {
			list = new ArrayList();
		}
		return list;
	}

	// 查找所有实体对象
	public List<?> findAll(Class<?> tableModel) {
		return getHibernate().loadAll(tableModel);
	}

	// 通过属性(不包括主键、外键信息)
	public List<?> findByExample(Object transientObject) {
		return getHibernate().findByExample(transientObject);
	}

	/**
	 * 根据给出例子查找对象－分页
	 */
	public List<?> queryForListByPage(Object transientObject, int firstRow, int rowSize) {
		return getHibernate().findByExample(transientObject, firstRow, rowSize);
	}

	/**
	 * 根据给出属性值查找对象
	 */
	public List<?> findByProperty(String tableModel, String propertyName, Object value, String sort) {
		String order = "";
		if (sort.isEmpty()) {
			order = "";
		} else {
			order = "order by model.createTime " + sort;
		}
		String queryString = "from " + tableModel + " as model where model.isDelete = " + DefaultCode.Code_False + " and model." + propertyName + "= ?" + order;
		return getHibernate().find(queryString, value);

	}

	/**
	 * 分页查询
	 */
	@Override
	public List<?> findListByPage(final String hql, Integer page, final Integer size) {

		final int cursor = size *  Math.max(0, page);
		return getHibernate().executeFind(new HibernateCallback() {
			@Override
			public Object doInHibernate(Session session) throws HibernateException, SQLException {
				Query query = session.createQuery(hql);
				query.setMaxResults(size);
				query.setFirstResult(cursor);
				return query.list();
			}
		});
	}

	/**
	 * 分页查询
	 */
	@Override
	public List<?> findListBySize(final String hql, final Integer size, final Map<String, Object> paramters) {

		return getHibernate().executeFind(new HibernateCallback() {
			@Override
			public Object doInHibernate(Session session) throws HibernateException, SQLException {
				Query query = session.createQuery(hql);
				query.setMaxResults(size);

				for (String key : paramters.keySet()) {
					query.setParameter(key, paramters.get(key));
				}
				return query.list();
			}
		});
	}

	/**
	 * 分页查询
	 */
	@Override
	public List<?> findListBySize(final String hql, final Integer size) {

		return getHibernate().executeFind(new HibernateCallback() {
			@Override
			public Object doInHibernate(Session session) throws HibernateException, SQLException {
				Query query = session.createQuery(hql);
				query.setMaxResults(size);
				return query.list();
			}
		});
	}

	/**
	 * 执行sql语句
	 */
	@Override
	public List<?> executeSQL(final Class cls, final String sql, Integer page, final Integer size) {

		final int cursor = size * (page - 1);
		return getHibernate().executeFind(new HibernateCallback() {
			@Override
			public Object doInHibernate(Session session) throws HibernateException, SQLException {
				Query query = session.createSQLQuery(sql);
				query.setResultTransformer(Transformers.aliasToBean(cls));
				query.setMaxResults(size);
				query.setFirstResult(cursor);

				return query.list();
			}
		});
	}

	@Override
	public List<?> executeSQL(final Class cls, final String sql, final Integer size) {

		return getHibernate().executeFind(new HibernateCallback() {
			@Override
			public Object doInHibernate(Session session) throws HibernateException, SQLException {
				Query query = session.createSQLQuery(sql);
				query.setResultTransformer(Transformers.aliasToBean(cls));
				query.setMaxResults(size);

				return query.list();
			}
		});
	}

	public void executeUpdateSQL(final String sql) {
		Session session = getSession();
		Query query = session.createSQLQuery(sql);
		query.executeUpdate();
		session.flush();
		session.clear();
	}

	@Override
	public void deleteAll(String[] ids, String str) {
		String hql = "";
		for (int i = 0; i < ids.length; i++) {
			if (i == 0) {
				hql = "'" + ids[i] + "'";
			} else {
				hql = hql + " or model.id = '" + ids[i] + "'";
			}
		}

		Session session = getSession();
		String hqls = "update " + str + " as model " + "set model.isDelete = " + DefaultCode.Code_True + " , model.deleteTime = now() where model.id = " + hql;
		Query query = session.createQuery(hqls);
		query.executeUpdate();
	}

}
