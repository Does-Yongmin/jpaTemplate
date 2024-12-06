package com.does.annotation;

import javax.validation.Constraint;
import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import javax.validation.Payload;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.util.regex.Pattern;


/** 
 * String 타입에 대한 UUID Validation
 * */
@Constraint(validatedBy = UUIDValidator.class)
@Target({ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
public @interface UUID {
	String message() default "Invalid UUID format";
	boolean nullable() default true;					// null 허용 (null 체크는 관련 어노테이션이나 별도 validation 로 진행)
	int version() default -1; 							// -1 means no specific version (= all version)
	Class<?>[] groups() default {};
	Class<? extends Payload>[] payload() default {};
}

class UUIDValidator implements ConstraintValidator<UUID, String> {
	private static final Pattern UUID_REGEX =
		Pattern.compile("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$");
	private boolean nullable;
	private int version;
	
	@Override
	public void initialize(UUID constraintAnnotation) {
		this.nullable = constraintAnnotation.nullable();
		this.version = constraintAnnotation.version();
	}
	
	@Override
	public boolean isValid(String uuid, ConstraintValidatorContext context) {
		if (uuid == null) {
			return nullable;
		}
		
		if (!UUID_REGEX.matcher(uuid).matches()) {
			return false;
		}
		
		if (version != -1 && !isValidVersion(uuid, version)) {
			context.disableDefaultConstraintViolation();
			context.buildConstraintViolationWithTemplate("UUID must be of version " + version)
				.addConstraintViolation();
			return false;
		}
		
		return true;
	}
	
	private boolean isValidVersion(String uuid, int version) {
		// xxxxxxxx-xxxx-Mxxx-xxxx-xxxxxxxxxxxx (M = UUID version. ex : 1, 2, 3, 4, 5)
		return (Character.digit(uuid.charAt(14), 16) == version);
	}
}