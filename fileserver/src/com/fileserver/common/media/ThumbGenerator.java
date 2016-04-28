package com.fileserver.common.media;

import java.awt.Dimension;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.imageio.ImageIO;

import net.coobird.thumbnailator.Thumbnails;
import net.coobird.thumbnailator.Thumbnails.Builder;
import net.coobird.thumbnailator.geometry.Positions;

import org.apache.commons.lang3.StringUtils;

import com.fileserver.common.contants.ImageContants;
import com.fileserver.common.enums.Anchor;
import com.fileserver.common.enums.ResponseCodes;
import com.fileserver.common.exception.SystemException;
import com.fileserver.middleResult.ImageMiddleResult;

/**
 * 图片处理工具
 * 
 * @author tangbiao
 * 
 */
@SuppressWarnings("rawtypes")
public class ThumbGenerator {

	/**
	 * 根据图片路径获取
	 * 
	 * @param imgPath
	 * @return
	 */
	public static BufferedImage getBufferedImage(String imgPath) {
		try {
			File f = new File(imgPath);
	        if (f.exists() && !f.isDirectory()) {
				return ImageIO.read(new File(imgPath));
	        }
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 返回二进制
	 * 
	 * @param builder
	 * @return
	 */
	public static byte[] getBytes(Builder builder, String formatName) {
		byte[] bytes = null;
		ByteArrayOutputStream out = new ByteArrayOutputStream();
		try {
			BufferedImage image = builder.asBufferedImage();
			ImageIO.write(image, formatName, out);
			bytes = out.toByteArray();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
		}
		return bytes;
	}

	public static byte[] getBytes(String imgPath, String formatName) {
		byte[] bytes = null;
		ByteArrayOutputStream out = new ByteArrayOutputStream();
		try {
			BufferedImage image = Thumbnails.of(imgPath).asBufferedImage();
			ImageIO.write(image, formatName, out);
			bytes = out.toByteArray();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (out != null) {
					out.close();
				}
			} catch (Exception e2) {
			}
		}
		return bytes;
	}

	/**
	 * 基于原图大小，按指定百分比缩放
	 * 
	 * @param imgPath 原图片路径
	 * @param scale 比例
	 * @return
	 */
	public static Builder scale(Builder builder, Dimension originSize, float scale) {
		return builder.scale(scale);
	}

	/**
	 * 以百分比形式指定目标图片宽度，高度不变
	 * 
	 * @param imgPath 原图片路径
	 * @param widthScale 比例
	 * @return
	 */
	public static Builder scaleByWidthScale(Builder builder, Dimension originSize, float widthScale) {
		return builder.scale(widthScale, 1);
	}

	/**
	 * 以百分比形式指定目标图片高度，宽度不变
	 * 
	 * @param imgPath 原图片路径
	 * @param heightScale 比例
	 * @return
	 */
	public static Builder scaleByHeightScale(Builder builder, Dimension originSize, float heightScale) {
		return builder.scale(1, heightScale);
	}

	/**
	 * 指定目标图片宽度 等比缩放
	 * 
	 * @param imgPath 原图片路径
	 * @param width 宽
	 * @return
	 */
	public static Builder scaleWithWidth(Builder builder, Dimension originSize, int width) {

		return builder.size(width, (int) originSize.getHeight());
	}

	/**
	 * 指定目标图片高度 等比缩放
	 * 
	 * @param imgPath 原图片路径
	 * @param height 高
	 * @return
	 */
	public static Builder scaleWithHeight(Builder builder, Dimension originSize, int height) {

		return builder.size((int)originSize.getWidth(), height);
	}

	/**
	 * 限定长边，短边自适应缩放，将目标图片限制在指定宽高矩形内。取值范围不限，但若宽高超过10000时只能缩不能放
	 * 
	 * @param imgPath 原图片路径
	 * @param width 宽
	 * @param height 高
	 * @return
	 */
	public static Builder scaleByLimitLongSide(Builder builder, Dimension originSize, int width, int height) {

		if (width < 10000 && height < 10000) {

			float widthScale = width / (float)originSize.getWidth();
			float heightScale = height / (float)originSize.getHeight();			
			float scale = Math.min(widthScale, heightScale);
			
			return builder.size((int)(originSize.getWidth() * scale), (int)(originSize.getHeight() * scale));	
		}
		return builder;
	}

	/**
	 * 限定短边，长边自适应缩放，目标图片会延伸至指定宽高矩形外。取值范围不限，但若宽高超过10000时只能缩不能放
	 * 
	 * @param imgPath 原图片路径
	 * @param width 宽
	 * @param height 高
	 * @return
	 */
	public static Builder scaleByLimitShortSide(Builder builder, Dimension originSize, int width, int height) {

		if (width < 10000 && height < 10000) {

			float widthScale = width / (float)originSize.getWidth();
			float heightScale = height / (float)originSize.getHeight();
			float scale = Math.max(widthScale, heightScale);
			
			return builder.size((int)(originSize.getWidth() * scale), (int)(originSize.getHeight() * scale));	
		}
		return builder;
	}

	/**
	 * 限定目标图片宽高值，忽略原图宽高比例，按照指定宽高值强行缩略，可能导致目标图片变形。
	 * 
	 * @param imgPath 原图片路径
	 * @param width 宽
	 * @param height 高
	 * @return
	 */
	public static Builder scaleBySize(Builder builder, Dimension originSize, int width, int height) {

		return builder.size(width, height).keepAspectRatio(false);
	}

	/**
	 * 当原图尺寸大于给定的宽度或高度时，按照给定宽高值缩小。取值范围不限，但若宽高超过10000时只能缩不能放
	 * 
	 * @param imgPath 原图片路径
	 * @param width 宽
	 * @param height 高
	 * @return
	 */
	public static Builder scaleIfGreaterThanOriginSizeBySize(Builder builder, Dimension originSize, int width, int height) {

		float widthScale = width / (float)originSize.getWidth();
		float heightScale = height / (float)originSize.getHeight();

		if (widthScale > 0 && widthScale < 1 && heightScale > 0 && heightScale < 1 && width < 10000 && height < 10000) {
			return builder.size((int)(widthScale * originSize.getWidth()), (int)(heightScale * originSize.getHeight()));	
		}
		return builder;
	}

	/**
	 * 当原图尺寸小于给定的宽度或高度时，按照给定宽高值放大。取值范围不限，但若宽高超过10000时只能缩不能放
	 * 
	 * @param imgPath 原图片路径
	 * @param width 宽
	 * @param height 高
	 * @return
	 */
	public static Builder scaleIfLessThanOriginSizeBySize(Builder builder, Dimension originSize, int width, int height) {

		float widthScale = width / (float)originSize.getWidth();
		float heightScale = height / (float)originSize.getHeight();

		if (widthScale > 1 && heightScale > 1 && width < 10000 && height < 10000) {
			return builder.size((int)(widthScale * originSize.getWidth()), (int)(heightScale * originSize.getHeight()));
		}
		return builder;
	}

	/**
	 * 按原图高宽比例等比缩放，缩放后的像素数量不超过指定值。取值范围不限，但若像素数超过25000000时只能缩不能放
	 * 
	 * @param imgPath 原图片路径
	 * @param area 像素区间
	 * @return
	 */
	public static Builder scaleByArea(Builder builder, Dimension originSize, int area) {

		double originHeight = originSize.getHeight();
		double factor = originSize.getWidth()/originHeight;
		double height = Math.sqrt(area / factor);
		
		if (area < 25000000) {
			return builder.size((int)(height / originHeight * originSize.getWidth()), (int)height);
		}
		return builder;
	}
	
	/**
	 * 旋转
	 * 
	 * @param imgPath
	 * @param formatName
	 * @param rotate
	 * @param width
	 * @param height
	 * @return
	 */

	public static Builder imageRotate(Builder build, Dimension originSize,float rotate) {
		// rotate(角度),正数：顺时针负数：逆时针
		return build.rotate(rotate);
	}

	/**
	 * 图片质量压缩
	 * 
	 * @param imgPath
	 * @param formatName
	 * @param width
	 * @param height
	 * @param quality
	 * @return
	 */

	public static Builder imageQuality(Builder builder, Dimension originSize, float quality) {
		return builder.outputQuality(quality);
	}

	/**
	 * 裁剪 指定坐标
	 * 
	 * @param imgPath
	 * @param top
	 * @param left
	 * @param bottom
	 * @param right
	 * @return
	 */
	public static Builder imageCrop(Builder builder, Dimension originSize, int x, int y, int width, int height) {
		return builder.sourceRegion(x, y, width, height).keepAspectRatio(false);
	}
	
	public static Builder imageCrop(Builder builder, Dimension originSize, Positions positions, int width, int height) {
		return builder.sourceRegion(positions, width, height).keepAspectRatio(false);
	}

	/**
	 * 指定目标图片宽度，高度不变。取值范围0-10000
	 * 
	 * @param imgPath
	 * @param position
	 * @param width
	 * @param height
	 * @return
	 */
	public static Builder imageCropWithWidth(Builder builder, Dimension originSize, Positions positions, int width) {

		if (width < 10000 && width > 0) {
			return builder.sourceRegion(positions, width, (int) originSize.getHeight());
		}
		return builder;
	}

	/**
	 * 指定目标图片高度，宽度不变。取值范围0-10000
	 * 
	 * @param imgPath
	 * @param position
	 * @param width
	 * @param height
	 * @return
	 */
	public static Builder imageCropWithHeight(Builder builder, Dimension originSize, Positions positions, int height) {

		if (height < 10000 && height > 0) {
			return builder.sourceRegion(positions, (int) originSize.getWidth(), height);
		}
		return builder;
	}

	/**
	 * 同时指定目标图片宽高。取值范围0-10000
	 * 
	 * @param imgPath
	 * @param position
	 * @param width
	 * @param height
	 * @return
	 */
	public static Builder imageCropWithSize(Builder builder, Dimension originSize, Positions positions, int width, int height) {

		if (width < 10000 && width > 0 && height < 10000 && height > 0) {
			return imageCropWithSizeAndPossitionOffset(builder, originSize, positions, width, height, 0, 0);
		}
		return builder;
	}

	public static Builder imageCropWithWidthAndPossitionOffset(Builder builder, Dimension originSize, Positions positions, int width, int dx, int dy) {
		
		return imageCropWithSizeAndPossitionOffset(builder, originSize, positions, width, (int) originSize.getHeight(), dx, dy);
	}

	public static Builder imageCropWithHeightAndPossitionOffset(Builder builder, Dimension originSize, Positions positions, int height, int dx, int dy) {
		
		return imageCropWithSizeAndPossitionOffset(builder, originSize, positions, (int) originSize.getWidth(), height, dx, dy);
	}
	
	/**
	 * 相对于偏移锚点，向右偏移dx个像素，同时向下偏移dy个像素。取值范围不限，小于原图宽高即可
	 * 
	 * @param imgPath
	 * @param position
	 * @param width
	 * @param height
	 * @param dx
	 * @param dy
	 * @return
	 */
	public static Builder imageCropWithSizeAndPossitionOffset(Builder builder, Dimension originSize, Positions positions, int width, int height, int dx, int dy) {
		
		if (height < 10000 && height > 0) {

			double originWidth = originSize.getWidth();
			double originHeight = originSize.getHeight();
			double x = originWidth / 2.f;
			double y = originHeight / 2.f;

			switch (positions) {
			case TOP_LEFT:
				x = originWidth / 6.f;
				y = originHeight/ 6.f;
				break;

			case TOP_CENTER:
				y = originHeight/ 6.f;
				break;

			case TOP_RIGHT:
				x = originWidth / 6.f * 5;
				y = originHeight/ 6.f;
				break;

			case CENTER_LEFT:
				x = originWidth / 6.f;
				break;

			case CENTER_RIGHT:
				x = originWidth / 6.f * 5;
				break;

			case BOTTOM_LEFT:
				x = originWidth / 6.f;
				y = originHeight/ 6.f * 5;
				break;

			case BOTTOM_CENTER:
				y = originHeight/ 6.f * 5;
				break;

			case BOTTOM_RIGHT:
				x = originWidth / 6.f * 5;
				y = originHeight/ 6.f * 5;
				break;
			default:
				break;
			}
			Rectangle rectangle = new Rectangle((int)(x - width / 2.f) + dx , (int)(y - height / 2.) + dy, width, height);
			return builder.sourceRegion(rectangle);
		}
		return builder;
	}
	
	public static ImageMiddleResult imageHandle(String filePath, String scale, String anchor, String crop, String quality, String rotate, String format) throws IOException {

		if (StringUtils.isNotBlank(format)) {
			format = format.toLowerCase();
		} else {
			format = "png";
		}	
		Dimension size = ThumbGenerator.getBufferedImage(filePath).getRaster().getBounds().getSize();
		Builder builder = Thumbnails.of(filePath);
	
		if (builder != null) {
			// 对图片进行缩放
			if (!StringUtils.isNotBlank(scale)) {
				scale = "!100p";
			}
			builder = scaleImage(builder, size, scale);
			size = builder.asBufferedImage().getRaster().getBounds().getSize();;
			
			if (!StringUtils.isNotBlank(anchor)) {
				anchor = "c";
			}
			// 裁剪图片
			if (StringUtils.isNotBlank(crop)) {
				builder = cropImage(builder, size, anchor, crop);
			}
			// 质量
			if (StringUtils.isNotBlank(quality)) {
				int qualityValue = Integer.valueOf(quality);
				qualityValue = Math.min(qualityValue, 100);
				qualityValue = Math.max(qualityValue, 1);
				builder = ThumbGenerator.imageQuality(builder, size, qualityValue / 100.f);
			}
			// 旋转
			if (StringUtils.isNotBlank(rotate)) {
				int rotateValue = Integer.valueOf(rotate);
				rotateValue = rotateValue % 360;
				builder = ThumbGenerator.imageRotate(builder, size, rotateValue);
			}
			// 格式转换
			return new ImageMiddleResult("image/" + format, ThumbGenerator.getBytes(builder, format));
		}
		else {
			throw new SystemException(ResponseCodes.ImageNotExist, null);
		}
	}

	// 缩放图片
	private static Builder scaleImage(Builder builder, Dimension originSize, String scale) throws IOException {

	    Matcher numberMatcher = Pattern.compile(ImageContants.NUMBER_REGEX).matcher(scale);
		if (numberMatcher.find()) {
			
			// 基于原图大小，按指定百分比缩放。 取值范围0-1000
			if (scale.matches(ImageContants.SCALE_P_REGEX)) {
				float value = numberMatcher.group(0) != null ? Integer.parseInt(numberMatcher.group(0)) / 100.f : 1;
				builder = ThumbGenerator.scale(builder, originSize, value);	
			}
			// 以百分比形式指定目标图片宽度，高度不变。取值范围为0-1000 
			else if (scale.matches(ImageContants.SCALE_PX_REGEX)) {
				float widthScale = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) / 100.f : 1;
				builder = ThumbGenerator.scaleByWidthScale(builder, originSize, widthScale);
			} 
			// 以百分比形式指定目标图片高度，宽度不变。取值范围为0-1000
			else if (scale.matches(ImageContants.SCALE_I_XP_REGEX)) {
				float heightScale = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) / 100.f : 1;
				builder = ThumbGenerator.scaleByHeightScale(builder, originSize, heightScale);
			} 
			// 指定目标图片宽度 等比缩放。 取值范围0-10000
			else if (scale.matches(ImageContants.SCALE_WIDTH_X_REGEX)) {
				int width = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
				builder = ThumbGenerator.scaleWithWidth(builder, originSize, width);
			}
			// 指定目标图片高度 等比缩放。 取值范围0-10000
			else if (scale.matches(ImageContants.SCALE_X_HEIGHT_REGEX)) {
				int height = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
				builder = ThumbGenerator.scaleWithHeight(builder, originSize, height);
			} 
			// 限定长边，短边自适应缩放，将目标图片限制在指定宽高矩形内。取值范围不限，但若宽高超过10000时只能缩不能放
			else if (scale.matches(ImageContants.SCALE_WIDTH_X_HEIGHT_REGEX)) {
				int width = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
				if (numberMatcher.find()) {
					int height = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
					builder = ThumbGenerator.scaleByLimitLongSide(builder, originSize, width, height);	
				}
			} 
			// 限定短边，长边自适应缩放，目标图片会延伸至指定宽高矩形外。取值范围不限，但若宽高超过10000时只能缩不能放
			else if (scale.matches(ImageContants.SCALE_I_WIDTH_X_HEIGHT_R_REGEX)) {
				int width = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
				if (numberMatcher.find()) {
					int height = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
					builder = ThumbGenerator.scaleByLimitShortSide(builder, originSize, width, height);
				}
			}
			// 限定目标图片宽高值，忽略原图宽高比例，按照指定宽高值强行缩略，可能导致目标图片变形。
			else if (scale.matches(ImageContants.SCALE_WIDTH_X_HEIGHT_I_REGEX)) {
				int width = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
				if (numberMatcher.find()) {
					int height = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
					builder = ThumbGenerator.scaleBySize(builder, originSize, width, height);
				}
			}
			// 当原图尺寸大于给定的宽度或高度时，按照给定宽高值缩小。取值范围不限，但若宽高超过10000时只能缩不能放
			else if (scale.matches(ImageContants.SCALE_WIDTH_X_HEIGHT_G_REGEX)) {
				int width = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
				if (numberMatcher.find()) {
					int height = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
					builder = ThumbGenerator.scaleIfGreaterThanOriginSizeBySize(builder, originSize, width, height);
				}
			}
			// 当原图尺寸小于给定的宽度或高度时，按照给定宽高值放大。取值范围不限，但若宽高超过10000时只能缩不能放
			else if (scale.matches(ImageContants.SCALE_WIDTH_X_HEIGHT_L_REGEX)) {
				int width = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
				if (numberMatcher.find()) {
					int height = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
					builder = ThumbGenerator.scaleIfLessThanOriginSizeBySize(builder, originSize, width, height);
				}
			}
			// 按原图高宽比例等比缩放，缩放后的像素数量不超过指定值。取值范围不限，但若像素数超过25000000时只能缩不能放
			else if (scale.matches(ImageContants.SCALE_AREA_REGEX)) {
				int area = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
				builder = ThumbGenerator.scaleByArea(builder, originSize, area);
			}
		}
		return Thumbnails.of(builder.asBufferedImage()).scale(1.f);
	}

	// 图片裁剪
	// 若图片之前已做过处理，则builder不为空 否则 builder 为 null
	private static Builder cropImage(Builder builder, Dimension originSize, String anchor, String crop) throws IOException {

	    Matcher numberMatcher = Pattern.compile(ImageContants.NUMBER_REGEX).matcher(crop);
	    if (numberMatcher.find()) {
		    // 指定目标图片宽度，高度不变。取值范围0-10000
			if (crop.matches(ImageContants.CROP_SIZE_WIDTH_X_REGEX)) {
				int width = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
				builder = ThumbGenerator.imageCropWithWidth(builder, originSize, Anchor.getPositionsByAnchorCode(anchor), width);
			}
			// 指定目标图片高度，宽度不变。取值范围0-10000
			else if (crop.matches(ImageContants.CROP_SIZE_X_HEIGHT_REGEX)) {
				int height = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
				builder = ThumbGenerator.imageCropWithHeight(builder, originSize, Anchor.getPositionsByAnchorCode(anchor), height);
			}
			// 同时指定目标图片宽高。取值范围0-10000
			else if (crop.matches(ImageContants.CROP_SIZE_WIDTH_X_HEIGHT_REGEX)) {
				int width = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
				if (numberMatcher.find()) {
					int height = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
					builder = ThumbGenerator.imageCropWithSize(builder, originSize, Anchor.getPositionsByAnchorCode(anchor), width, height);	
				}
			}
			// 相对于偏移锚点，向右偏移dx个像素，同时向下偏移dy个像素。取值范围不限，小于原图宽高即可
			else if (crop.matches(ImageContants.CROP_SIZE_WIDTH_X_OFFSET_A_X_A_Y_REGEX)) {
				int width = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
				Point offset = pointFromMatcher(numberMatcher);
				builder = ThumbGenerator.imageCropWithWidthAndPossitionOffset(builder, originSize, Anchor.getPositionsByAnchorCode(anchor), width, offset.x, offset.y);
			}
			// 相对于偏移锚点，向右偏移dx个像素，同时向下偏移dy个像素。取值范围不限，小于原图宽高即可
		    else if (crop.matches(ImageContants.CROP_SIZE_X_HEIGHT_OFFSET_A_X_A_Y_REGEX)) {
				int height = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
				Point offset = pointFromMatcher(numberMatcher);
				builder = ThumbGenerator.imageCropWithHeightAndPossitionOffset(builder, originSize, Anchor.getPositionsByAnchorCode(anchor), height, offset.x, offset.y);
		    }
			// 相对于偏移锚点，向右偏移dx个像素，同时向下偏移dy个像素。取值范围不限，小于原图宽高即可
		    else if (crop.matches(ImageContants.CROP_SIZE_WIDTH_X_HEIGHT_OFFSET_A_X_A_Y_REGEX)) {
		    	int width = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
		    	if (numberMatcher.find()) {
			    	int height = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
					Point offset = pointFromMatcher(numberMatcher);
					builder = ThumbGenerator.imageCropWithSizeAndPossitionOffset(builder, originSize, Anchor.getPositionsByAnchorCode(anchor), width, height, offset.x, offset.y);
		    	}
		    }
			// 相对于偏移锚点，从指定宽度中减去dx个像素，同时向下偏移dy个像素。取值范围不限，小于原图宽高即可
		    else if (crop.matches(ImageContants.CROP_SIZE_WIDTH_X_OFFSET_X_A_Y_REGEX)) {
				int width = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
				Point offset = pointFromMatcher(numberMatcher);
				builder = ThumbGenerator.imageCropWithWidthAndPossitionOffset(builder, originSize, Anchor.getPositionsByAnchorCode(anchor), width, -offset.x, offset.y);
			}
			// 相对于偏移锚点，从指定宽度中减去dx个像素，同时向下偏移dy个像素。取值范围不限，小于原图宽高即可
		    else if (crop.matches(ImageContants.CROP_SIZE_X_HEIGHT_OFFSET_X_A_Y_REGEX)) {
				int height = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
				Point offset = pointFromMatcher(numberMatcher);
				builder = ThumbGenerator.imageCropWithHeightAndPossitionOffset(builder, originSize, Anchor.getPositionsByAnchorCode(anchor), height, -offset.x, offset.y);
		    }
			// 相对于偏移锚点，从指定宽度中减去dx个像素，同时向下偏移dy个像素。取值范围不限，小于原图宽高即可
		    else if (crop.matches(ImageContants.CROP_SIZE_WIDTH_X_HEIGHT_OFFSET_X_A_Y_REGEX)) {
		    	int width = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
		    	if (numberMatcher.find()) {
			    	int height = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
					Point offset = pointFromMatcher(numberMatcher);
					builder = ThumbGenerator.imageCropWithSizeAndPossitionOffset(builder, originSize, Anchor.getPositionsByAnchorCode(anchor), width, height, -offset.x, offset.y);
		    	}
		    }

			// 相对于偏移锚点，向右偏移dx个像素，同时从指定高度中减去dy个像素。取值范围不限，小于原图宽高即可
		    else if (crop.matches(ImageContants.CROP_SIZE_WIDTH_X_OFFSET_A_X_Y_REGEX)) {
				int width = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
				Point offset = pointFromMatcher(numberMatcher);
				builder = ThumbGenerator.imageCropWithWidthAndPossitionOffset(builder, originSize, Anchor.getPositionsByAnchorCode(anchor), width, offset.x, -offset.y);
			}
			// 相对于偏移锚点，向右偏移dx个像素，同时从指定高度中减去dy个像素。取值范围不限，小于原图宽高即可
		    else if (crop.matches(ImageContants.CROP_SIZE_X_HEIGHT_OFFSET_A_X_Y_REGEX)) {
				int height = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
				Point offset = pointFromMatcher(numberMatcher);
				builder = ThumbGenerator.imageCropWithHeightAndPossitionOffset(builder, originSize, Anchor.getPositionsByAnchorCode(anchor), height, offset.x, -offset.y);
		    }
			// 相对于偏移锚点，向右偏移dx个像素，同时从指定高度中减去dy个像素。取值范围不限，小于原图宽高即可
		    else if (crop.matches(ImageContants.CROP_SIZE_WIDTH_X_HEIGHT_OFFSET_A_X_Y_REGEX)) {
		    	int width = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
		    	if (numberMatcher.find()) {
			    	int height = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
					Point offset = pointFromMatcher(numberMatcher);
					builder = ThumbGenerator.imageCropWithSizeAndPossitionOffset(builder, originSize, Anchor.getPositionsByAnchorCode(anchor), width, height, offset.x, -offset.y);
		    	}
		    }

			// 相对于偏移锚点，从指定宽度中减去dx个像素，同时从指定高度中减去dy个像素。取值范围不限，小于原图宽高即可
		    else if (crop.matches(ImageContants.CROP_SIZE_WIDTH_X_OFFSET_X_Y_REGEX)) {
				int width = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
				Point offset = pointFromMatcher(numberMatcher);
				builder = ThumbGenerator.imageCropWithWidthAndPossitionOffset(builder, originSize, Anchor.getPositionsByAnchorCode(anchor), width, -offset.x, -offset.y);
			}
			// 相对于偏移锚点，从指定宽度中减去dx个像素，同时从指定高度中减去dy个像素。取值范围不限，小于原图宽高即可
		    else if (crop.matches(ImageContants.CROP_SIZE_X_HEIGHT_OFFSET_X_Y_REGEX)) {
				int height = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
				Point offset = pointFromMatcher(numberMatcher);
				builder = ThumbGenerator.imageCropWithHeightAndPossitionOffset(builder, originSize, Anchor.getPositionsByAnchorCode(anchor), height, -offset.x, -offset.y);
		    }
			// 相对于偏移锚点，从指定宽度中减去dx个像素，同时从指定高度中减去dy个像素。取值范围不限，小于原图宽高即可
		    else if (crop.matches(ImageContants.CROP_SIZE_WIDTH_X_HEIGHT_OFFSET_X_Y_REGEX)) {
		    	int width = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
		    	if (numberMatcher.find()) {
			    	int height = numberMatcher.group() != null ? Integer.parseInt(numberMatcher.group()) : 0;
					Point offset = pointFromMatcher(numberMatcher);
					builder = ThumbGenerator.imageCropWithSizeAndPossitionOffset(builder, originSize, Anchor.getPositionsByAnchorCode(anchor), width, height, -offset.x, -offset.y);
		    	}
		    }
		}

		return builder;
	}
	
	private static Point pointFromMatcher(Matcher matcher) {
		if (matcher.find()) {
			int dx = Integer.parseInt(matcher.group());
			if (matcher.find()) {
				int dy = Integer.parseInt(matcher.group());
				return new Point(dx, dy);
			}
		}
		return null;
	}
}
