package com.laf.service.common;

import java.util.List;

import org.springframework.stereotype.Service;

import com.laf.common.constants.DefaultCode;
import com.laf.entity.Category;
import com.laf.middleResult.CategoryTree;
import com.laf.service.BaseService;

@Service
@SuppressWarnings({"unchecked"})
public class CategoryService extends BaseService {
	
	public Category categoryById(Integer id) {
		
		Object object = findById(Category.class, id);
		if (object != null && object instanceof Category) {
			return (Category)object;
		}
		return null;
	}
	
	public List<Category> subCategories(Integer id) {
		
		return find("from Category where parentId = " + id + " and isDelete = " + DefaultCode.Code_Zero);
	}

	public List<CategoryTree> allCategories() {
		return find("from Category where isDelete = " + DefaultCode.Code_Zero);
	}

	public List<CategoryTree> allCategoryTrees() {
		return find("select new com.laf.middleResult.CategoryTree(id, name, parentId) from Category where isDelete = " + DefaultCode.Code_Zero);
	}
	
	public Category addCategory(Integer parentId, String name) {
		
		Category category = new Category();
		category.setParentId(parentId);
		category.setName(name);
		
		save(category);
		
		return category;
	}
	
	public void removeCategory(Integer id) {

		Category category = new Category();
		category.setId(id);

		delete(category);
	}
	
	public Category updateCategory(Integer id, Integer parentId, String name) {

		Category category = categoryById(id);
		
		if (category != null) {

			category.setParentId(parentId);
			category.setName(name);

			update(category);
		}
		return category;
	}
}
