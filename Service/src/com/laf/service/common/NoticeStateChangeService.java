package com.laf.service.common;

import org.springframework.stereotype.Service;

import com.laf.common.enums.NoticeState;
import com.laf.entity.NoticeStateChange;
import com.laf.service.BaseService;

@Service
public class NoticeStateChangeService extends BaseService {

	public NoticeStateChange noticeStateChangeById(Integer id) {

		Object object = findById(NoticeStateChange.class, id);
		if (object != null && object instanceof NoticeStateChange) {
			return (NoticeStateChange) object;
		}
		return null;
	}

	public NoticeStateChange addNoticeStateChange(Integer noticeId, Integer uid, NoticeState state) {

		NoticeStateChange noticeStateChange = new NoticeStateChange();
		noticeStateChange.setNoticeId(noticeId);
		noticeStateChange.setState(state.value());
		noticeStateChange.setUid(uid);

		save(noticeStateChange);

		return noticeStateChange;
	}

	public void removeNoticeStateChange(Integer id) {

		NoticeStateChange noticeStateChange = new NoticeStateChange();
		noticeStateChange.setId(id);

		delete(noticeStateChange);
	}

	public NoticeStateChange updateNoticeStateChange(Integer id, Integer noticeId, NoticeState state) {

		NoticeStateChange noticeStateChange = noticeStateChangeById(id);

		if (noticeStateChange != null) {

			noticeStateChange.setNoticeId(noticeId);
			noticeStateChange.setState(state.value());

			update(noticeStateChange);
		}
		return noticeStateChange;
	}
}
