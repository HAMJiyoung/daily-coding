USE fastcampus_sample ;

-- 01. 2020년 7월의 총 Revenue
SELECT SUM(price) as total_revenue
FROM tbl_purchase 
WHERE purchased_date BETWEEN '2020-07-01' AND '2020-07-31' ;

SELECT SUM(price) as total_revenue
FROM tbl_purchase 
WHERE purchased_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' ;


-- 02. 2020년 7월의 MAU
SELECT COUNT(DISTINCT customer_id) as mau_2020_july
FROM tbl_visit 
WHERE visited_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' ;


-- 03. 7월에 우리 Active 유저의 구매율(Paying Rate)

-- 7월 접속 유저 
SELECT COUNT(DISTINCT customer_id) as visitor_id
FROM tbl_visit 
WHERE visited_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' ;

-- 7월 구매 유저
SELECT COUNT(DISTINCT customer_id) as purchased_id
FROM tbl_purchase
WHERE purchased_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' ;

-- 7월 active user 구매율
SELECT ROUND((
	SELECT COUNT(DISTINCT customer_id) 
	FROM tbl_purchase
	WHERE purchased_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59') / 
    COUNT(DISTINCT customer_id) * 100, 1) as paying_rate
FROM tbl_visit
WHERE visited_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' ;

-- 헷갈릴 것 같다면 그냥 간단하게 수치 계산으로 해도 됨
SELECT (11174 / 16414)


/*04. 7월 구매 유저 1명 당 월 평균 구매금액
ARPPU = Average Revenue per Paying User */

-- 7월 구매 금액
SELECT SUM(price) as total_revenue
FROM tbl_purchase 
WHERE purchased_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' ;

-- 7월 구매 유저 수 
SELECT COUNT(DISTINCT customer_id) as purchased_id
FROM tbl_purchase
WHERE purchased_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' ;

-- 구해보자 
SELECT ROUND(SUM(price) / COUNT(DISTINCT customer_id)) as ARPPU_2020_july
FROM tbl_purchase
WHERE purchased_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' ;


-- 05. 7월에 가장 많이 구매한 고객 top3와 top 10~15 고객
-- top3
SELECT customer_id,
	SUM(price) as sum_price
FROM tbl_purchase
WHERE purchased_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' 
GROUP BY customer_id
ORDER BY sum_price DESC
LIMIT 3;

-- top 10~15
SELECT customer_id,
	SUM(price) as sum_price
FROM tbl_purchase
WHERE purchased_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' 
GROUP BY customer_id
ORDER BY sum_price DESC
LIMIT 9, 6;


-- 06. 2020년 7월의 평균 DAU를 구하라. Active User 수가 증가하는 추세인가?
-- 7월 일별 dau
SELECT DATE(visited_at) as visited_date,
	COUNT(DISTINCT customer_id) as DAU
FROM tbl_visit
WHERE visited_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' 
GROUP BY visited_date ;
-- 8월 1일이 왜 끼어있는지?

-- 7월 일별 dau 2트: 날짜에서 문제가 있는듯 하여 그냥 숫자를 잘라버렸다 
SELECT LEFT(visited_at, 10) as visited_date,
	COUNT(DISTINCT customer_id) as dau
FROM tbl_visit
WHERE visited_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' 
GROUP BY visited_date ;
-- 7월 유저 추세 : 증가하는 중

-- 7월 평균 DAU 
SELECT AVG(dau)
FROM(
	SELECT LEFT(visited_at, 10) as visited_date,
		COUNT(DISTINCT customer_id) as dau
	FROM tbl_visit
	WHERE visited_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' 
	GROUP BY visited_date
	) visited ;


-- 07. 2020년 7월의 평균 WAU



-- 08. 2020년 7월의 Daily Revenue는 증가하는 추세인가? 평균 Daily Revenue는?

-- 09. 2020년 7월의 평균 weekly revenue

-- 10. 2020년 7월 요일별 revenue. 가장 높은 요일과 가장 낮은 요일

-- 11. 2020년 7월 시간대별 revenue. 가장 높은 시간대와 가장 낮은 시간대

-- 12. 2020년 7월 요일 및 시간대별 revenue. 가장 높은 &낮은 

-- 13. 성/연령별 유저 숫자. 남녀 외 기타 성별은 하나로, 연령은 5세단위, 숫자가 높은 순서대로 정렬

-- 14. 13의 결과를 성별(연령)의 형태로 통합하고, 각 성/연령이 전체의 몇 %인지 숫자가 높은 순서대로 정렬 

-- 15. 2020년 7월, 성별에 따른 구매 건수와 총 revenue(남녀 외 성별은 하나로)

-- 16. 2020년 7월의 성별/연령대에 따라 구매 건수와 총 revenue(남녀 외 성별은 하나로)

-- 17. 2020년 7월 일별 매출과 증감폭, 증감률

-- 18. 2020년 7월 일별로 구매금액 기준 가장 많이 지출한 고객 top3 

-- 19. 2020년 7월 신규유저가 하루 내에 결제로 넘어가는 비율은? 결제까지 평균 소요 분?

-- 20. 2020년 7월 기준 day1 리텐션이 어떤가? 추세를 보기 위해 daily 추출
-- N-day Retention: N = 1,2,3,... 등

-- 21. 가입 기간별 고객 분포(기존/신규) dau 기준
