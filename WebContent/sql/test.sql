SET @rownum:=0;
SELECT b.* FROM (SELECT A.*, @rownum:=@rownum+1 as RNUM FROM ((SELECT * FROM WORDLIST ORDER BY NVL(LIKECOUNT,0) DESC ) A)) b where b.rnum >=1 and b.rnum<=10

select * from users 


