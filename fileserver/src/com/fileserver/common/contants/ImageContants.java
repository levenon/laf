package com.fileserver.common.contants;

/**
 * 图片常量
 * 
 * @author tangbiao
 *
 */
public class ImageContants {
	
	
	/**
	 * 优先级：2
	 * 如：320x480 ,  100p，100px，!x100p 
	 * 参数名称 必填 说明 
	 * !<Scale>p  基于原图大小，按指定百分比缩放。 取值范围0-1000
	 * !<Scale>px  以百分比形式指定目标图片宽度，高度不变。取值范围为0-1000
	 * !x<Scale>p  以百分比形式指定目标图片高度，宽度不变。取值范围为0-1000
	 * <Width>x  指定目标图片宽度后高度等比缩放。取值范围为0-10000
	 * x<Height>  指定目标图片高度后宽度等比缩放。取值范围为0-10000
	 * <Width>x<Height>  限定长边，短边自适应缩放，将目标图片限制在指定宽高矩形内。 取值范围0-10000
	 * !<Width>x<Height>r  限定短边，长边自适应缩放，目标图片会延伸至指定宽高矩形外。 取值范围0-10000
	 * <Width>x<Height>!  限定目标图片宽高值，忽略原图宽高比例，按照指定宽高值强行缩略，可能导致目标图片变形。 取值范围0-10000
	 * <Width>x<Height>>  当原图尺寸大于给定的宽度或高度时，按照给定宽高值缩小。 取值范围0-10000
	 * <Width>x<Height><  当原图尺寸小于给定的宽度或高度时，按照给定宽高值放大。 取值范围0-10000
	 * <Area>@  按原图高宽比例等比缩放，缩放后的像素数量不超过指定值。 取值范围0-100000000
	 */

	public static String NUMBER_REGEX = "\\d+";
	
	/**
	 * !<Scale>p
	 * 基于原图大小，按指定百分比缩放。 取值范围0-1000
	 * 例如：!25p   表示 原图按照25%缩放
	 */
	public static String SCALE_P_REGEX = "!\\d+p";
	
	/**
	 * !<Scale>px
	 * 以百分比形式指定目标图片宽度，高度不变。取值范围为0-1000
	 * 例如：!25px  表示按照宽不变  高25等比缩放
	 */
	public static String SCALE_PX_REGEX = "!\\d+px";

	/**
	 * !x<Scale>p
	 * 以百分比形式指定目标图片高度，宽度不变。取值范围为0-1000
	 * 例如：!x25p  表示按照高不变  宽25等比缩放
	 */
	public static String SCALE_I_XP_REGEX = "!x\\d+p";

	/**
	 * <Width>x
	 * 指定目标图片宽度 等比缩放。 取值范围0-10000
	 * 例如： 46x  表示指定宽46px 等比缩放
	 */
	public static String SCALE_WIDTH_X_REGEX = "\\d+x";

	/**
	 * x<Height> 
	 * 指定目标图片高度 等比缩放。 取值范围0-10000
	 * 例如：x60 表示指定高60px等比缩放
	 */
	public static String SCALE_X_HEIGHT_REGEX = "x\\d+";

	/**
	 * <Width>x<Height>
	 * 限定长边，短边自适应缩放，将目标图片限制在指定宽高矩形内。取值范围不限，但若宽高超过10000时只能缩不能放
	 * 例如：40x60 
	 */
	public static String SCALE_WIDTH_X_HEIGHT_REGEX = "\\d+x\\d+";

	/**
	 * !<Width>x<Height>r
	 * 限定短边，长边自适应缩放，目标图片会延伸至指定宽高矩形外。取值范围不限，但若宽高超过10000时只能缩不能放
	 * 例如：40x60 
	 */
	public static String SCALE_I_WIDTH_X_HEIGHT_R_REGEX = "!\\d+x\\d+r";
	
	/**
	 * <Width>x<Height>! 
	 * 限定目标图片宽高值，忽略原图宽高比例，按照指定宽高值强行缩略，可能导致目标图片变形。 
	 * 例如：30x60! 表示图片强制拉伸至宽30x搞60
	 */
	public static String SCALE_WIDTH_X_HEIGHT_I_REGEX = "\\d+x\\d+!";
	
	/**
	 * <Width>x<Height>>
	 * 当原图尺寸大于给定的宽度或高度时，按照给定宽高值缩小。取值范围不限，但若宽高超过10000时只能缩不能放 
	 * 例如：30x60> 
	 */
	public static String SCALE_WIDTH_X_HEIGHT_G_REGEX = "\\d+x\\d+>";

	/**
	 * <Width>x<Height><
	 * 当原图尺寸小于给定的宽度或高度时，按照给定宽高值放大。取值范围不限，但若宽高超过10000时只能缩不能放 
	 * 例如：30x60> 
	 */
	public static String SCALE_WIDTH_X_HEIGHT_L_REGEX = "\\d+x\\d+<";

	/**
	 * <Area>@
	 * 按原图高宽比例等比缩放，缩放后的像素数量不超过指定值。取值范围不限，但若像素数超过25000000时只能缩不能放 
	 * 例如：30x60> 
	 */
	public static String SCALE_AREA_REGEX = "\\d+@";
	
	/**
	 * 优先级：4
	 * 默认不裁剪
	 * <Width>x  指定目标图片宽度，高度不变。取值范围0-10000
	 * x<Height>  指定目标图片高度，宽度不变。取值范围0-10000
	 * <Width>x<Height>  同时指定目标图片宽高。取值范围0-10000
	 * 
	 * 参数名称 必填 说明
	 * !{cropSize}a<dx>a<dy>  相对于偏移锚点，向右偏移个像素，同时向下偏移个像素。 取值范围0－1000
	 * !{cropSize}-<dx>a<dy>  相对于偏移锚点，向下偏移个像素，同时从指定宽度中减去个像素。 取值范围0－1000
	 * !{cropSize}a<dx>-<dy>  相对于偏移锚点，向右偏移个像素，同时从指定高度中减去个像素。 取值范围0－1000
	 * !{cropSize}-<dx>-<dy>  相对于偏移锚点，从指定宽度中减去个像素，同时从指定高度中减去个像素。 取值范围0－1000
	 */

	/**
	 * <Width>x
	 * 指定目标图片宽度，高度不变。取值范围0-10000
	 * 例如：40x    表示裁剪宽40px，高不变
	 */
	public static String CROP_SIZE_WIDTH_X_REGEX= "\\d+x";
	
	/**
	 * x<Height>
	 * 指定目标图片高度，宽度不变。取值范围0-10000
	 * 例如：x40    表示裁剪高40px，宽不变
	 */
	public static String CROP_SIZE_X_HEIGHT_REGEX = "x\\d+";
	
	/**
	 * <Width>x<Height>
	 * 同时指定目标图片宽高。取值范围0-10000
	 * 例如：30x40  表示裁剪宽30px，高40 
	 */
	public static String CROP_SIZE_WIDTH_X_HEIGHT_REGEX = "\\d+x\\d+";

	/**
	 * !{cropSize}a<dx>a<dy>
	 * 相对于偏移锚点，向右偏移dx个像素，同时向下偏移dy个像素。取值范围不限，小于原图宽高即可
	 * 例如： 
	 */
//	public static String CROP_OFFSET_A_X_A_Y_REGEX = "!((\\d+x)|(x\\d+)|(\\d+x\\d+))a\\d+a\\d+";
	
	public static String CROP_SIZE_WIDTH_X_OFFSET_A_X_A_Y_REGEX = "!\\d+xa\\d+a\\d+";
	public static String CROP_SIZE_X_HEIGHT_OFFSET_A_X_A_Y_REGEX = "!x\\d+a\\d+a\\d+";
	public static String CROP_SIZE_WIDTH_X_HEIGHT_OFFSET_A_X_A_Y_REGEX = "!\\d+x\\d+a\\d+a\\d+";

	/**
	 * !{cropSize}-<dx>a<dy>
	 * 相对于偏移锚点，从指定宽度中减去dx个像素，同时向下偏移dy个像素。取值范围不限，小于原图宽高即可
	 * 例如： 
	 */
//	public static String CROP_OFFSET_X_A_Y_REGEX = "!((\\d+x)|(x\\d+)|(\\d+x\\d+))-\\d+a\\d+";
	public static String CROP_SIZE_WIDTH_X_OFFSET_X_A_Y_REGEX = "!\\d+x-\\d+a\\d+";
	public static String CROP_SIZE_X_HEIGHT_OFFSET_X_A_Y_REGEX = "!x\\d+-\\d+a\\d+";
	public static String CROP_SIZE_WIDTH_X_HEIGHT_OFFSET_X_A_Y_REGEX = "!\\d+x\\d+-\\d+a\\d+";

	/**
	 * !{cropSize}a<dx>-<dy>
	 * 相对于偏移锚点，向右偏移dx个像素，同时从指定高度中减去dy个像素。取值范围不限，小于原图宽高即可
	 *  
	 */
//	public static String CROP_OFFSET_A_X_Y_REGEX = "!((\\d+x)|(x\\d+)|(\\d+x\\d+))a\\d+-\\d+";
	public static String CROP_SIZE_WIDTH_X_OFFSET_A_X_Y_REGEX = "!\\d+xa\\d+-\\d+";
	public static String CROP_SIZE_X_HEIGHT_OFFSET_A_X_Y_REGEX = "!x\\d+a\\d+-\\d+";
	public static String CROP_SIZE_WIDTH_X_HEIGHT_OFFSET_A_X_Y_REGEX = "!\\d+x\\d+a\\d+-\\d+";

	/**
	 * !{cropSize}-<dx>-<dy>
	 * 相对于偏移锚点，从指定宽度中减去dx个像素，同时从指定高度中减去dy个像素。取值范围不限，小于原图宽高即可
	 * 例如： 
	 */
//	public static String CROP_OFFSET_X_Y_REGEX = "!((\\d+x)|(x\\d+)|(\\d+x\\d+))-\\d+-\\d+";
	public static String CROP_SIZE_WIDTH_X_OFFSET_X_Y_REGEX = "!\\d+x-\\d+-\\d+";
	public static String CROP_SIZE_X_HEIGHT_OFFSET_X_Y_REGEX = "!x\\d+-\\d+-\\d+";
	public static String CROP_SIZE_WIDTH_X_HEIGHT_OFFSET_X_Y_REGEX = "!\\d+x\\d+-\\d+-\\d+";
}
