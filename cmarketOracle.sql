-- 이미 만들어진 제약조건들을 한번에 삭제하는 법을 몰라서 코드를 정리하기 힘들다.
DROP TABLE user_tb;
select * from user_tb; 
CREATE TABLE user_tb
( 
    user_sq   NUMBER PRIMARY KEY,
    user_id   VARCHAR2(100) NOT NULL UNIQUE,
    user_pwd  VARCHAR2(60) NOT NULL,
    user_name VARCHAR2(100) NOT NULL,
    email     VARCHAR2(255) NOT NULL UNIQUE,
    phone     VARCHAR2(255) NOT NULL UNIQUE,
    address   VARCHAR2(255) NOT NULL, --나누지 말까
    sample4_postcode VARCHAR(25),
    sample4_roadAddress VARCHAR(100),
    sample4_jibunAddress VARCHAR(100),
    sample4_detailAddress VARCHAR(100),
    user_status VARCHAR2(1) DEFAULT 'Y' CHECK(user_status IN ('Y','N'))
); -- d

-- 시퀀스 생성
CREATE SEQUENCE user_seq --시퀀스이름 EX_SEQ
INCREMENT BY 1 --증감숫자 1
START WITH 1 --시작숫자 1
MINVALUE 1 --최소값 1
MAXVALUE 1000 --최대값 1000
NOCYCLE --순환하지않음
CACHE 10; --메모리에 시퀀스값 미리할당

-- 컬럼을 유니크로 수정할때 썼는데 
ALTER TABLE user_tb ADD CONSTRAINT user_id_uq UNIQUE(user_id);
ALTER TABLE user_tb ADD CONSTRAINT user_email_uq UNIQUE(email);
ALTER TABLE user_tb ADD CONSTRAINT user_phone_uq UNIQUE(phone);

DROP TABLE profile_tb;
select * from profile_tb;
CREATE TABLE profile_tb
( 
    profile_sq            NUMBER PRIMARY KEY,
    user_sq               NUMBER,
    profile_nickname      VARCHAR2(100) NOT NULL UNIQUE,
    profile_gender        VARCHAR2(1) NOT NULL CHECK(profile_gender IN ('M','F')),
    profile_photo         VARCHAR2(255) DEFAULT 'userImg.jpg',
    profile_temperature   NUMBER DEFAULT 36.5,
    profile_date          DATE DEFAULT SYSDATE,
    
    
    CONSTRAINT profile_gender_ck CHECK (profile_gender IN('M', 'F')),
    CONSTRAINT profile_fk FOREIGN KEY(user_sq)
    REFERENCES user_tb(user_sq)ON DELETE CASCADE
);
-- 시퀀스 추가
CREATE SEQUENCE profile_seq
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 1000
NOCYCLE
CACHE 10;

ALTER TABLE profile_tb ADD CONSTRAINT profile_nickname_uq UNIQUE(profile_nickname);
ALTER TABLE profile_tb ADD CONSTRAINT user_gender_ck CHECK(profile_gender IN ('M','F'));


DROP TABLE profile_comment;
select * from profile_comment;
CREATE TABLE profile_comment
( 
    comment_sq   NUMBER PRIMARY KEY,
    profile_sq   NUMBER,
    com_judge VARCHAR(1),
    com_writer   VARCHAR2(100) NOT NULL,
    com_writer_sq NUMBER,
    com_img      VARCHAR2(255) DEFAULT 'userImg.jpg',
    com_content  VARCHAR2(1000) NOT NULL,
    com_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    /*com_date VARCHAR2(100) DEFAULT TO_CHAR(SYSDATE,'YYYY-MM-DD HH:MI:SS'),*/
    /*com_date     DATE DEFAULT SYSDATE,*/
    CONSTRAINT comment_pro_fk FOREIGN KEY(profile_sq)
    REFERENCES profile_tb(profile_sq),
    CONSTRAINT comment_wri_fk FOREIGN KEY(com_writer)
    REFERENCES profile_tb(profile_nickname),
    CONSTRAINT comment_wriSq_fk FOREIGN KEY(com_writer_sq)
    REFERENCES profile_tb(profile_sq)
);

CREATE SEQUENCE profile_comment_seq
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 100000
NOCYCLE
NOCACHE;

insert into profile_comment values(1,1,'첫회원','searon.png','감사합니다',default);
insert into profile_comment values(2,1,'첫회원','20201124010957n.png','맛이 없어요',default);
insert into profile_comment values(3,1,'첫회원','uesrImg.jpg','나이스',default);
insert into profile_comment values(4,1,'첫회원','20201124010957n.png','좋아좋아',default);
insert into profile_comment values(5,1,'일등유저','20201124010957n.png','맛이 있어요',default);
insert into profile_comment values(6,1,'일등유저','uesrImg.jpg','나이스물여섯',default);
insert into profile_comment values(7,1,'이동네유저','20201124010957n.png','싫어',default);

ALTER TABLE profile_comment ADD com_judge VARCHAR(1);
select systimestamp from dual;
delete from profile_comment;
select * from profile_comment;
commit;

drop table profile_comment;

DROP TABLE follow_tb;
select * from follow_tb;
CREATE TABLE follow_tb
( 
    follower NUMBER,
    leader NUMBER,
    CONSTRAINT follower_fk FOREIGN KEY(follower)
    REFERENCES profile_tb(profile_sq),
    CONSTRAINT leader_fk FOREIGN KEY(leader)
    REFERENCES profile_tb(profile_sq),
    CONSTRAINT follow_pk PRIMARY KEY (follower,leader)
);


DROP TABLE block_tb;
desc block_tb;
CREATE TABLE block_tb
(
    blocker NUMBER,
    blocked NUMBER,
    CONSTRAINT blocker_fk FOREIGN KEY(blocker)
    REFERENCES profile_tb(profile_sq),
    CONSTRAINT blocked_fk FOREIGN KEY(blocked)
    REFERENCES profile_tb(profile_sq),
    CONSTRAINT block_pk PRIMARY KEY (blocker,blocked)
);

DROP TABLE category_tb;
select * from category_tb;
CREATE TABLE category_tb
(
    cate_sq NUMBER PRIMARY KEY,
    cate_name VARCHAR2(100) NOT NULL UNIQUE
);

INSERT INTO category_tb VALUES (1,'남성의류');

CREATE SEQUENCE category_tb_seq
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 100
NOCYCLE
NOCACHE;



SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'board_tb';
DROP TABLE board_tb;
select * from board_tb;
CREATE TABLE board_tb
(
    board_sq NUMBER PRIMARY KEY,
    board_writer VARCHAR2(100),
    board_category VARCHAR2(100),
    board_title VARCHAR2(255) NOT NULL,
    price NUMBER NOT NULL,
    board_img VARCHAR2(255) NOT NULL,
    board_dips_cnt NUMBER DEFAULT 0,
    board_chat_cnt NUMBER DEFAULT 0,
    board_views_cnt NUMBER DEFAULT 0,
    board_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    board_update_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT board_writer_fk FOREIGN KEY(board_writer)
    REFERENCES profile_tb(profile_nickname),
    CONSTRAINT board_category_fk FOREIGN KEY(board_category)
    REFERENCES category_tb(cate_name)
);
ALTER TABLE board_tb MODIFY board_date TIMESTAMP DEFAULT SYSTIMESTAMP;
ALTER TABLE board_tb ADD board_update_date TIMESTAMP DEFAULT SYSTIMESTAMP;
ALTER TABLE board_tb ADD board_address VARCHAR2(100);
ALTER TABLE board_tb ADD nego VARCHAR2(2) DEFAULT 'N';


INSERT INTO board_tb VALUES (1,'첫회원','남성의류','게시글 테스트.',70000,'Hyoshin.png',0,0,0,DEFAULT,DEFAULT,'관악구 신림동');
INSERT INTO board_tb VALUES (2,'첫회원','남성의류','게시글 테스트.',90000,'Hyoshin.png',0,0,0,DEFAULT,DEFAULT,'관악구 신림동');
INSERT INTO board_tb VALUES (3,'첫회원','남성의류','게시글 테스트.',48000,'note9.jpeg',0,0,0,DEFAULT,DEFAULT,'관악구 신림동');
INSERT INTO board_tb VALUES (4,'첫회원','남성의류','게시글 테스트.',60000,'samsungMonitor.jpeg',0,0,0,DEFAULT,DEFAULT,'관악구 신림동');
INSERT INTO board_tb VALUES (5,'첫회원','남성의류','게시글 테스트.',500,'Misaki.jpg',0,0,0,DEFAULT,DEFAULT,'관악구 신림동');
INSERT INTO board_tb VALUES (6,'일등유저','남성의류','게시글 테스트.',90000,'graphick.jpeg',0,0,0,DEFAULT,DEFAULT,'관악구 신림동');
select * from board_tb;
delete from board_tb where board_sq='6';
commit;

/*
주소는 키가 아니라서 참조 못함
ALTER TABLE board_tb ADD 
CONSTRAINT board_address_fk FOREIGN KEY(board_address) REFERENCES user_tb(sample4_jibunAddress);
*/

CREATE SEQUENCE board_tb_seq
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 1000000
NOCYCLE
NOCACHE;




DROP TABLE board_content_tb;
select * from board_content_tb;
CREATE TABLE board_content_tb
(
    board_content_sq NUMBER PRIMARY KEY,
    board_sq NUMBER,
    board_content VARCHAR2(4000) NOT NULL,
    CONSTRAINT board_content_fk FOREIGN KEY(board_sq)
    REFERENCES board_tb(board_sq)
);

CREATE SEQUENCE board_content_tb_seq
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 1000000
NOCYCLE
NOCACHE;

DROP TABLE dips_tb;
CREATE TABLE dips_tb
(
    board_sq NUMBER,
    profile_sq NUMBER,
    CONSTRAINT dips_board_fk FOREIGN KEY(board_sq)
    REFERENCES board_tb(board_sq),
    CONSTRAINT dips_profile_fk FOREIGN KEY(profile_sq)
    REFERENCES profile_tb(profile_sq),
    CONSTRAINT dips_pk PRIMARY KEY (board_sq,profile_sq)
);

DROP TABLE file_tb;
CREATE TABLE file_tb
(
    file_sq NUMBER PRIMARY KEY,
    board_content_sq NUMBER,
    file_name VARCHAR(255),
    file_org_name VARCHAR(255),
    file_size NUMBER,
    CONSTRAINT file_board_fk FOREIGN KEY(board_content_sq)
    REFERENCES board_tb(board_content_sq)
);

CREATE SEQUENCE file_tb_seq
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 1000000
NOCYCLE
NOCACHE;


DROP TABLE tag_tb;
CREATE TABLE tag_tb
(
    profile_sq NUMBER,
    tag_name VARCHAR2(20 char),
    CONSTRAINT tag_profile_fk FOREIGN KEY(profile_sq)
    REFERENCES profile_tb(profile_sq),
    CONSTRAINT tag_fk PRIMARY KEY (profile_sq,tag_name)
);

select * from user_tb;
SELECT * FROM USER_CONSTRAINTS;


INSERT INTO user_tb VALUES (user_seq.nextval,'test1','test1','김효민','gyals0386@gmail.com','01042340000','신림동');
INSERT INTO profile_tb VALUES (profile_seq.nextval,1,'마법의신효민','M',DEFAULT,36.5,DEFAULT);
INSERT INTO user_tb VALUES (user_seq.nextval,'test2','test2','김효민2','gyals0380@gmail.com','01042340001','신림동');
INSERT INTO profile_tb VALUES (profile_seq.nextval,2,'타락파워전사','M',DEFAULT,36.5,DEFAULT);
SELECT profile_SEQ.CURRVAL FROM DUAL;
rollback;
--DROP SEQUENCE profile_SEQ;
--DROP SEQUENCE user_SEQ;
--DELETE FROM user_tb;
--DELETE FROM profile_tb;
SELECT * FROM user_tb;
SELECT * FROM profile_tb;
SELECT * FROM USER_SEQUENCES;
SELECT * FROM profile_comment;

SELECT *
		FROM profile_comment
		WHERE profile_sq='1'
		ORDER
		BY com_date DESC;
commit;

select to_char(sysdate,'DD.MM.YYYY HH:MI:SS') from dual;