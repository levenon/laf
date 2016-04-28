package com.laf.middleResult;

import java.util.ArrayList;
import java.util.List;

import com.laf.entity.Category;
import com.laf.entity.ICategory;

public class CategoryTree implements ICategory {
	
	private Integer id;
	private Integer parentId;
	private String name;
	private List<CategoryTree> subItems;

	public CategoryTree(Integer id, String name, Integer parentId) {
		super();
		this.id = id;
		this.name = name;
		this.parentId = parentId;
	}

	public CategoryTree(Category category) {
		super();
		this.id = category.getId();
		this.name = category.getName();
		this.parentId = category.getParentId();
	}
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public List<CategoryTree> getSubItems() {
		if (subItems == null) {
			subItems = new ArrayList<CategoryTree>();
		}
		return subItems;
	}
	public void setSubItems(List<CategoryTree> subItems) {
		
		this.subItems = subItems;
	}
	public Integer getParentId() {
		return parentId;
	}
	public void setParentId(Integer parentId) {
		this.parentId = parentId;
	}
}
