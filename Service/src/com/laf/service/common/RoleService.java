package com.laf.service.common;

import java.util.List;

import org.springframework.stereotype.Service;

import com.laf.common.constants.DefaultCode;
import com.laf.entity.Role;
import com.laf.service.BaseService;

@Service
@SuppressWarnings("unchecked")
public class RoleService extends BaseService {

	public Role roleById(Integer id) {

		Object object = findById(Role.class, id);
		if (object != null && object instanceof Role) {
			return (Role)object;
		}
		return null;
	}
	
	public List<Role> allRoles() {
		return find("from Role where isDelete = " + DefaultCode.Code_Zero);
	}
	
	public Role addRole(String name, Short priority , String introduction) {
		
		Role role = new Role();
		role.setName(name);
		role.setPriority(priority);
		role.setIntroduction(introduction);

		save(role);
		return role;
	}
	
	public void removeRole(Integer id) {

		Role role = new Role();
		role.setId(id);

		delete(role);
	}
	
	public Role updateRole(Integer id, String name, Short priority , String introduction) {

		Role role = roleById(id);
		
		if (role != null) {

			role.setName(name);
			role.setPriority(priority);
			role.setIntroduction(introduction);
			
			update(role);
		}
		
		return role;
	}
}
