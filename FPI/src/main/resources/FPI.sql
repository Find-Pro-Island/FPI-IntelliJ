DROP SEQUENCE SEQ_BOARD;
DROP SEQUENCE SEQ_FILE;
DROP SEQUENCE SEQ_USER;
DROP SEQUENCE SEQ_COMMENT;
DROP TABLE TBL_USERS CASCADE CONSTRAINTS;
DROP TABLE TBL_BOARD CASCADE CONSTRAINTS;
DROP TABLE TBL_FILE;
DROP TABLE TBL_COMMENT;





CREATE TABLE TBL_USER(
             USER_ID VARCHAR2(255) PRIMARY KEY,
             PROVIDER VARCHAR2(100),
             USER_NAME VARCHAR2(100),
             PHONE_NUMBER VARCHAR2(50),
             USER_IMG VARCHAR2(255),
             EMAIL VARCHAR2(100),
             USER_CASH NUMBER,
             USER_PRO_APPROVAL VARCHAR2(5) DEFAULT 'NO'
                 CHECK(USER_PRO_APPROVAL IN ('NO', 'YES')),
             USER_STAR_RATE NUMBER,
             ROLE VARCHAR2(10),
             LOCATION_ID NUMBER,
             CONSTRAINT FK_USER_LOCATION_ID FOREIGN KEY (LOCATION_ID)
                 REFERENCES TBL_LOCATION (LOCATION_ID) ON DELETE CASCADE
);


CREATE TABLE TBL_PRO(
            PRO_ID NUMBER PRIMARY KEY,
            PRO_NAME VARCHAR2(100) NOT NULL,
            PHONE_NUMBER VARCHAR2(50),
            PRO_IMG VARCHAR2(255),
            PRO_STAR_RATE NUMBER,
            EMP_CNT NUMBER DEFAULT 0,
            LOCATION_ID NUMBER NOT NULL,
            USER_ID VARCHAR2(255),
            CONSTRAINT FK_PRO_USER_ID FOREIGN KEY (USER_ID)
                REFERENCES TBL_USER (USER_ID) ON DELETE CASCADE,
            CONSTRAINT FK_PRO_LOCATION_ID FOREIGN KEY (LOCATION_ID)
                REFERENCES TBL_LOCATION (LOCATION_ID) ON DELETE CASCADE
);



CREATE TABLE TBL_LOCATION(
             LOCATION_ID NUMBER PRIMARY KEY,
             REGION VARCHAR2(50) NOT NULL,
             CITY VARCHAR2(50) NOT NULL
);

-- 전문가 자격증번호,발급기관
CREATE TABLE TBL_CARDINFO(
             CARDINFO_ID NUMBER PRIMARY KEY,
             CERTI_ORGAN VARCHAR2(255) NOT NULL,
             CERTI_NUM VARCHAR2(255) NOT NULL,
             PRO_ID NUMBER NOT NULL,
             CONSTRAINT FK_PROCARD FOREIGN KEY (PRO_ID)
                 REFERENCES TBL_PRO (PRO_ID) ON DELETE CASCADE
);

-- 전문가 경력/수상내용
CREATE TABLE TBL_CAREERINFO(
           CAREERINFO_ID NUMBER PRIMARY KEY,
           AWARD VARCHAR2(1000) NOT NULL,
           PRO_ID NUMBER NOT NULL,
           CONSTRAINT FK_PROCAREER FOREIGN KEY (PRO_ID)
               REFERENCES TBL_PRO (PRO_ID) ON DELETE CASCADE
);

CREATE TABLE TBL_CATEGORY(
         CATEGORY_ID NUMBER PRIMARY KEY,
         CATEGORY_NAME VARCHAR2(50) NOT NULL
);

CREATE TABLE TBL_CATEGORY_LIST(
          CATEGORY_LIST_ID NUMBER PRIMARY KEY,
          CATEGORY_ID NUMBER NOT NULL,
          USER_ID VARCHAR2(255),
          PRO_ID NUMBER,
          CONSTRAINT FK_CATEGORY FOREIGN KEY (CATEGORY_ID)
              REFERENCES TBL_CATEGORY (CATEGORY_ID) ON DELETE CASCADE,
          CONSTRAINT FK_CATEGORY_USER_ID FOREIGN KEY (USER_ID)
              REFERENCES TBL_USER (USER_ID) ON DELETE CASCADE,
          CONSTRAINT FK_CATEGORY_PRO_ID FOREIGN KEY (PRO_ID)
              REFERENCES TBL_PRO (PRO_ID) ON DELETE CASCADE
);

CREATE TABLE TBL_SERVICE(
        SERVICE_ID NUMBER PRIMARY KEY,
        SERVICE_NAME VARCHAR2(50) NOT NULL,
        CATEGORY_ID NUMBER NOT NULL,
        CONSTRAINT FK_SERVICE_CATEGORY_ID FOREIGN KEY (CATEGORY_ID)
            REFERENCES TBL_CATEGORY (CATEGORY_ID) ON DELETE CASCADE
);

-- 유저가 받은 신고, 전문가가 유저 신고함
CREATE TABLE TBL_USER_ACCUSE(
        USER_ACCUSE_ID NUMBER PRIMARY KEY,
        USER_ACCUSE_CONTENT VARCHAR2(1000) NOT NULL,
        USER_ID VARCHAR2(255) NOT NULL,
        PRO_ID NUMBER NOT NULL,
        CONSTRAINT FK_USER_ACCUSE_USER_ID FOREIGN KEY (USER_ID)
            REFERENCES TBL_USER (USER_ID) ON DELETE CASCADE,
        CONSTRAINT FK_USER_ACCUSE_PRO_ID FOREIGN KEY (PRO_ID)
            REFERENCES TBL_PRO (PRO_ID) ON DELETE CASCADE
);

-- 전문가가 받은 신고, 유저가 전문가 신고함
CREATE TABLE TBL_PRO_ACCUSE(
       USER_ACCUSE_ID NUMBER PRIMARY KEY,
       USER_ACCUSE_CONTENT VARCHAR2(1000) NOT NULL,
       USER_ID VARCHAR2(255) NOT NULL,
       PRO_ID NUMBER NOT NULL,
       CONSTRAINT FK_PRO_ACCUSE_USER_ID FOREIGN KEY (USER_ID)
           REFERENCES TBL_USER (USER_ID) ON DELETE CASCADE,
       CONSTRAINT FK_PRO_ACCUSE_PRO_ID FOREIGN KEY (PRO_ID)
           REFERENCES TBL_PRO (PRO_ID) ON DELETE CASCADE
);

CREATE TABLE TBL_NOTI(
     NOTI_ID NUMBER PRIMARY KEY,
     NOTI_TITLE VARCHAR2(255) NOT NULL,
     NOTI_CONTENT VARCHAR2(4000) NOT NULL,
     NOTI_REGISTER_DATE DATE DEFAULT SYSDATE,
     NOTI_UPDATE_DATE DATE DEFAULT SYSDATE
);

CREATE TABLE TBL_FAQ(
    FAQ_ID NUMBER PRIMARY KEY,
    FAQ_TITLE VARCHAR2(255) NOT NULL,
    FAQ_CONTENT VARCHAR2(4000) NOT NULL,
    FAQ_REGISTER_DATE DATE DEFAULT SYSDATE,
    FAQ_UPDATE_DATE DATE DEFAULT SYSDATE
);

-- 회원이 올린 견적요청글
CREATE TABLE TBL_USER_UPLOAD(
    USER_UPLOAD_ID NUMBER PRIMARY KEY,
    USER_UPLOAD_TITLE VARCHAR2(100) NOT NULL,
    USER_UPLOAD_CONTENT VARCHAR2(1000) NOT NULL,
    USER_UPLOAD_PAY NUMBER NOT NULL,
    USER_UPLOAD_PAY_RANGE NUMBER NOT NULL,
    USER_UPLOAD_DATE DATE DEFAULT SYSDATE,
    USER_UPLOAD_ADDRESS VARCHAR2(1000),
    USER_ID VARCHAR2(255),
    SERVICE_ID NUMBER,
    CONSTRAINT FK_USER_UPLOAD FOREIGN KEY (USER_ID)
        REFERENCES TBL_USER (USER_ID) ON DELETE CASCADE,
    CONSTRAINT FK_USER_UPLOAD_SERVICE FOREIGN KEY (SERVICE_ID)
        REFERENCES TBL_SERVICE (SERVICE_ID) ON DELETE CASCADE
);

-- 전문가가 올린 서비스 제공 글
CREATE TABLE TBL_PRO_UPLOAD(
   PRO_UPLOAD_ID NUMBER PRIMARY KEY,
   PRO_UPLOAD_TITLE VARCHAR2(100) NOT NULL,
   PRO_UPLOAD_CONTENT VARCHAR2(1000) NOT NULL,
   PRO_UPLOAD_PAY NUMBER NOT NULL,
   PRO_UPLOAD_PAY_RANGE NUMBER NOT NULL,
   PRO_UPLOAD_DATE DATE DEFAULT SYSDATE,
   PRO_UPLOAD_ADDRESS VARCHAR2(1000),
   PRO_ID NUMBER,
   SERVICE_ID NUMBER,
   CONSTRAINT FK_PRO_UPLOAD FOREIGN KEY (PRO_ID)
       REFERENCES TBL_PRO (PRO_ID) ON DELETE CASCADE,
   CONSTRAINT FK_PRO_UPLOAD_SERVICE FOREIGN KEY (SERVICE_ID)
       REFERENCES TBL_SERVICE (SERVICE_ID) ON DELETE CASCADE
);

-- 글을 보고 유저가 보낸 요청
CREATE TABLE TBL_USER_REQUEST(
         USER_REQUEST_ID NUMBER PRIMARY KEY,
         USER_REQUEST_PAY NUMBER NOT NULL,
         USER_REQUEST_CONTENT VARCHAR2(1000) NOT NULL,
         USER_REQUEST_DATE DATE DEFAULT SYSDATE,
         USER_REQUEST_PROGRESS VARCHAR2(10) DEFAULT 'PRE' NOT NULL
             CHECK (USER_REQUEST_PROGRESS IN ('PRE', 'ING', 'POST')),
         USER_ID VARCHAR2(255),
         PRO_UPLOAD_ID NUMBER,
         CONSTRAINT FK_USER_REQ_USER FOREIGN KEY (USER_ID)
             REFERENCES TBL_USER (USER_ID) ON DELETE CASCADE,
         CONSTRAINT FK_USER_REQ_PRO_UP FOREIGN KEY (PRO_UPLOAD_ID)
             REFERENCES TBL_PRO_UPLOAD (PRO_UPLOAD_ID) ON DELETE CASCADE
);

-- 글을 보고 전문가가 보낸 요청
CREATE TABLE TBL_PRO_REQUEST(
        PRO_REQUEST_ID NUMBER PRIMARY KEY,
        PRO_REQUEST_PAY NUMBER NOT NULL,
        PRO_REQUEST_CONTENT VARCHAR2(1000) NOT NULL,
        PRO_REQUEST_DATE DATE DEFAULT SYSDATE,
        PRO_REQUEST_PROGRESS VARCHAR2(10) DEFAULT 'PRE' NOT NULL
            CHECK (PRO_REQUEST_PROGRESS IN ('PRE', 'ING', 'POST')),
        PRO_ID NUMBER,
        USER_UPLOAD_ID NUMBER,
        CONSTRAINT FK_PRO_REQ_PRO FOREIGN KEY (PRO_ID)
            REFERENCES TBL_PRO (PRO_ID) ON DELETE CASCADE,
        CONSTRAINT FK_PRO_REQ_USER_UP FOREIGN KEY (USER_UPLOAD_ID)
            REFERENCES TBL_USER_UPLOAD (USER_UPLOAD_ID) ON DELETE CASCADE
);

-- 프로가 받는 리뷰(PRO_REVIEW_POINT 이건 회원이 받게되는 포인트)
CREATE TABLE TBL_PRO_REVIEW(
       PRO_REVIEW_ID NUMBER PRIMARY KEY,
       PRO_REVIEW_TITLE VARCHAR2(100) NOT NULL,
       PRO_REVIEW_CONTENT VARCHAR2(1000) NOT NULL,
       PRO_REVIEW_RATE NUMBER,
       PRO_REVIEW_POINT NUMBER,
       PRO_REVIEW_DATE DATE DEFAULT SYSDATE,
       USER_ID VARCHAR2(255) NOT NULL,
       PRO_ID NUMBER NOT NULL,
       CONSTRAINT FK_PRO_REVIEW_USER FOREIGN KEY (USER_ID)
           REFERENCES TBL_USER (USER_ID) ON DELETE CASCADE,
       CONSTRAINT FK_PRO_REVIEW_PRO FOREIGN KEY (PRO_ID)
           REFERENCES TBL_PRO (PRO_ID) ON DELETE CASCADE
);


-- 회원이 받는 리뷰(USER_REVIEW_POINT 이건 회원이 받게되는 포인트)
CREATE TABLE TBL_USER_REVIEW(
        USER_REVIEW_ID NUMBER PRIMARY KEY,
        USER_REVIEW_TITLE VARCHAR2(100) NOT NULL,
        USER_REVIEW_CONTENT VARCHAR2(1000) NOT NULL,
        USER_REVIEW_RATE NUMBER,
        USER_REVIEW_POINT NUMBER,
        USER_REVIEW_DATE DATE DEFAULT SYSDATE,
        USER_ID VARCHAR2(255) NOT NULL,
        PRO_ID NUMBER NOT NULL,
        CONSTRAINT FK_USER_REVIEW_USER FOREIGN KEY (USER_ID)
            REFERENCES TBL_USER (USER_ID) ON DELETE CASCADE,
        CONSTRAINT FK_USER_REVIEW_PRO FOREIGN KEY (PRO_ID)
            REFERENCES TBL_PRO (PRO_ID) ON DELETE CASCADE
);

CREATE TABLE TBL_COMMUNITY(
      COMMUNITY_ID NUMBER PRIMARY KEY,
      SUBJECT VARCHAR2(50) NOT NULL,
      COMMUNITY_TITLE VARCHAR2(255) NOT NULL,
      COMMUNITY_CONTENT VARCHAR2(1000) NOT NULL,
      COMMUNITY_REGISTER_DATE DATE DEFAULT SYSDATE,
      COMMUNITY_UPDATE_DATE DATE DEFAULT SYSDATE,
      USER_ID VARCHAR2(255) NOT NULL,
      COMMUNITY_THUMBNAIL Varchar2(1000),
      CONSTRAINT FK_COMMUNITY FOREIGN KEY (USER_ID)
          REFERENCES TBL_USER (USER_ID) ON DELETE CASCADE
);

CREATE TABLE TBL_COMMENT(
        COMMENT_ID NUMBER PRIMARY KEY,
        COMMENT_CONTENT VARCHAR2(1000) NOT NULL,
        COMMENT_REGISTER_DATE DATE DEFAULT SYSDATE,
        COMMENT_UPDATE_DATE DATE DEFAULT SYSDATE,
        USER_ID VARCHAR2(255) NOT NULL,
        COMMUNITY_ID NUMBER NOT NULL,
        CONSTRAINT FK_COMMENT_USER FOREIGN KEY (USER_ID)
            REFERENCES TBL_USER (USER_ID) ON DELETE CASCADE,
        CONSTRAINT FK_COMMENT_COMMU FOREIGN KEY (COMMUNITY_ID)
            REFERENCES TBL_COMMUNITY (COMMUNITY_ID) ON DELETE CASCADE
);

CREATE TABLE TBL_LIKE(
     LIKE_ID NUMBER,
     USER_ID VARCHAR2(255) NOT NULL,
     COMMUNITY_ID NUMBER NOT NULL,
     CONSTRAINT FK_LIKE_USER FOREIGN KEY (USER_ID)
         REFERENCES TBL_USER (USER_ID) ON DELETE CASCADE,
     CONSTRAINT FK_LIKE_COMMU FOREIGN KEY (COMMUNITY_ID)
         REFERENCES TBL_COMMUNITY (COMMUNITY_ID) ON DELETE CASCADE
);

-- CREATE TABLE TBL_COMMUNITY_FILE(
--    COMMUNITY_FILE_ID NUMBER PRIMARY KEY,
--    COMMUNITY_FILE_ROUTE VARCHAR2(1000),
--    COMMUNITY_FILE_ORIGINAL VARCHAR2(1000),
--    COMMUNITY_FILE_SAVED VARCHAR2(1000),
--    COMMUNITY_ID NUMBER NOT NULL,
--    CONSTRAINT FK_COMMUNITY_FILE FOREIGN KEY (COMMUNITY_ID)
--        REFERENCES TBL_COMMUNITY (COMMUNITY_ID) ON DELETE CASCADE
-- );

CREATE TABLE TBL_PRO_UPLOAD_FILE(
    PRO_UPLOAD_FILE_ID NUMBER PRIMARY KEY,
    PRO_UPLOAD_FILE_ROUTE VARCHAR2(1000),
    PRO_UPLOAD_FILE_ORIGINAL VARCHAR2(1000),
    PRO_UPLOAD_FILE_SAVED VARCHAR2(1000),
    PRO_UPLOAD_ID NUMBER NOT NULL,
    CONSTRAINT FK_PRO_UPLOAD_FILE FOREIGN KEY (PRO_UPLOAD_ID)
        REFERENCES TBL_PRO_UPLOAD (PRO_UPLOAD_ID) ON DELETE CASCADE
);

CREATE TABLE TBL_USER_UPLOAD_FILE(
     USER_UPLOAD_FILE_ID NUMBER PRIMARY KEY,
     USER_UPLOAD_FILE_ROUTE VARCHAR2(1000),
     USER_UPLOAD_FILE_ORIGINAL VARCHAR2(1000),
     USER_UPLOAD_ID NUMBER NOT NULL,
     CONSTRAINT FK_USER_UPLOAD_FILE FOREIGN KEY (USER_UPLOAD_ID)
         REFERENCES TBL_USER_UPLOAD (USER_UPLOAD_ID) ON DELETE CASCADE
);

CREATE TABLE TBL_CARDINFO_FILE(
      CARDINFO_FILE_ID NUMBER PRIMARY KEY,
      CARDINFO_FILE_ROUTE VARCHAR2(1000),
      CARDINFO_FILE_ORIGINAL VARCHAR2(1000),
      PRO_ID NUMBER NOT NULL,
      CONSTRAINT FK_CARDINFO_FILE FOREIGN KEY (PRO_ID)
          REFERENCES TBL_PRO (PRO_ID) ON DELETE CASCADE
);


CREATE TABLE TBL_COUPON(
       COUPON_ID NUMBER PRIMARY KEY,
       COUPON_NUM VARCHAR2(255) NOT NULL,
       COUPON_VAL_DATE DATE NOT NULL,
       STATE CHAR(10) DEFAULT 'NO' NOT NULL
           CHECK (STATE IN ('YES', 'NO')),
       DISCOUNT NUMBER NOT NULL,
       USER_ID VARCHAR2(255) NOT NULL,
       CONSTRAINT FK_COUPON FOREIGN KEY (USER_ID)
           REFERENCES TBL_USER (USER_ID) ON DELETE CASCADE
);

CREATE SEQUENCE SEQ_USER
    START WITH 1
    INCREMENT BY 1
    NOCACHE;


CREATE SEQUENCE SEQ_PRO
    START WITH 1
    INCREMENT BY 1
    NOCACHE;


CREATE SEQUENCE SEQ_LOCATION
    START WITH 1
    INCREMENT BY 1
    NOCACHE;


CREATE SEQUENCE SEQ_INFO
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
-- PRO_CARD & PRO_CAREER 같이 쓰기


CREATE SEQUENCE SEQ_CATEGORY
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE SEQUENCE SEQ_CATEGORY_LIST
    START WITH 1
    INCREMENT BY 1
    NOCACHE;


CREATE SEQUENCE SEQ_SERVICE
    START WITH 1
    INCREMENT BY 1
    NOCACHE;


CREATE SEQUENCE SEQ_ACCUSE
    START WITH 1
    INCREMENT BY 1
    NOCACHE;


CREATE SEQUENCE SEQ_ADMIN
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
-- NOTI & FAQ


CREATE SEQUENCE SEQ_UPLOAD
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
-- USER_UPLOAD & PRO_UPLOAD 같이 쓰기


CREATE SEQUENCE SEQ_REQUEST
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
-- USER_REQUEST & PRO_REQUEST 같이 쓰기


CREATE SEQUENCE SEQ_REVIEW
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
-- USER_REVIEW & PRO_REVIEW 같이 쓰기


CREATE SEQUENCE SEQ_COMMUNITY
    START WITH 1
    INCREMENT BY 1
    NOCACHE;


CREATE SEQUENCE SEQ_COMMENT
    START WITH 1
    INCREMENT BY 1
    NOCACHE;


CREATE SEQUENCE SEQ_LIKE
    START WITH 1
    INCREMENT BY 1
    NOCACHE;


CREATE SEQUENCE SEQ_FILE
    START WITH 1
    INCREMENT BY 1
    NOCACHE;
-- FILE 4개 테이블 같이 쓰기


CREATE SEQUENCE SEQ_COUPON
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

DROP TABLE TBL_USER;
DROP TABLE TBL_PRO;
DROP TABLE TBL_LOCATION;
DROP TABLE TBL_CARDINFO;
DROP TABLE TBL_CAREERINFO;
DROP TABLE TBL_CATEGORY;
DROP TABLE TBL_CATEGORY_LIST;
DROP TABLE TBL_SERVICE;
DROP TABLE TBL_USER_ACCUSE;
DROP TABLE TBL_PRO_ACCUSE;
DROP TABLE TBL_FAQ;
DROP TABLE TBL_NOTI;
DROP TABLE TBL_USER_UPLOAD;
DROP TABLE TBL_PRO_UPLOAD;
DROP TABLE TBL_USER_REQUEST;
DROP TABLE TBL_PRO_REQUEST;
DROP TABLE TBL_PRO_REVIEW;
DROP TABLE TBL_USER_REVIEW;
DROP TABLE TBL_COMMUNITY;
DROP TABLE TBL_COMMENT;
DROP TABLE TBL_LIKE;
DROP TABLE TBL_PRO_UPLOAD_FILE;
DROP TABLE TBL_USER_UPLOAD_FILE;
DROP TABLE TBL_CARDINFO_FILE;
DROP TABLE TBL_COUPON;

DROP SEQUENCE SEQ_USER;
DROP SEQUENCE SEQ_PRO;
DROP SEQUENCE SEQ_LOCATION;
DROP SEQUENCE SEQ_INFO;
DROP SEQUENCE SEQ_CATEGORY;
DROP SEQUENCE SEQ_CATEGORY_LIST;
DROP SEQUENCE SEQ_SERVICE;
DROP SEQUENCE SEQ_ADMIN;
DROP SEQUENCE SEQ_ACCUSE;
DROP SEQUENCE SEQ_UPLOAD;
DROP SEQUENCE SEQ_REQUEST;
DROP SEQUENCE SEQ_REVIEW;
DROP SEQUENCE SEQ_COMMUNITY;
DROP SEQUENCE SEQ_COMMENT;
DROP SEQUENCE SEQ_LIKE;
DROP SEQUENCE SEQ_FILE;
DROP SEQUENCE SEQ_COUPON;

-- drop table

delete from tbl_user
where user_id='3614057925' and user_name = '민정';
SELECT p1.*, c.category_name
FROM (SELECT p.pro_id, p.pro_name, p.phone_number, p.pro_img, p.emp_cnt,u.email, u.user_cash, p.pro_star_rate, l.region, l.city, cl.category_id
      FROM tbl_pro p
               JOIN tbl_location l ON p.location_id = l.location_id
               JOIN tbl_category_list cl ON p.pro_id = cl.pro_id
               JOIN tbl_user u ON p.user_id = u.user_id
     ) p1
         JOIN tbl_category c ON p1.category_id = c.category_id
WHERE p1.pro_id = 1;
--
-- select pro.*,files.CARDINFO_FILE_ORIGINAL,files.CARDINFO_FILE_ROUTE,files.CARDINFO_FILE_SAVED
-- from(select p.PRO_ID,p.PRO_NAME,p.PHONE_NUMBER,p.PRO_IMG,p.LOCATION_ID,p.USER_ID,card.CARDINFO_ID,card.CERTI_NUM,card.CERTI_ORGAN,career.AWARD,category.CATEGORY_ID
--      from tbl_pro p
--               join TBL_CARDINFO card on p.PRO_ID=card.PRO_ID
--               join TBL_CAREERINFO career on p.PRO_ID = career.PRO_ID
--               join TBL_CATEGORY_LIST category on p.PRO_ID = category.PRO_ID )pro
--         join TBL_CARDINFO_FILE files
--              on pro.CARDINFO_ID =files.CARDINFO_ID
-- where pro.USER_ID = 1;



-- 현제 test 했던 공간

SELECT *
FROM (
         SELECT ROWNUM AS RN, request.*
         FROM (
                  SELECT PRO_REQUEST_ID, PRO_REQUEST_PAY, PRO_REQUEST_DATE , PRO_REQUEST_PROGRESS, NVL(PR.PRO_STAR_RATE, '0') AS pro_Star_Rate, PR.PRO_NAME, PR.EMP_CNT, TBL_USER_UPLOAD.USER_UPLOAD_TITLE
                  FROM TBL_PRO_REQUEST
                           INNER JOIN TBL_USER_UPLOAD
                                      ON TBL_PRO_REQUEST.USER_UPLOAD_ID = TBL_USER_UPLOAD.USER_UPLOAD_ID
                           INNER JOIN TBL_PRO pr
                                      ON TBL_PRO_REQUEST.PRO_ID = PR.PRO_ID
                  WHERE TBL_USER_UPLOAD.USER_ID = '3619331702'
                  ORDER BY
                      PRO_REQUEST_DATE DESC
              ) request
         WHERE rownum <= 6
     )
WHERE rn > 0;

insert into TBL_CAREERINFO (CAREERINFO_ID, AWARD, PRO_ID)
values (SEQ_PRO_INFO.nextval, '대회에서 우승한 경력4', 3);

select tpc.PRO_ID, tpc.AWARD, tpc.CAREERINFO_ID
from TBL_CAREERINFO TPC
         inner join TBL_PRO_REQUEST TPR
                    on tpr.PRO_ID = TPc.PRO_ID
where tpr.PRO_REQUEST_ID = 14;

insert into TBL_USER_REQUEST (USER_REQUEST_ID, USER_REQUEST_PAY, USER_REQUEST_CONTENT, USER_REQUEST_DATE,
                              USER_REQUEST_PROGRESS, USER_ID, PRO_UPLOAD_ID)
values (SEQ_REQUEST.nextval, 10000, '이렇게 해주세요7!!', sysdate, 'PRE', 3619331702, 4);

SELECT PRO_REQUEST_ID, PRO_REQUEST_PAY, PRO_REQUEST_DATE , PRO_REQUEST_PROGRESS,NVL(UR.USER_STAR_RATE, 0), UR.USER_NAME, TBL_USER_UPLOAD.USER_UPLOAD_TITLE
FROM TBL_PRO_REQUEST
         INNER JOIN TBL_USER_UPLOAD
                    ON TBL_PRO_REQUEST.USER_UPLOAD_ID = TBL_USER_UPLOAD.USER_UPLOAD_ID
         INNER JOIN TBL_USER UR
                    ON TBL_USER_UPLOAD.USER_ID = UR.USER_ID
WHERE TBL_PRO_REQUEST.PRO_ID = 3;
SELECT USER_REQUEST_ID, USER_REQUEST_PAY, USER_REQUEST_DATE , USER_REQUEST_PROGRESS,NVL(UR.USER_STAR_RATE, 0), UR.USER_NAME, TBL_PRO_UPLOAD.PRO_UPLOAD_TITLE
FROM TBL_USER_REQUEST
         INNER JOIN TBL_PRO_UPLOAD
                    ON TBL_USER_REQUEST.PRO_UPLOAD_ID = TBL_PRO_UPLOAD.PRO_UPLOAD_ID
         INNER JOIN TBL_USER UR
                    ON TBL_USER_REQUEST.USER_ID = UR.USER_ID
WHERE TBL_PRO_UPLOAD.PRO_ID = 3;

SELECT USER_REQUEST_ID, USER_REQUEST_PAY, USER_REQUEST_DATE , USER_REQUEST_PROGRESS,NVL(UR.USER_STAR_RATE, 0), UR.USER_NAME, TBL_PRO_UPLOAD.PRO_UPLOAD_TITLE
FROM TBL_USER_REQUEST
         INNER JOIN TBL_PRO_UPLOAD
                    ON TBL_USER_REQUEST.PRO_UPLOAD_ID = TBL_PRO_UPLOAD.PRO_UPLOAD_ID
         INNER JOIN TBL_USER UR
                    ON TBL_USER_REQUEST.USER_ID = UR.USER_ID
WHERE TBL_PRO_UPLOAD.PRO_ID = 3;

select TPU.PRO_UPLOAD_ID, TPU.PRO_ID, tpu.PRO_UPLOAD_TITLE, tpu.PRO_UPLOAD_DATE, tp.PRO_STAR_RATE, tp.PRO_NAME
from TBL_PRO_UPLOAD TPU
         inner join TBL_PRO TP
                    on TPU.PRO_ID = TP.PRO_ID
ORDER BY
    PRO_UPLOAD_DATE DESC;

alter table TBL_PRO
    add PHONE_NUMBER VARCHAR2(50);


insert into TBL_PRO_UPLOAD (PRO_UPLOAD_ID, PRO_UPLOAD_TITLE, PRO_UPLOAD_CONTENT, PRO_UPLOAD_PAY, PRO_UPLOAD_PAY_RANGE,
                            PRO_UPLOAD_DATE, PRO_ID, SERVICE_ID)
values (SEQ_UPLOAD.nextval, '요렇게도 한번 해봐요 우리', 'ㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹ', 20000, 5000, sysdate,4,24);
insert into TBL_PRO_UPLOAD (PRO_UPLOAD_ID, PRO_UPLOAD_TITLE, PRO_UPLOAD_CONTENT, PRO_UPLOAD_PAY, PRO_UPLOAD_PAY_RANGE,
                            PRO_UPLOAD_DATE, PRO_ID, SERVICE_ID)
values (SEQ_UPLOAD.nextval, '여기 여행지도 좋아요요!!!', 'ㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹㄹ', 20000, 5000, sysdate,3,34);

insert into TBL_PRO (PRO_ID, PRO_NAME, PRO_STAR_RATE, EMP_CNT, LOCATION_ID, USER_ID)
values (SEQ_PRO.nextval, '주주클럽',4.5,10,2,3619331702);

select TUU.USER_UPLOAD_ID, TUU.USER_ID, TUU.USER_UPLOAD_TITLE, TUU.USER_UPLOAD_DATE, TU.USER_STAR_RATE, TU.USER_NAME, ts.SERVICE_NAME
from TBL_USER_UPLOAD TUU
         inner join TBL_USER TU
                    on TUU.USER_ID = TU.USER_ID
         inner join TBL_SERVICE TS
                    on tuu.SERVICE_ID = ts.SERVICE_ID
ORDER BY
    USER_UPLOAD_DATE DESC;

SELECT TUU.USER_UPLOAD_ID, TUU.USER_UPLOAD_DATE, TC.CATEGORY_NAME
     , TS.SERVICE_NAME, TL.REGION, TL.CITY, TUU.USER_UPLOAD_CONTENT
     ,TU.USER_STAR_RATE, TUU.USER_UPLOAD_ADDRESS,TUU.USER_UPLOAD_PAY_RANGE
     ,TU.USER_NAME, TU.USER_ID,TUU.USER_UPLOAD_TITLE, TUU.USER_UPLOAD_PAY
FROM TBL_USER_UPLOAD TUU
         INNER JOIN TBL_SERVICE ts
                    ON TUU.SERVICE_ID = TS.SERVICE_ID
         INNER JOIN TBL_CATEGORY tc
                    ON TS.CATEGORY_ID = TC.CATEGORY_ID
         INNER JOIN TBL_USER TU
                    ON TU.USER_ID = TUU.USER_ID
         INNER JOIN TBL_LOCATION tl
                    ON TU.LOCATION_ID = TL.LOCATION_ID
WHERE TUU.USER_UPLOAD_ID = 5;

SELECT TPU.PRO_UPLOAD_ID, TPU.PRO_UPLOAD_DATE, TC.CATEGORY_NAME
     , TS.SERVICE_NAME, TL.REGION, TL.CITY, TPU.PRO_UPLOAD_CONTENT
     ,TP.PRO_STAR_RATE, TPU.PRO_UPLOAD_ADDRESS,TPU.PRO_UPLOAD_PAY_RANGE
     ,TP.PRO_NAME, TP.PRO_ID,TPU.PRO_UPLOAD_TITLE, TPU.PRO_UPLOAD_PAY, TP.EMP_CNT
FROM TBL_PRO_UPLOAD TPU
         INNER JOIN TBL_SERVICE ts
                    ON TPU.SERVICE_ID = TS.SERVICE_ID
         INNER JOIN TBL_CATEGORY tc
                    ON TS.CATEGORY_ID = TC.CATEGORY_ID
         INNER JOIN TBL_PRO TP
                    ON TP.PRO_ID = TPU.PRO_ID
         INNER JOIN TBL_LOCATION tl
                    ON TP.LOCATION_ID = TL.LOCATION_ID
WHERE TPU.PRO_UPLOAD_ID = 7

-- 현제

insert into TBL_CATEGORY (CATEGORY_ID, CATEGORY_NAME)
values (SEQ_CATEGORY.nextval, '이사/청소');

insert into TBL_CATEGORY (CATEGORY_ID, CATEGORY_NAME)
values (SEQ_CATEGORY.nextval, '설치/수리');

insert into TBL_CATEGORY (CATEGORY_ID, CATEGORY_NAME)
values (SEQ_CATEGORY.nextval, '인테리어');

insert into TBL_CATEGORY (CATEGORY_ID, CATEGORY_NAME)
values (SEQ_CATEGORY.nextval, '취미/자기계발');

insert into TBL_CATEGORY (CATEGORY_ID, CATEGORY_NAME)
values (SEQ_CATEGORY.nextval, '기타');

-- 서비스 insert
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '이사', 1);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '입/집청소', 1);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '가구/가구청소', 1);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '특수 청소', 1);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '철거/폐기', 1);

insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '가전제품', 2);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '문/창문', 2);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '수도/보일러/전기', 2);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '가구', 2);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '기타 설치/수리', 2);

insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '종합 인테리어', 3);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '부분 인테리어', 3);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '바닥 시공', 3);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '야외 시공', 3);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '기타 시공', 3);

insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '악기', 4);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '보컬', 4);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '피트니스', 4);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '스포츠', 4);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '댄스', 4);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '연기/마술', 4);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '미술', 4);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '사진/영상', 4);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '투자', 4);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '공예', 4);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '요리/조리', 4);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '패션/미용', 4);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '취업 준비 컨설팅', 4);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '기타 취미/자기계발', 4);

insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '렌탈', 5);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '심리', 5);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '반려동물', 5);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '번역 작업', 5);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '여행', 5);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '심부름', 5);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '도우미', 5);
insert into TBL_SERVICE (SERVICE_ID, SERVICE_NAME, CATEGORY_ID)
values (SEQ_SERVICE.nextval, '알바', 5);



select count(*)
from TBL_LIKE
where USER_ID=1 and COMMUNITY_ID=1;


-- select f.*,c.PRO_ID
-- from TBL_CARDINFO_FILE f
--          join TBL_CARDINFO c on f.CARDINFO_ID = c.CARDINFO_ID
-- where c.PRO_ID =168;

select pro.*,l.REGION,l.CITY
from(select p.PRO_ID,p.PRO_NAME,p.PHONE_NUMBER,p.PRO_IMG,p.LOCATION_ID,u.EMAIL,category.CATEGORY_ID
     from tbl_pro p
              join TBL_CATEGORY_LIST category on p.PRO_ID = category.PRO_ID
              join TBL_USER u on p.USER_ID = u.USER_ID)pro
        join TBL_LOCATION l on l.LOCATION_ID = pro.LOCATION_ID
where pro.PRO_ID = 168;
SELECT ROWNUM AS RN, COMMUNITY.*
FROM (
         SELECT
             C.COMMUNITY_ID,
             C.SUBJECT,
             C.COMMUNITY_TITLE,
             C.COMMUNITY_CONTENT,
             C.COMMUNITY_REGISTER_DATE,
             C.COMMUNITY_UPDATE_DATE,
             C.COMMUNITY_THUMBNAIL
         FROM
             TBL_COMMUNITY C
         ORDER BY
             C.COMMUNITY_UPDATE_DATE DESC
     ) COMMUNITY
WHERE ROWNUM &lt;= 4

SELECT TUR.USER_REQUEST_ID
     , TUR.USER_REQUEST_DATE
     , TC.CATEGORY_NAME
     , TS.SERVICE_NAME
     , TL.REGION
     , TL.CITY
     , TUR.USER_REQUEST_CONTENT
     , TU.USER_STAR_RATE
     , TUR.USER_REQUEST_PROGRESS
     , TU.USER_NAME
     , TU.USER_ID
     , TBL_PRO_UPLOAD.PRO_UPLOAD_TITLE
     , TUR.USER_REQUEST_PAY
FROM TBL_USER_REQUEST TUR
         INNER JOIN TBL_PRO_UPLOAD
                    ON TUR.PRO_UPLOAD_ID = TBL_PRO_UPLOAD.PRO_UPLOAD_ID
         INNER JOIN TBL_SERVICE ts
                    ON TBL_PRO_UPLOAD.SERVICE_ID = TS.SERVICE_ID
         INNER JOIN TBL_CATEGORY tc
                    ON TS.CATEGORY_ID = TC.CATEGORY_ID
         INNER JOIN TBL_USER TU
                    ON TU.USER_ID = TUR.USER_ID
         INNER JOIN TBL_LOCATION tl
                    ON TU.LOCATION_ID = TL.LOCATION_ID
WHERE TUR.USER_REQUEST_ID = 1

SELECT USER_REQUEST_ID, USER_REQUEST_PAY, USER_REQUEST_DATE, USER_REQUEST_PROGRESS,
       TBL_PRO_UPLOAD.PRO_UPLOAD_TITLE,NVL(PR.PRO_STAR_RATE , '0') AS pro_Star_Rate, PR.PRO_NAME, PR.EMP_CNT,
       TBL_USER_REQUEST.PRO_UPLOAD_ID
FROM TBL_USER_REQUEST
         INNER JOIN TBL_PRO_UPLOAD
                    ON TBL_USER_REQUEST.PRO_UPLOAD_ID = TBL_PRO_UPLOAD.PRO_UPLOAD_ID
         INNER JOIN TBL_PRO PR
                    ON TBL_PRO_UPLOAD.PRO_ID = PR.PRO_ID
WHERE TBL_USER_REQUEST.USER_ID = 3619331702;


alter table TBL_PRO_REQUEST
    add CHECK_PRO_REVIEW NUMBER default 0;

alter table TBL_PRO_REQUEST
    add CHECK_USER_REVIEW NUMBER default 0;
SELECT TUR.USER_REQUEST_ID
     , TUR.USER_REQUEST_DATE
     , TC.CATEGORY_NAME
     , TS.SERVICE_NAME
     , TL.REGION
     , TL.CITY
     , TUR.USER_REQUEST_CONTENT
     , TU.USER_STAR_RATE
     , TUR.USER_REQUEST_PROGRESS
     , TU.USER_NAME
     , TU.USER_ID
     , TBL_PRO_UPLOAD.PRO_UPLOAD_TITLE
     , TUR.USER_REQUEST_PAY
FROM TBL_USER_REQUEST TUR
         INNER JOIN TBL_PRO_UPLOAD
                    ON TUR.PRO_UPLOAD_ID = TBL_PRO_UPLOAD.PRO_UPLOAD_ID
         INNER JOIN TBL_SERVICE ts
                    ON TBL_PRO_UPLOAD.SERVICE_ID = TS.SERVICE_ID
         INNER JOIN TBL_CATEGORY tc
                    ON TS.CATEGORY_ID = TC.CATEGORY_ID
         INNER JOIN TBL_USER TU
                    ON TU.USER_ID = TUR.USER_ID
         INNER JOIN TBL_LOCATION tl
                    ON TU.LOCATION_ID = TL.LOCATION_ID
WHERE TUR.USER_REQUEST_ID = 1

SELECT USER_REQUEST_ID, USER_REQUEST_PAY, USER_REQUEST_DATE, USER_REQUEST_PROGRESS,
       TBL_PRO_UPLOAD.PRO_UPLOAD_TITLE,NVL(PR.PRO_STAR_RATE , '0') AS pro_Star_Rate, PR.PRO_NAME, PR.EMP_CNT,
       TBL_USER_REQUEST.PRO_UPLOAD_ID
FROM TBL_USER_REQUEST
         INNER JOIN TBL_PRO_UPLOAD
                    ON TBL_USER_REQUEST.PRO_UPLOAD_ID = TBL_PRO_UPLOAD.PRO_UPLOAD_ID
         INNER JOIN TBL_PRO PR
                    ON TBL_PRO_UPLOAD.PRO_ID = PR.PRO_ID
WHERE TBL_USER_REQUEST.USER_ID = 3619331702;


select sum(cnt) as proEmpCount
from(
        select count(*) as cnt
        from TBL_USER_REQUEST u join TBL_PRO_UPLOAD p
                                     on u.PRO_UPLOAD_ID = p.PRO_UPLOAD_ID
        where u.USER_REQUEST_PROGRESS ='POST' and p.PRO_ID = 1



select sum(cnt) as proEmpCount
from(
        select count(*) as cnt
        from TBL_USER_REQUEST u join TBL_PRO_UPLOAD p
                                     on u.PRO_UPLOAD_ID = p.PRO_UPLOAD_ID
        where u.USER_REQUEST_PROGRESS ='POST' and p.PRO_ID = 1

        union all

        select count(*) as cnt
        from TBL_PRO_REQUEST
        where PRO_ID=1 and PRO_REQUEST_PROGRESS= 'POST'
    );
        union all

        select count(*) as cnt
        from TBL_PRO_REQUEST
        where PRO_ID=1 and PRO_REQUEST_PROGRESS= 'POST'
    );

select count(*) as cnt
from TBL_USER_REQUEST u join TBL_PRO_UPLOAD p
                             on u.PRO_UPLOAD_ID = p.PRO_UPLOAD_ID
where u.USER_REQUEST_PROGRESS ='POST' and p.PRO_ID = 1



SELECT USER_REQUEST_ID, USER_REQUEST_PAY, USER_REQUEST_DATE, USER_REQUEST_PROGRESS,
       TBL_PRO_UPLOAD.PRO_UPLOAD_TITLE,NVL(PR.PRO_STAR_RATE , '0') AS pro_Star_Rate, PR.PRO_NAME, PR.EMP_CNT,
       TBL_USER_REQUEST.PRO_UPLOAD_ID
FROM TBL_USER_REQUEST
         INNER JOIN TBL_PRO_UPLOAD
                    ON TBL_USER_REQUEST.PRO_UPLOAD_ID = TBL_PRO_UPLOAD.PRO_UPLOAD_ID
         INNER JOIN TBL_PRO PR
                    ON TBL_PRO_UPLOAD.PRO_ID = PR.PRO_ID
WHERE TBL_USER_REQUEST.USER_ID = 3619331702;


alter table TBL_PRO_REQUEST
    add CHECK_PRO_REVIEW NUMBER default 0;

alter table TBL_PRO_REQUEST
    add CHECK_USER_REVIEW NUMBER default 0;

alter table TBL_USER_REQUEST
    add CHECK_PRO_REVIEW NUMBER default 0;

alter table TBL_USER_REQUEST
    add CHECK_USER_REVIEW NUMBER default 0;

select sum(cnt) as proEmpCount
from(
        select count(*) as cnt
        from TBL_USER_REQUEST u join TBL_PRO_UPLOAD p
                                     on u.PRO_UPLOAD_ID = p.PRO_UPLOAD_ID
        where u.USER_REQUEST_PROGRESS ='POST' and p.PRO_ID = 1

        union all

        select count(*) as cnt
        from TBL_PRO_REQUEST
        where PRO_ID=1 and PRO_REQUEST_PROGRESS= 'POST'
    );
alter table TBL_COMMUNITY
    add VIEWS NUMBER;
alter table TBL_COMMUNITY
    add show_content varchar2(1000);
alter table TBL_COMMunity
    add author varchar2(50);
alter table TBL_COMMENT
    add author varchar2(50);


select count(*) as cnt
from TBL_USER_REQUEST u join TBL_PRO_UPLOAD p
                             on u.PRO_UPLOAD_ID = p.PRO_UPLOAD_ID
where u.USER_REQUEST_PROGRESS ='POST' and p.PRO_ID = 1;

SELECT tur.USER_ID,
       tur.PRO_ID,
       tp.PRO_NAME,
       tur.USER_REVIEW_TITLE,
       tur.USER_REVIEW_CONTENT,
       tur.USER_REVIEW_RATE,
       tur.USER_REVIEW_DATE
FROM TBL_USER_REVIEW tur
         INNER JOIN TBL_PRO tp
                    ON TUR.PRO_ID = TP.PRO_ID
WHERE TUR.USER_ID = 3619331702
ORDER BY TUR.USER_REVIEW_DATE DESC;

select TPU.PRO_UPLOAD_ID, TPU.PRO_ID, tpu.PRO_UPLOAD_TITLE, tpu.PRO_UPLOAD_DATE, tp.PRO_STAR_RATE, tp.PRO_NAME,
       ts.SERVICE_NAME, tp.PRO_IMG
from TBL_PRO_UPLOAD TPU
         inner join TBL_PRO TP
                    on TPU.PRO_ID = TP.PRO_ID
         inner join TBL_SERVICE TS
                    on tpu.SERVICE_ID = ts.SERVICE_ID
         inner join TBL_CATEGORY tg
                    on tg.CATEGORY_ID = ts.CATEGORY_ID
    where
    TPU.PRO_UPLOAD_TITLE LIKE '%' || '' || '%' AND TG.CATEGORY_ID = 1
        ORDER BY
        PRO_UPLOAD_DATE DESC



SELECT *
FROM (
         SELECT ROWNUM AS RN, UPLOAD.*
         FROM (
                  select TPU.PRO_UPLOAD_ID, TPU.PRO_ID, tpu.PRO_UPLOAD_TITLE, tpu.PRO_UPLOAD_DATE, tp.PRO_STAR_RATE, tp.PRO_NAME,
                         ts.SERVICE_NAME, tp.PRO_IMG
                  from TBL_PRO_UPLOAD TPU
                           inner join TBL_PRO TP
                                      on TPU.PRO_ID = TP.PRO_ID
                           inner join TBL_SERVICE TS
                                      on tpu.SERVICE_ID = ts.SERVICE_ID
                           inner join TBL_CATEGORY tg
                                      on tg.CATEGORY_ID = ts.CATEGORY_ID
                  WHERE  tpu.PRO_UPLOAD_TITLE LIKE '%' || '''''' || '%' AND TG.CATEGORY_ID = 1
                  ORDER BY
                      PRO_UPLOAD_DATE DESC
              ) UPLOAD
         WHERE ROWNUM <= 10
     )
WHERE rn > 0;

select ROWNUM AS RN ,ur.*
from(select tpr.*,c.CATEGORY_NAME
     from(    select tp.PRO_NAME, tu.USER_NAME,pr.*,cl.CATEGORY_ID
              from TBL_PRO_REVIEW pr
                       join TBL_PRO tp on pr.PRO_ID = tp.PRO_ID
                       join TBL_USER tu on tu.USER_ID =tp.USER_ID
                       join TBL_CATEGORY_LIST cl on cl.PRO_ID = pr.PRO_ID)tpr
     join TBL_CATEGORY c on c.CATEGORY_ID=tpr.CATEGORY_ID)ur
     where USER_ID=3614057925
     order by ur.PRO_REVIEW_DATE DESC,ur.PRO_REVIEW_ID desc;

SELECT ROWNUM , pro.*
FROM (      SELECT TPU.PRO_UPLOAD_ID
                 , TPU.PRO_UPLOAD_DATE
                 , TC.CATEGORY_NAME
                 , TS.SERVICE_NAME
                 , TL.REGION
                 , TL.CITY
                 , TPU.PRO_UPLOAD_CONTENT
                 , TP.PRO_STAR_RATE
                 , TPU.PRO_UPLOAD_ADDRESS
                 , TPU.PRO_UPLOAD_PAY_RANGE
                 , TP.PRO_NAME
                 , TP.PRO_ID
                 , TPU.PRO_UPLOAD_TITLE
                 , TP.EMP_CNT
                 , puf.PRO_UPLOAD_FILE_ROUTE
            FROM TBL_PRO_UPLOAD TPU
                     INNER JOIN TBL_SERVICE ts
                                ON TPU.SERVICE_ID = TS.SERVICE_ID
                     INNER JOIN TBL_CATEGORY tc
                                ON TS.CATEGORY_ID = TC.CATEGORY_ID
                     INNER JOIN TBL_PRO TP
                                ON TP.PRO_ID = TPU.PRO_ID
                     INNER JOIN TBL_LOCATION tl
                                ON TP.LOCATION_ID = TL.LOCATION_ID
                     JOIN TBL_PRO_UPLOAD_FILE puf
                          On TPU.PRO_UPLOAD_ID = puf.PRO_UPLOAD_ID
            order by TPU.PRO_UPLOAD_DATE desc
     ) pro
WHERE ROWNUM <= 8

SELECT ROWNUM , pro.*
FROM (  select    TPU.PRO_UPLOAD_ID, TPU.PRO_ID, tpu.PRO_UPLOAD_TITLE, tpu.PRO_UPLOAD_DATE, tp.PRO_STAR_RATE, tp.PRO_NAME,
        ts.SERVICE_NAME, tp.PRO_IMG
        from TBL_PRO_UPLOAD TPU
        inner join TBL_PRO TP
        on TPU.PRO_ID = TP.PRO_ID
        inner join TBL_SERVICE TS
        on tpu.SERVICE_ID = ts.SERVICE_ID
        inner join TBL_CATEGORY tg
        on tg.CATEGORY_ID = ts.CATEGORY_ID
            order by TPU.PRO_UPLOAD_DATE desc
     ) pro
WHERE ROWNUM <= 6


SELECT ROWNUM, pro.*
FROM (select TPU.PRO_UPLOAD_ID,
             TPU.PRO_ID,
             tpu.PRO_UPLOAD_TITLE,
             tpu.PRO_UPLOAD_DATE,
             tp.PRO_STAR_RATE,
             tp.PRO_NAME,
             ts.SERVICE_NAME,
             tp.PRO_IMG
      from TBL_PRO_UPLOAD TPU
               inner join TBL_PRO TP
                          on TPU.PRO_ID = TP.PRO_ID
               inner join TBL_SERVICE TS
                          on tpu.SERVICE_ID = ts.SERVICE_ID
               inner join TBL_CATEGORY tg
                          on tg.CATEGORY_ID = ts.CATEGORY_ID
      order by tpu.PRO_UPLOAD_DATE desc) pro
WHERE ROWNUM <= 6

