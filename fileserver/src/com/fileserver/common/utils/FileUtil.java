package com.fileserver.common.utils;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.math.BigDecimal;

public class FileUtil {

    public static final int FILE_SIZE_TYPE_K = 0;

    public static final int FILE_SIZE_TYPE_M = 1;

    /**
     * 复制文件
     * 
     * @param source
     *            原文家路径
     * @param distm
     *            要复制到的目标路径 2010-5-4
     */
    public static void copyFile(String source, String dist, String fileName)
            throws IOException {
        copyFile(new File(source), dist, fileName);
    }

    /**
     * 创建目录，支持多级目录创建
     * 
     * @param path
     * @return
     */
    public static boolean mkdir(String path) {
        File f = new File(path);
        if (!f.exists() || !f.isDirectory()) {
            return f.mkdirs();
        }
        return false;
    }

    /**
     * 判断是否时目录
     * 
     * @param path
     * @return
     */
    public static boolean isFileDirectory(String path) {
        File f = new File(path);
        if (!f.exists()) {
            return false;
        }
        return f.isDirectory();
    }

    /**
     * 复制文件
     * 
     * @param file
     *            源文件
     * @param dist
     *            目标目录
     * @param fileName
     *            文件名称
     * @throws IOException
     */
    public static void copyFile(File file, String dist, String fileName)
            throws IOException {
        mkdir(dist);
        BufferedOutputStream buffos = null;
        BufferedInputStream buffis = null;
        byte[] by = new byte[1024];
        try {
            buffos = new BufferedOutputStream(new FileOutputStream(dist + "/"
                    + fileName));
            buffis = new BufferedInputStream(new FileInputStream(file));
            int len = -1;
            while ((len = buffis.read(by)) != -1) {
                buffos.write(by, 0, len);
            }
            buffos.flush();
        }
        catch (FileNotFoundException e) {
        	throw e;
        }
        finally {
            try {
                if (buffos != null) {
                    buffos.close();
                }
            }
            catch (IOException e) {
            	throw e;
            }
            try {
                if (buffis != null) {
                    buffis.close();
                }
            }
            catch (IOException e) {
            	throw e;
            }
        }
    }

    /**
     * 查看文件大小是否大于指定大小
     * 
     * @param file
     * @param size
     *            单位为k
     * @return true:文件大小超过指定大小,false:文件大小在指定大小之内 2010-5-10
     */
    public static boolean isBigger(File file, long size) {
        long fileSize = file.length();
        BigDecimal decimal = new BigDecimal(fileSize).divide(new BigDecimal(
                1024), 0, BigDecimal.ROUND_HALF_UP);
        long amount = decimal.longValue() - size;
        if (amount > 0) {
            return true;
        }
        return false;
    }

    /**
     * 获得文件大小
     * 
     * @param file
     * @param sizeType
     *            指定返回值单位 {@link FileUtil#FILE_SIZE_TYPE_K},
     *            {@link FileUtil#FILE_SIZE_TYPE_M}
     * @return
     */
    public static long getFileSize(File file, int sizeType) {
        long fileSize = file.length();
        if (sizeType == FILE_SIZE_TYPE_K) {
            BigDecimal decimal = new BigDecimal(fileSize).divide(
                    new BigDecimal(1024), 0, BigDecimal.ROUND_HALF_UP);
            return decimal.longValue();
        }
        if (sizeType == FILE_SIZE_TYPE_M) {
            BigDecimal decimal = new BigDecimal(fileSize).divide(
                    new BigDecimal(1024 * 1024), 0, BigDecimal.ROUND_HALF_UP);
            return decimal.longValue();
        }
        return fileSize;
    }

    /**
     * 删除文件
     * 
     * @param file
     * @return
     */
    public static boolean deleteFile(File file) {
        if (file == null) {
            return false;
        }
        if (file.exists()) {
            if (!file.delete()) {
                return false;
            }
            return true;
        }
        return false;
    }

    /**
     * 删除指定目录下的所有文件
     * 
     * @param dirPath
     */
    public static void deleteAllFile(String dirPath) {
        File file = new File(dirPath);
        if (file.exists()) {
            if (file.isDirectory()) {
                File[] fs = file.listFiles();
                String path = null;
                for (File f : fs) {
                    path = f.getAbsolutePath();
                    deleteAllFile(path);
                }
                if (!file.delete()) {
                    throw new RuntimeException("delete file fail [ "
                            + file.getAbsolutePath() + " ]");
                }
            }
            else {
                if (!file.delete()) {
                    throw new RuntimeException("delete file fail [ "
                            + file.getAbsolutePath() + " ]");
                }
            }
        }
    }
}
