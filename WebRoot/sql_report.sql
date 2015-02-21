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

-- temp table temp1: con_id and unit
SELECT cc.con_id, SUM(ss.unit) AS unit
FROM student st, student_section ss, section se, class cl, course_concentration cc
WHERE st.ssn = ? AND st.stu_id = ss.stu_id AND ss.grade <> 'IN' AND ss.grade <> 'na' AND ss.section_id = se.section_id AND se.class_id = cl.class_id AND cl.course_id = cc.course_id
GROUP BY cc.con_id
-- temp table temp2: con_id and grade
SELECT cc.con_id, SUM(ss.unit * co.grade_num) / SUM(ss.unit) AS grade
FROM student st, student_section ss, section se, class cl, course_concentration cc, conversion co
WHERE st.ssn = ? AND st.stu_id = ss.stu_id AND ss.letter_su = 'letter' AND ss.grade <> 'IN' AND ss.grade <> 'na' AND ss.section_id = se.section_id AND se.class_id = cl.class_id AND cl.course_id = cc.course_id
    AND ss.grade = co.grade_letter
GROUP BY cc.con_id

-- concenctration completed (GPA issue, use intersect?)
SELECT dc.con_id
FROM degree de, degree_concentration dc, temp1, temp2
WHERE de.degree_id = ? AND de.degree_id = dc.degree_id AND dc.con_id = temp1.con_id AND dc.min_unit - temp1.unit <= 0 AND dc.con_id = temp2.con_id AND dc.min_grade - temp2.grade <= 0

-- next available time. We treat the courses a student is taking this quarter as pass by default.
-- temp table temp3: con_id
SELECT dc.con_id
FROM degree de, degree_concentration
WHERE de.degree_id = ?
-- temp table temp4: course_id
SELECT co.course_id
FROM student st, student_section ss, section se, class cl
WHERE st.ssn = ? AND st.stu_id = ss.stu_id AND ss.section_id = se.section_id AND se.class_id = cl.class_id
-- temp table temp5: without next available time
SELECT cc.con_id, cc.course_id
FROM temp3, course_concentration cc
WHERE temp3.con_id = cc.con_id AND NOT EXISTS (
    SELECT *
    FROM temp4
    WHERE temp4.course_id = cc.course_id
)
ORDER BY cc.con_id

SELECT temp5.con_id, temp5.course_id, cl1.year, cl1.quarter
FROM temp5, class cl1, period pr1
WHERE temp5.couse_id = cl1.course_id AND cl1.quarter = pr1.quarter AND cl1.year = pr1.year
    AND NOT EXISTS (
        SELECT *
        FROM class cl2, period pr2
        WHERE cl2.course_id = cl1.course AND cl2.quarter = pr2.quarter AND cl2.year = pr2.year AND pr1.period_id > pr2.period_id
    )

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
-- ii
SELECT ss.grade, count(*)
FROM class cl, section se, student_section ss
WHERE cl.course_id = ? AND cl.year = ? AND cl.quarter = ? AND cl.class_id = se.class_id AND se.fac_id = ? AND se.section_id = ss.section_id AND ss.grade <> 'IN'
GROUP BY ss.grade

-- iii
SELECT ss.grade, count(*)
FROM class cl, section se, student_section ss
WHERE cl.course_id = ? AND cl.class_id = se.class_id AND se.fac_id = ? AND se.section_id = ss.section_id AND ss.grade <> 'IN'
GROUP BY ss.grade

-- iv
SELECT ss.grade, count(*)
FROM class cl, section se, student_section ss
WHERE cl.course_id = ? AND cl.class_id = se.class_id AND se.section_id = ss.section_id AND ss.grade <> 'IN'
GROUP BY ss.grade

-- v
SELECT SUM(con.grade_num) / count(*)
FROM class cl, section se, student_section ss, conversion con
WHERE cl.course_id = ? AND cl.class_id = se.class_id AND se.fac_id = ? AND se.section_id = ss.section_id AND ss.grade <> 'IN' AND ss.grade = con.grade_letter


