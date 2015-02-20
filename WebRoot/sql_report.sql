1.
-- student info
SELECT st.first_name as first, st.middle_name as middle, st.last_name as last, st.ssn as ssn
FROM student st, student_enrollment se
WHERE st.stu_id = se.stu_id AND se.year = 2009 AND se.quarter = 'SPRING'

-- current class
SELECT ss.unit as unit, ss.section_id as section_id, c.class_id as class_id, c.title as title, c.course_id as course_id, c.year as year, c.quarter as quarter
FROM student st, student_section ss, section se, class c
WHERE st.ssn = ? AND st.stu_id = ss.stu_id AND ss.section_id = se.section_id AND se.class_id = c.class_id AND c.year = 2009 AND c.quarter = 'SPRING'

2.
-- class info
SELECT cl.title as title, cl.year as year, cl.quarter as quarter, co.course_number as course_number
FROM class cl, course co
WHERE cl.course_id = co.course_id

-- roster
SELECT st.stu_id, st.ssn, st.citizen, st.pre_school, st.pre_degree, st.pre_major, st.first_name as first, st.middle_name as middle, st.last_name as last, ss.unit, ss.letter_su
FROM class cl, section se, student_section ss, student st
WHERE cl.title = ? AND se.class_id = cl.class_id AND ss.section_id = se.section_id AND ss.stu_id = st.stu_id

3.
-- student info
SELECT st.first_name as first, st.middle_name as middle, st.last_name as last, st.ssn as ssn
FROM student st
WHERE EXISTS (
    SELECT se.stu_id
    FROM student_enrollment se
    WHERE st.stu_id = se.stu_id
)

-- for class
SELECT cl.year, cl.quarter, cl.class_id, cl.title, cl.course_id, ss.grade, ss.unit, ss.letter_su
FROM student st, student_section ss, section se, class cl
WHERE st.ssn = ? AND st.stu_id = ss.stu_id AND ss.section_id = se.section_id AND se.class_id = cl.class_id
ORDER BY cl.year, cl.quarter

-- for GPA
SELECT cl.year, cl.quarter, SUM(ss.unit * co.grade_num) / SUM(ss.unit)
FROM student st, student_section ss, section se, class cl, conversion co
WHERE st.ssn = ? AND st.stu_id = ss.stu_id AND ss.section_id = se.section_id AND se.class_id = cl.class_id AND ss.letter_su = 'letter' AND ss.grade <> 'IN' AND ss.grade = co.grade_letter
GROUP BY cl.year, cl.quarter

-- for total GPA
SELECT SUM(ss.unit * co.grade_num) / SUM(ss.unit)
FROM student st, student_section ss, section se, class cl, conversion co
WHERE st.ssn = ? AND st.stu_id = ss.stu_id AND ss.section_id = se.section_id AND se.class_id = cl.class_id AND ss.letter_su = 'letter' AND ss.grade <> 'IN' AND ss.grade = co.grade_letter

4.
-- undergrad info
SELECT s.ssn, s.first_name, s.middle_name, s.last_name
FROM student s, student_enrollment se
WHERE s.stu_id = se.stu_id AND se.year = 2009 AND se.quarter = 'SPRING'AND NOT EXISTS (
SELECT *
FROM grad g
WHERE s.stu_id = g.stu_id
)

-- undergrad degree
SELECT name, type
FROM degree
WHERE type = 'BE' OR type = 'BA'

-- total remainunit
SELECT de.total_min_unit - SUM(ss.unit) AS remain_unit
FROM student st, student_section ss, degree de
WHERE de.name = ? AND st.ssn = ? AND st.stu_id = ss.stu_id AND ss.grade <> 'IN' AND ss.grade <> 'na'
GROUP BY de.total_min_unit

-- remain category unit
SELECT dc.cate_id, dc.min_unit - SUM(ss.unit) AS remain_cate_unit
FROM student st, student_section ss, section se, class cl, course co, degree de, degree_category dc
WHERE st.ssn = ? AND st.stu_id = ss.stu_id AND ss.grade <> 'IN' AND ss.grade <> 'na' AND ss.section_id = se.section_id AND se.class_id = cl.class_id AND cl.course_id = co.course_id
        AND de.name = ? AND de.degree_id = dc.degree_id AND dc.cate_id = co.cate_id
GROUP BY dc.cate_id, dc.min_unit

5.
-- grad info
SELECT s.ssn, s.first_name, s.middle_name, s.last_name
FROM student s, student_enrollment se
WHERE s.stu_id = se.stu_id AND se.year = 2009 AND se.quarter = 'SPRING'AND NOT EXISTS (
SELECT *
FROM undergrad u
WHERE s.stu_id = u.stu_id
)

-- grad degree
SELECT name, type
FROM degree
WHERE type = 'MS'

-- concenctration completed
SELECT dc.con_id, dc.min_unit, SUM(ss.unit) AS unit, SUM(ss.unit * co.grade_num) / SUM(ss.unit) AS grade
FROM student st, student_section ss, section se, class cl, course_concentration cc, degree de, degree_concentration dc, conversion co
WHERE st.ssn = ? AND st.stu_id = ss.stu_id AND ss.grade <> 'IN' AND ss.grade <> 'na' AND ss.section_id = se.section_id AND se.class_id = cl.class_id AND cl.course_id = cc.course_id
    AND ss.grade = co.grade_letter AND cc.con_id = dc.con_id AND de.name = ? AND de.degree_id = dc.degree_id
GROUP BY dc.con_id, dc.min_unit, dc.min_grade
HAVING dc.min_unit - SUM(ss.unit) <= 0 AND dc.min_grade - SUM(ss.unit * co.grade_num) / SUM(ss.unit) <= 0

-- next available time
SELECT
FROM
WHERE
GROUP BY

6.
SELECT st.first_name as first, st.middle_name as middle, st.last_name as last, st.ssn as ssn
FROM student st, student_enrollment se
WHERE st.stu_id = se.stu_id AND se.year = 2009 AND se.quarter = 'SPRING'

SELECT s.section_id, c.course_id
FROM section s, class c
WHERE s.class_id = c.class_id AND c.year = 2009 AND c.quarter = 'SPRING'

7.
SELECT st.stu_id
FROM class cl, section se, student_section ss, student st
WHERE cl.class_id = ? AND se.class_id = cl.class_id AND ss.section_id = se.section_id AND ss.stu_id = st.stu_id

8.
SELECT co.course_id
FROM course co

SELECT fa.fac_id
FROM faculty fa








