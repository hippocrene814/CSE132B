Part4
1. meeting_conflict
2. enrollment_limit
3. professor_conflict

Part5
1. precomputation
a.
-- create view
CREATE VIEW CPQG AS
SELECT cl.course_id, se.fac_id, cl.year, cl.quarter, substring(ss.grade from 1 for 1) AS grade, count(*) AS g_cnt
FROM class cl, section se, student_section ss
WHERE cl.class_id = se.class_id AND se.section_id = ss.section_id AND ss.grade <> 'f' AND ss.grade <> 'na'
GROUP BY cl.course_id, se.fac_id, cl.year, cl.quarter, substring(ss.grade from 1 for 1)

-- version 2
CREATE VIEW CPQG AS
SELECT cog.course_id, cog.year, cog.quarter, cog.fac_id, cog.grade, CASE WHEN grade_stat.g_cnt IS NULL THEN 0 ELSE grade_stat.g_cnt END
FROM (SELECT DISTINCT co.course_id, cl.year, cl.quarter, se.fac_id, ga.grade FROM course co, grade_abcd ga, class cl, section se WHERE cl.course_id = co.course_id AND se.class_id = cl.class_id) AS cog LEFT OUTER JOIN
    (SELECT res.course_id, res.year, res.quarter, res.fac_id, res.grade, CASE WHEN res.g_cnt IS NULL THEN 0 ELSE res.g_cnt END
    FROM (grade_abcd AS ga LEFT OUTER JOIN
            (SELECT cl.course_id, cl.year, cl.quarter, se.fac_id, substring(ss.grade from 1 for 1) AS gra, count(*) AS g_cnt
            FROM class cl, section se, student_section ss
            WHERE cl.class_id = se.class_id AND se.section_id = ss.section_id AND ss.grade <> 'f' AND ss.grade <> 'na'
            GROUP BY cl.course_id, cl.year, cl.quarter, se.fac_id, substring(ss.grade from 1 for 1)
            ) AS list ON ga.grade = list.gra
        ) AS res
    GROUP BY res.course_id, res.year, res.quarter, res.fac_id, res.grade, res.g_cnt
    ) AS grade_stat ON grade_stat.course_id = cog.course_id AND cog.grade = grade_stat.grade AND cog.year = grade_stat.year AND cog.quarter = grade_stat.quarter AND cog.fac_id = grade_stat.fac_id
ORDER BY cog.course_id, cog.year, cog.quarter, cog.fac_id

-- select result
SELECT c.grade, c.g_cnt
FROM CPQG AS c
WHERE c.course_id = ? AND c.fac_id = ? AND c.year = ? AND c.quarter = ?

b.
-- create view
CREATE VIEW CPG AS
SELECT CPQG.course_id, CPQG.fac_id, CPQG.grade, SUM(CPQG.g_cnt) AS g_cnt
FROM CPQG
GROUP BY CPQG.course_id, CPQG.fac_id, CPQG.grade

-- select result
SELECT c.grade, c.g_cnt
FROM CPG AS c
WHERE c.course_id = ? AND c.fac_id = ?

2. maintain_view_trigger
-- UPDATE EMPLOYEE
-- SET SALARY = SALARY *1.1
-- WHERE DNO IN
--   (SELECT DNUMBER
--      FROM DEPARTMENT
--      WHERE DNAME='Research')

-- update view after new row stu_section
-- trigger after
-- CPQG
UPDATE CPQG
SET g_cnt = g_cnt + 1
WHERE course_id = (
    SELECT cl.course_id
    FROM student_section ss, section se, class cl
    WHERE ss.stu_id = ? AND ss.section_id = ? AND ss.section_id = se.section_id AND se.class_id = cl.class_id AND cl.year = ? AND cl.quarter = ?
    ) AND grade = (
    SELECT substring(ss.grade from 1 for 1)
    FROM student_section ss, section se, class cl
    WHERE ss.stu_id = ? AND ss.section_id = ? AND ss.section_id = se.section_id AND se.class_id = cl.class_id AND cl.year = ? AND cl.quarter = ?
    )

-- CPG
UPDATE CPG
SET g_cnt = g_cnt + 1
WHERE course_id = (
    SELECT cl.course_id
    FROM student_section ss, section se, class cl
    WHERE ss.stu_id = ? AND ss.section_id = ? AND ss.section_id = se.section_id AND se.class_id = cl.class_id
    ) AND grade = (
    SELECT substring(ss.grade from 1 for 1)
    FROM student_section ss, section se, class cl
    WHERE ss.stu_id = ? AND ss.section_id = ? AND ss.section_id = se.section_id AND se.class_id = cl.class_id
    )





