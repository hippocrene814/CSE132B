-- test
CREATE OR REPLACE FUNCTION emp_stamp() RETURNS trigger AS
$body$
    BEGIN
        IF NEW.research_name = 'good' THEN
            RAISE EXCEPTION 'research_name cannot be good';
        END IF;
        RETURN NEW;
    END;
$body$
LANGUAGE plpgsql;

CREATE TRIGGER ra_trigger
BEFORE INSERT OR UPDATE ON research_area
FOR EACH ROW
EXECUTE PROCEDURE emp_stamp();

DROP TRIGGER ra_trigger
ON research_area

PART4
1. meeting_conflict
-- when meeting update or insert: same day, time overlap
CREATE OR REPLACE FUNCTION check_meeting() RETURNS trigger AS
$body$
    BEGIN
        IF EXISTS (
            SELECT *
            FROM meeting m
            WHERE m.section_id = NEW.section_id AND m.meeting_id <> NEW.meeting_id AND CAST(m.start_time AS Time) < CAST(NEW.end_time AS Time) AND CAST(m.end_time AS Time) > CAST(NEW.start_time AS Time) AND m.day = NEW.day
            )
        THEN RAISE EXCEPTION 'Meeting Conflict';
        -- THEN RAISE EXCEPTION 'Error1: Meeting Conflict, with Section Id % .', NEW.section_id;
        END IF;
        RETURN NEW;
    END;
$body$
LANGUAGE plpgsql;

CREATE TRIGGER trg1
BEFORE INSERT OR UPDATE ON meeting
FOR EACH ROW
EXECUTE PROCEDURE check_meeting();

DROP TRIGGER trg1
ON meeting

2. enrollment_limit
-- when student_section insert, update: count(*) > limit
-- CREATE OR REPLACE FUNCTION check_ss() RETURNS trigger AS
-- $body$
--     BEGIN
--         IF EXISTS (
--         SELECT *
--         FROM section se
--         WHERE se.section_limit = (
--             SELECT count(*)
--             FROM student_section ss
--             WHERE NEW.section_id = se.section_id AND ss.section_id = se.section_id
--             )
--         )
--         THEN RAISE EXCEPTION 'Out of Limit! Fail to update/insert student section.';
--         END IF;
--         RETURN NEW;
--     END;
-- $body$
-- LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_ss() RETURNS trigger AS
$body$
    BEGIN
        IF ( TG_OP='UPDATE' ) THEN
            IF EXISTS (
            SELECT *
            FROM section se
            WHERE se.section_limit = (
                SELECT count(*)
                FROM student_section ss
                WHERE NEW.section_id = se.section_id AND ss.section_id = se.section_id
                ) AND NEW.section_id <> OLD.section_id
            )
            THEN RAISE EXCEPTION 'Out of Limit! Fail to update student section.';
            -- THEN RAISE EXCEPTION 'Error2: Out of Limit! Fail to update student section.';
            END IF;
        ELSE
            IF EXISTS (
            SELECT *
            FROM section se
            WHERE se.section_limit = (
                SELECT count(*)
                FROM student_section ss
                WHERE NEW.section_id = se.section_id AND ss.section_id = se.section_id
                )
            )
            THEN RAISE EXCEPTION 'Out of Limit! Fail to insert student section.';
            -- THEN RAISE EXCEPTION 'Error2: Out of Limit! Fail to insert student section.';
            END IF;
        END IF;
        RETURN NEW;
    END;
$body$
LANGUAGE plpgsql;

CREATE TRIGGER tgr2_1
BEFORE INSERT OR UPDATE ON student_section
FOR EACH ROW
EXECUTE PROCEDURE check_ss();

DROP TRIGGER tgr2_1
ON student_section

-- when limit update in section: limit < count(*)
-- and check delete in section (which is related to student_section)
CREATE OR REPLACE FUNCTION check_se() RETURNS trigger AS
$body$
    BEGIN
        IF ( TG_OP='UPDATE' ) THEN
            IF NEW.section_limit < (
                SELECT count(*)
                FROM student_section ss
                WHERE ss.section_id = NEW.section_id
            )
            THEN RAISE EXCEPTION 'Out of Limit! Fail to update section limit.';
            -- THEN RAISE EXCEPTION 'Error2: Out of Limit! Fail to update section limit.';
            END IF;
        ELSE
            IF EXISTS (
                SELECT *
                FROM student_section ss
                WHERE ss.section_id = OLD.section_id
            )
            THEN RAISE EXCEPTION 'Out of Limit! Fail to delete section because it is related to student.';
            -- THEN RAISE EXCEPTION 'Error2: Fail to delete section because it is related to student.';
            END IF;
        END IF;
        RETURN NEW;
    END;
$body$
LANGUAGE plpgsql;

CREATE TRIGGER tgr2_2
BEFORE UPDATE OR DELETE ON section
FOR EACH ROW
EXECUTE PROCEDURE check_se();

DROP TRIGGER tgr2_2
ON section

3. professor_conflict
-- update/insert section
CREATE OR REPLACE FUNCTION check_sm() RETURNS trigger AS
$body$
    BEGIN
        IF EXISTS (
            SELECT *
            FROM section o, meeting m1, meeting m2
            WHERE NEW.fac_id = o.fac_id AND NEW.section_id <> o.section_id AND m1.section_id = NEW.section_id AND m2.section_id = o.section_id
                AND CAST(m1.start_time AS Time) < CAST(m2.end_time AS Time) AND CAST(m1.end_time AS Time) > CAST(m2.start_time AS Time) AND m1.day = m2.day
        )
        THEN RAISE EXCEPTION 'Cannot update/insert section because of time of faculty conflict!';
        -- THEN RAISE EXCEPTION 'Error3: Cannot update/insert section because of time of faculty conflict!';
        END IF;
        RETURN NEW;
    END;
$body$
LANGUAGE plpgsql;

CREATE TRIGGER tgr3_1
BEFORE INSERT OR UPDATE ON section
FOR EACH ROW
EXECUTE PROCEDURE check_sm();

DROP TRIGGER tgr3_1
ON section

-- update/insert meeting
CREATE OR REPLACE FUNCTION check_ms() RETURNS trigger AS
$body$
    BEGIN
        IF EXISTS (
            SELECT *
            FROM meeting om, section s1, section s2
            WHERE s1.fac_id = s2.fac_id AND s1.section_id <> s2.section_id AND s1.section_id = NEW.section_id AND s2.section_id = om.section_id
                AND CAST(NEW.start_time AS Time) < CAST(om.end_time AS Time) AND CAST(NEW.end_time AS Time) > CAST(om.start_time AS Time) AND NEW.day = om.day
        )
        THEN RAISE EXCEPTION 'Cannot update/insert meeting because of time of faculty conflict!!';
        -- THEN RAISE EXCEPTION 'Error3: Cannot update/insert meeting because of time of faculty conflict!';
        END IF;
        RETURN NEW;
    END;
$body$
LANGUAGE plpgsql;

CREATE TRIGGER tgr3_2
BEFORE INSERT OR UPDATE ON meeting
FOR EACH ROW
EXECUTE PROCEDURE check_ms();

DROP TRIGGER tgr3_2
ON meeting

PART5
1. precomputation
a.
-- version 2
CREATE TABLE CPQG AS
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

DROP TABLE CPQG

b.
-- create view
CREATE TABLE CPG AS
SELECT CPQG.course_id, CPQG.fac_id, CPQG.grade, SUM(CPQG.g_cnt) AS g_cnt
FROM CPQG
GROUP BY CPQG.course_id, CPQG.fac_id, CPQG.grade

-- select result
SELECT c.grade, c.g_cnt
FROM CPG AS c
WHERE c.course_id = ? AND c.fac_id = ?

DROP TABLE CPG

2. maintain_view_trigger
-- update view after new row stu_section
-- cpqg
CREATE OR REPLACE FUNCTION update_cpqg() RETURNS trigger AS
$body$
    BEGIN
        -- IF NEW.grade <> 'f' AND NEW.grade <> 'na'
        -- THEN
            IF( TG_OP='DELETE' ) THEN
                UPDATE CPQG
                SET g_cnt = g_cnt - 1
                WHERE course_id IN (
                    SELECT cl.course_id
                    FROM section se, class cl
                    WHERE se.section_id = OLD.section_id AND se.class_id = cl.class_id
                    ) AND fac_id IN (
                    SELECT se.fac_id
                    FROM section se
                    WHERE se.section_id = OLD.section_id
                    ) AND grade = substring(OLD.grade from 1 for 1) AND year IN (
                    SELECT cl.year
                    FROM section se, class cl
                    WHERE se.section_id = OLD.section_id AND se.class_id = cl.class_id
                    ) AND quarter IN (
                    SELECT cl.quarter
                    FROM section se, class cl
                    WHERE se.section_id = OLD.section_id AND se.class_id = cl.class_id
                    );
                UPDATE CPG
                SET g_cnt = g_cnt - 1
                WHERE course_id IN (
                    SELECT cl.course_id
                    FROM section se, class cl
                    WHERE se.section_id = OLD.section_id AND se.class_id = cl.class_id
                    ) AND fac_id IN (
                    SELECT se.fac_id
                    FROM section se
                    WHERE se.section_id = OLD.section_id
                    ) AND grade = substring(OLD.grade from 1 for 1);
            ELSIF (TG_OP='INSERT') THEN
                UPDATE CPQG
                SET g_cnt = g_cnt + 1
                WHERE course_id IN (
                    SELECT cl.course_id
                    FROM section se, class cl
                    WHERE se.section_id = NEW.section_id AND se.class_id = cl.class_id
                    ) AND fac_id IN (
                    SELECT se.fac_id
                    FROM section se
                    WHERE se.section_id = NEW.section_id
                    ) AND grade = substring(NEW.grade from 1 for 1) AND year IN (
                    SELECT cl.year
                    FROM section se, class cl
                    WHERE se.section_id = NEW.section_id AND se.class_id = cl.class_id
                    ) AND quarter IN (
                    SELECT cl.quarter
                    FROM section se, class cl
                    WHERE se.section_id = NEW.section_id AND se.class_id = cl.class_id
                    );
                UPDATE CPG
                SET g_cnt = g_cnt + 1
                WHERE course_id IN (
                    SELECT cl.course_id
                    FROM section se, class cl
                    WHERE se.section_id = NEW.section_id AND se.class_id = cl.class_id
                    ) AND fac_id IN (
                    SELECT se.fac_id
                    FROM section se
                    WHERE se.section_id = NEW.section_id
                    ) AND grade = substring(NEW.grade from 1 for 1);
            ELSE
                UPDATE CPQG
                SET g_cnt = g_cnt + 1
                WHERE course_id IN (
                    SELECT cl.course_id
                    FROM section se, class cl
                    WHERE se.section_id = NEW.section_id AND se.class_id = cl.class_id
                    ) AND fac_id IN (
                    SELECT se.fac_id
                    FROM section se
                    WHERE se.section_id = NEW.section_id
                    ) AND grade = substring(NEW.grade from 1 for 1) AND year IN (
                    SELECT cl.year
                    FROM section se, class cl
                    WHERE se.section_id = NEW.section_id AND se.class_id = cl.class_id
                    ) AND quarter IN (
                    SELECT cl.quarter
                    FROM section se, class cl
                    WHERE se.section_id = NEW.section_id AND se.class_id = cl.class_id
                        );
                UPDATE CPQG
                SET g_cnt = g_cnt - 1
                WHERE course_id IN (
                    SELECT cl.course_id
                    FROM section se, class cl
                    WHERE se.section_id = OLD.section_id AND se.class_id = cl.class_id
                    ) AND fac_id IN (
                    SELECT se.fac_id
                    FROM section se
                    WHERE se.section_id = OLD.section_id
                    ) AND grade = substring(OLD.grade from 1 for 1) AND year IN (
                    SELECT cl.year
                    FROM section se, class cl
                    WHERE se.section_id = OLD.section_id AND se.class_id = cl.class_id
                    ) AND quarter IN (
                    SELECT cl.quarter
                    FROM section se, class cl
                    WHERE se.section_id = OLD.section_id AND se.class_id = cl.class_id
                    );
                UPDATE CPG
                SET g_cnt = g_cnt - 1
                WHERE course_id IN (
                    SELECT cl.course_id
                    FROM section se, class cl
                    WHERE se.section_id = OLD.section_id AND se.class_id = cl.class_id
                    ) AND fac_id IN (
                    SELECT se.fac_id
                    FROM section se
                    WHERE se.section_id = OLD.section_id
                    ) AND grade = substring(OLD.grade from 1 for 1);
                UPDATE CPG
                SET g_cnt = g_cnt + 1
                WHERE course_id IN (
                    SELECT cl.course_id
                    FROM section se, class cl
                    WHERE se.section_id = NEW.section_id AND se.class_id = cl.class_id
                    ) AND fac_id IN (
                    SELECT se.fac_id
                    FROM section se
                    WHERE se.section_id = NEW.section_id
                    ) AND grade = substring(NEW.grade from 1 for 1);
            END IF;
        -- END IF;
        RETURN NEW;
    END;
$body$
LANGUAGE plpgsql;

CREATE TRIGGER tgr4_1
AFTER INSERT OR UPDATE OR DELETE ON student_section
FOR EACH ROW
EXECUTE PROCEDURE update_cpqg();

DROP TRIGGER tgr4_1
ON student_section

