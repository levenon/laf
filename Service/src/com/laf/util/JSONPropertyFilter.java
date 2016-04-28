package com.laf.util;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

//可以注解在字段，方法，类上
@Retention(RetentionPolicy.RUNTIME)
@Target({ ElementType.FIELD, ElementType.METHOD,ElementType.TYPE })
public @interface JSONPropertyFilter {

  //默认注解了就是过滤
  boolean value() default true;
}
