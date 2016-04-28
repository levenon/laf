package com.laf.service.common;

import org.springframework.stereotype.Service;

import com.laf.entity.Help;
import com.laf.service.BaseService;

@Service
public class HelpService extends BaseService {

	public Help helpById(Integer id) {

		Object object = findById(Help.class, id);
		if (object != null && object instanceof Help) {
			return (Help)object;
		}
		return null;
	}
	
	public Help addHelp(Integer uid, Integer noticeId) {
		
		Help help = new Help();
		help.setUid(uid);
		help.setNoticeId(noticeId);

		save(help);
		
		return help;
	}
	
	public void removeHelp(Integer id) {

		Help help = new Help();
		help.setId(id);

		delete(help);
	}
	
	public Help updateHelp(Integer id, String name, Integer uid, Integer noticeId) {

		Help help = helpById(id);
		
		if (help != null) {

			help.setUid(uid);
			help.setNoticeId(noticeId);

			update(help);
		}
		return help;
	}
}
