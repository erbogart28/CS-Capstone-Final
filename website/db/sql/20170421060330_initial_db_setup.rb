class InitialDbSetup < ActiveRecord::Migration[5.0]
  def change
    execute <<-SQL

-- ---
-- Globals
-- ---

-- SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
-- SET FOREIGN_KEY_CHECKS=0;

-- ---
-- Table 'Users'
-- User login information and associated account data
-- ---

DROP TABLE IF EXISTS `Users`;
		
CREATE TABLE `Users` (
  `id` INTEGER NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(60) NOT NULL,
  `password` VARCHAR(255) NOT NULL DEFAULT 'NULL',
  `permission` VARCHAR(60) NOT NULL DEFAULT 'STUDENT',
  `view_as` VARCHAR(60) NULL DEFAULT NULL,
  `first` VARCHAR(100) NULL DEFAULT NULL,
  `last` VARCHAR(100) NULL DEFAULT NULL,
  `email` VARCHAR(100) NULL DEFAULT NULL,
  `degree_id` INTEGER NULL DEFAULT NULL,
  `course_load` INTEGER(11) NULL DEFAULT NULL,
  `in-class` TINYINT(1) NULL DEFAULT 0,
  `online` TINYINT(1) NULL DEFAULT 0,
  `path_id` INTEGER NULL DEFAULT NULL,
  `deleted` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '0 = False, 1 = True',
  PRIMARY KEY (`id`)
) COMMENT 'User login information and associated account data';

-- ---
-- Table 'Courses'
-- All CS/IS MS courses offered and their details
-- ---

DROP TABLE IF EXISTS `Courses`;
		
CREATE TABLE `Courses` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `people_soft_id` INTEGER NULL DEFAULT NULL,
  `name` VARCHAR(60) NOT NULL,
  `description` VARCHAR NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) COMMENT 'All CS/IS MS courses offered and their details';

-- ---
-- Table 'Prereqs'
-- 
-- ---

DROP TABLE IF EXISTS `Prereqs`;
		
CREATE TABLE `Prereqs` (
  `course_id` INTEGER NOT NULL,
  `prereq_course_id` INTEGER NOT NULL,
  PRIMARY KEY (`course_id`)
);

-- ---
-- Table 'Paths'
-- 
-- ---

DROP TABLE IF EXISTS `Paths`;
		
CREATE TABLE `Paths` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `degree_id` INTEGER NOT NULL,
  `start_quarter` VARCHAR(60) NOT NULL,
  `course_load` INTEGER(11) NOT NULL,
  `in_class` TINYINT(1) NOT NULL DEFAULT 0,
  `online` TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
);

-- ---
-- Table 'PathCourses'
-- Save paths based on start quarter, classes per quarter, course delivery. Then, uses path id to get all corresponding path courses.
-- ---

DROP TABLE IF EXISTS `PathCourses`;
		
CREATE TABLE `PathCourses` (
  `path_id` INTEGER NOT NULL,
  `course_id` INTEGER NOT NULL,
  `year` INTEGER(11) NOT NULL,
  `course_term` VARCHAR(60) NOT NULL DEFAULT '0' COMMENT '0 = False, 1 = True',
  PRIMARY KEY (`path_id`)
) COMMENT 'Save paths based on start quarter, classes per quarter, cour';

-- ---
-- Table 'Degrees'
-- Requirements for a degree
-- ---

DROP TABLE IF EXISTS `Degrees`;
		
CREATE TABLE `Degrees` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `major` VARCHAR(100) NOT NULL,
  `concentration` VARCHAR(100) NULL DEFAULT NULL,
  `degree_reqs_id` INTEGER NOT NULL,
  PRIMARY KEY (`id`)
) COMMENT 'Requirements for a degree';

-- ---
-- Table 'DegreeReqs'
-- 
-- ---

DROP TABLE IF EXISTS `DegreeReqs`;
		
CREATE TABLE `DegreeReqs` (
  `id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `course_id` INTEGER NOT NULL,
  PRIMARY KEY (`id`)
);

-- ---
-- Table 'CourseDelivery'
-- 
-- ---

DROP TABLE IF EXISTS `CourseDelivery`;
		
CREATE TABLE `CourseDelivery` (
  `course_id` INTEGER NULL AUTO_INCREMENT DEFAULT NULL,
  `course_term` VARCHAR(60) NOT NULL,
  `course_frequency` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`course_id`)
);

-- ---
-- Table 'CourseFrequency'
-- 
-- ---

DROP TABLE IF EXISTS `CourseFrequency`;
		
CREATE TABLE `CourseFrequency` (
  `frequency` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`frequency`)
);

-- ---
-- Table 'CourseTerm'
-- 
-- ---

DROP TABLE IF EXISTS `CourseTerm`;
		
CREATE TABLE `CourseTerm` (
  `term` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`term`)
);

-- ---
-- Table 'CompletedCourses'
-- 
-- ---

DROP TABLE IF EXISTS `CompletedCourses`;
		
CREATE TABLE `CompletedCourses` (
  `user_id` INTEGER NOT NULL,
  `course_id` INTEGER NOT NULL,
  PRIMARY KEY (`user_id`)
);

-- ---
-- Foreign Keys 
-- ---

ALTER TABLE `Users` ADD FOREIGN KEY (id) REFERENCES `CompletedCourses` (`user_id`);
ALTER TABLE `Users` ADD FOREIGN KEY (degree_id) REFERENCES `Degrees` (`id`);
ALTER TABLE `Users` ADD FOREIGN KEY (path_id) REFERENCES `Paths` (`id`);
ALTER TABLE `Courses` ADD FOREIGN KEY (id) REFERENCES `Prereqs` (`course_id`);
ALTER TABLE `Courses` ADD FOREIGN KEY (id) REFERENCES `CourseDelivery` (`course_id`);
ALTER TABLE `Prereqs` ADD FOREIGN KEY (prereq_course_id) REFERENCES `Courses` (`id`);
ALTER TABLE `Paths` ADD FOREIGN KEY (id) REFERENCES `PathCourses` (`path_id`);
ALTER TABLE `Paths` ADD FOREIGN KEY (degree_id) REFERENCES `Degrees` (`id`);
ALTER TABLE `PathCourses` ADD FOREIGN KEY (course_id) REFERENCES `Courses` (`id`);
ALTER TABLE `PathCourses` ADD FOREIGN KEY (course_term) REFERENCES `CourseTerm` (`term`);
ALTER TABLE `Degrees` ADD FOREIGN KEY (degree_reqs_id) REFERENCES `DegreeReqs` (`id`);
ALTER TABLE `DegreeReqs` ADD FOREIGN KEY (course_id) REFERENCES `Courses` (`id`);
ALTER TABLE `CourseDelivery` ADD FOREIGN KEY (course_term) REFERENCES `CourseTerm` (`term`);
ALTER TABLE `CourseDelivery` ADD FOREIGN KEY (course_frequency) REFERENCES `CourseFrequency` (`frequency`);
ALTER TABLE `CompletedCourses` ADD FOREIGN KEY (course_id) REFERENCES `Courses` (`id`);

-- ---
-- Table Properties
-- ---

-- ALTER TABLE `Users` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `Courses` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `Prereqs` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `Paths` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `PathCourses` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `Degrees` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `DegreeReqs` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `CourseDelivery` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `CourseFrequency` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `CourseTerm` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `CompletedCourses` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ---
-- Test Data
-- ---

-- INSERT INTO `Users` (`id`,`username`,`password`,`permission`,`view_as`,`first`,`last`,`email`,`degree_id`,`course_load`,`in-class`,`online`,`path_id`,`deleted`) VALUES
-- ('','','','','','','','','','','','','','');
-- INSERT INTO `Courses` (`id`,`people_soft_id`,`name`,`description`) VALUES
-- ('','','','');
-- INSERT INTO `Prereqs` (`course_id`,`prereq_course_id`) VALUES
-- ('','');
-- INSERT INTO `Paths` (`id`,`degree_id`,`start_quarter`,`course_load`,`in_class`,`online`) VALUES
-- ('','','','','','');
-- INSERT INTO `PathCourses` (`path_id`,`course_id`,`year`,`course_term`) VALUES
-- ('','','','');
-- INSERT INTO `Degrees` (`id`,`major`,`concentration`,`degree_reqs_id`) VALUES
-- ('','','','');
-- INSERT INTO `DegreeReqs` (`id`,`course_id`) VALUES
-- ('','');
-- INSERT INTO `CourseDelivery` (`course_id`,`course_term`,`course_frequency`) VALUES
-- ('','','');
-- INSERT INTO `CourseFrequency` (`frequency`) VALUES
-- ('');
-- INSERT INTO `CourseTerm` (`term`) VALUES
-- ('');
-- INSERT INTO `CompletedCourses` (`user_id`,`course_id`) VALUES
-- ('','');

    SQL
  end
end

