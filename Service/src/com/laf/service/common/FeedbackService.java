package com.laf.service.common;

import org.springframework.stereotype.Service;

import com.laf.entity.Feedback;
import com.laf.service.BaseService;

@Service
public class FeedbackService extends BaseService {

	public Feedback feedbackById(Integer id) {

		Object object = findById(Feedback.class, id);
		if (object != null && object instanceof Feedback) {
			return (Feedback)object;
		}
		return null;
	}
	
	public Feedback addFeedback(String content, Integer uid, String telephone, String name) {
		
		Feedback feedback = new Feedback();
		feedback.setContent(content);
		feedback.setUid(uid);
		feedback.setTelephone(telephone);
		feedback.setName(name);
		
		save(feedback);
		
		return feedback;
	}
	
	public void removeFeedback(Integer id) {

		Feedback feedback = new Feedback();
		feedback.setId(id);

		delete(feedback);
	}
	
	public Feedback updateFeedback(Integer id, String content, Integer uid, String telephone, String name) {

		Feedback feedback = feedbackById(id);
		
		if (feedback != null) {

			feedback.setContent(content);
			feedback.setUid(uid);
			feedback.setTelephone(telephone);
			feedback.setName(name);

			update(feedback);
		}
		return feedback;
	}
}
