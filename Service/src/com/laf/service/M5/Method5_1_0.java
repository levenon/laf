package com.laf.service.M5;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.laf.common.utils.ContextUtil;
import com.laf.entity.Login;
import com.laf.middleResult.CategoryTree;
import com.laf.service.BaseMethod;
import com.laf.service.IService;
import com.laf.service.common.CategoryService;
import com.laf.util.AnnotationPropertyFilter;
import com.laf.util.JsonDateValueProcessor;

/**
 * 
 * 获取所有分类
 * 
 * */
@Service
public class Method5_1_0 extends BaseMethod {

	@Autowired
	private CategoryService categoryService;

	@Override
	public boolean isInterfaceUsable() {
		return true;
	}

	// 参数完整性校验
	@Override
	public boolean isParamsComplete(JSONObject params) {
//		Map<String, Object> map = JsonUtil.readJson2Map(params);
		return true;
	}

	// 获取参数列表
	@Override
	public Map<String, Object> getMethodParams() {
		// 参数
		Map<String, Object> parameters = new HashMap<String, Object>();

		return parameters;
	}

	@Override
	public IService matchVersion(String version) {
		String versions = "1.0";
		if (versions.equals(version)) {
			return (IService) ContextUtil.getContext().getBean("method5_1_0");
		}
		return null;
	}

	@Override
	public boolean needsVerifyLoginState() {
		return false;
	}

	@Override
	public JSONArray dealWithParams(Login login, JSONObject params) {
		return fetchAllCategoryServer(params);
	}

	private JSONArray fetchAllCategoryServer(JSONObject params) {
		System.out.println("开始获取所有分类");

		List<CategoryTree> results = new ArrayList<CategoryTree>();
		List<CategoryTree> allCategoryTrees = categoryService.allCategoryTrees();

		if (allCategoryTrees.size() > 0) {

			Integer size = allCategoryTrees.size();
			for (int nIndex = 0; nIndex < size; nIndex++) {

				CategoryTree category = allCategoryTrees.get(nIndex);

				if (category.getParentId() == null) {
					results.add(category);
				} else if (!connectResults(category, results)) {
					if (!connectSourceTree(category, (allCategoryTrees.subList(nIndex, allCategoryTrees.size() - 1)))) {
						System.out.print("one category is disperse");
					}
				}
			}
		}

		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.setJsonPropertyFilter(new AnnotationPropertyFilter());
		jsonConfig.registerJsonValueProcessor(Date.class,new JsonDateValueProcessor());
	
		return JSONArray.fromObject(results, jsonConfig);
	}

	private boolean connectResults(CategoryTree category, List<CategoryTree> categories) {

		if (categories == null) {
			return false;
		}

		if (category == null) {
			return false;
		}

		for (CategoryTree item : categories) {
			if (category.getParentId().equals(item.getId())) {
				item.getSubItems().add(category);
				return true;
			} else {
				return connectResults(category, item.getSubItems());
			}
		}
		return false;
	}

	private boolean connectSourceTree(CategoryTree category, List<CategoryTree> categories) {

		if (categories == null) {
			return false;
		}

		if (category == null) {
			return false;
		}

		for (CategoryTree item : categories) {
			if (category.getParentId().equals(item.getId())) {
				item.getSubItems().add(category);
				return true;
			} else {
				return connectResults(category, item.getSubItems());
			}
		}
		return false;
	}
}
