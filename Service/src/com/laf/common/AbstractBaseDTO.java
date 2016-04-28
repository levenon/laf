package com.laf.common;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.codehaus.jackson.map.annotate.JsonSerialize;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.ObjectMapper;

@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonSerialize(include = JsonSerialize.Inclusion.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public abstract class AbstractBaseDTO {
    protected final Logger logger = LoggerFactory.getLogger(getClass());
    protected ObjectMapper jsonMapper;
    
    public String toString() {
        return ToStringBuilder.reflectionToString(this);
    }
}
