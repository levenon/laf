package com.fileserver.common.enums;

import net.coobird.thumbnailator.geometry.Positions;

public enum Anchor {

	LEFT("l", Positions.CENTER_LEFT),
	TOP("t", Positions.TOP_CENTER),
	RIGHT("r", Positions.CENTER_RIGHT),
	BOTTOM("b", Positions.BOTTOM_CENTER),
	CENTER("c", Positions.CENTER),
	LEFT_TOP("lt", Positions.TOP_LEFT),
	RIGHT_TOP("rt", Positions.TOP_RIGHT),
	RIGHT_BOTTOM("rb", Positions.BOTTOM_RIGHT),
	LEFT_BOTTOM("lb", Positions.BOTTOM_LEFT);
	
	private String code;
	private Positions positions;
	
	private Anchor(String code, Positions positions) {
		this.code = code;
		this.positions = positions;
	}

	public String getCode() {
		return code;
	}

	public Positions getPositions() {
		return positions;
	}
	
	public static Positions getPositionsByAnchorCode(String anchorCode){
		for(Anchor anchor : Anchor.values()){
			if(anchor.getCode().equals(anchorCode)) {
				return anchor.getPositions();
			}
		}
		throw new IllegalArgumentException("未能找到匹配的Anchor:" + anchorCode);
	}

}
