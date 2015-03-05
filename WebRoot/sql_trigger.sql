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