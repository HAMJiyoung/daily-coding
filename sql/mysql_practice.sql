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
	) dau ;


-- 07. 2020년 7월의 평균 WAU
-- 7월 주별 active user count
SELECT WEEK(visited_at) as visited_week,
	COUNT(DISTINCT customer_id) as wau
FROM tbl_visit
WHERE visited_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' 
GROUP BY visited_week ;

-- 7월 평균 wau
SELECT AVG(wau)
FROM(
	SELECT WEEK(visited_at) as visited_week,
		COUNT(DISTINCT customer_id) as wau
	FROM tbl_visit
	WHERE visited_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' 
	GROUP BY visited_week
    ) wau ;



-- 08. 2020년 7월의 Daily Revenue는 증가하는 추세인가? 평균 Daily Revenue는?
-- 7월 daily revenue
SELECT LEFT(purchased_at, 10) as purchased_date,
	SUM(price) as revenue
FROM tbl_purchase
WHERE purchased_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59'
GROUP BY LEFT(purchased_at, 10) ;
-- 증가하는 추세이다

-- 7월 평균 daily revenue
SELECT AVG(revenue)
FROM(
	SELECT LEFT(purchased_at, 10) as purchased_date,
		SUM(price) as revenue
	FROM tbl_purchase
	WHERE purchased_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59'
	GROUP BY LEFT(purchased_at, 10)
	) daily_revenue ;


-- 09. 2020년 7월의 평균 weekly revenue
SELECT AVG(revenue)
FROM(
	SELECT WEEK(purchased_at) as visited_week,
		SUM(price) as revenue
	FROM tbl_purchase
	WHERE purchased_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' 
	GROUP BY visited_week
    ) weekly_revenue ;


-- 10. 2020년 7월 요일별 revenue. 가장 높은 요일과 가장 낮은 요일
-- 단순 요일별 합계
SELECT DATE_FORMAT(purchased_at, '%w') as visited_day_of_week,
		SUM(price) as revenue
FROM tbl_purchase
WHERE purchased_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' 
GROUP BY visited_day_of_week 
ORDER BY revenue DESC;
-- 0 = sunday, 6 = saturday
-- max = thursday, min = sunday

-- 요일별 평균
SELECT DATE_FORMAT(purchased_date, '%W') as date_name,
	AVG(revenue) 
FROM (SELECT LEFT(purchased_at, 10) as purchased_date,
		SUM(price) as revenue
	FROM tbl_purchase
	WHERE purchased_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' 
	GROUP BY LEFT(purchased_at, 10) 
	ORDER BY revenue DESC) tbl_dow_revenue 
GROUP BY date_name ;



-- 11. 2020년 7월 시간대별 revenue. 가장 높은 시간대와 가장 낮은 시간대
SELECT HOUR(purchased_at) as purchased_hour,
	SUM(price)
FROM tbl_purchase 
WHERE purchased_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' 
GROUP BY purchased_hour
ORDER BY SUM(price) DESC ;
-- 엥 새벽 3시가 가장 높다고? 이게 맞나 뭔가 이상한데
SELECT HOUR(REPLACE(purchased_at, '+00:00', '')) as purchased_hour,
	SUM(price)
FROM tbl_purchase 
WHERE purchased_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' 
GROUP BY purchased_hour
ORDER BY SUM(price) DESC ;
-- 가장 높은 시간: 18시, 가장 낮은 시간: 6시 



-- 12. 2020년 7월 요일 및 시간대별 revenue. 가장 높은 &낮은 
SELECT DATE_FORMAT(purchased_at, '%W') as purchased_day,
	HOUR(REPLACE(purchased_at, '+00:00', '')) as purchased_hour,
	SUM(price)
FROM tbl_purchase 
WHERE purchased_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' 
GROUP BY 1, 2
ORDER BY SUM(price) DESC ;
-- 가장 높은: 목요일 16시, 가장 낮은: 토요일 6시

-- 날짜 추가
SELECT LEFT(purchased_at, 10) as purchased_date,
	DATE_FORMAT(purchased_at, '%W') as purchased_day,
	HOUR(REPLACE(purchased_at, '+00:00', '')) as purchased_hour,
	SUM(price)
FROM tbl_purchase 
WHERE purchased_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' 
GROUP BY 1, 2, 3
ORDER BY SUM(price) DESC ;
-- 27일 월요일 13시 최고 매출, 11일 토요일 6시 최저 매출 


-- 13. 성/연령별 유저 숫자. 남녀 외 기타 성별은 하나로, 연령은 10세단위, 숫자가 높은 순서대로 정렬
SELECT gender,
	COUNT(*)
FROM tbl_customer
GROUP BY gender ;

-- 남녀 외 기타 성별 합치기
SELECT 
	CASE gender
		WHEN 'F' THEN gender
		WHEN 'M' THEN gender
		ELSE 'Other'
	END AS gender_all,
    COUNT(*) as user_cnt
FROM tbl_customer 
GROUP BY gender_all
ORDER BY user_cnt DESC ;

-- 나이대 분류
SELECT
    CASE 
    WHEN age < 10 THEN '~10'
    WHEN age < 20 THEN '~19'
    WHEN age < 30 THEN '~29'
    WHEN age < 40 THEN '~39'
    WHEN age < 50 THEN '~49'
    WHEN 50 < age THEN '49~'
    ELSE 'None'
    END AS age_range,
    COUNT(*) as user_cnt
FROM tbl_customer 
GROUP BY age_range
ORDER BY user_cnt DESC ;
-- 20~29세 가장 많음 


-- 14. 13의 결과를 성별(연령)의 형태로 통합하고, 각 성/연령이 전체의 몇 %인지 숫자가 높은 순서대로 정렬 
SELECT CONCAT(
	CASE gender
		WHEN 'F' THEN gender
		WHEN 'M' THEN gender
		ELSE 'Other'
	END,
	CASE 
		WHEN age < 10 THEN '(~10)'
		WHEN age < 20 THEN '(~19)'
		WHEN age < 30 THEN '(~29)'
		WHEN age < 40 THEN '(~39)'
		WHEN age < 50 THEN '(~49)'
		WHEN 50 < age THEN '(49~)'
		ELSE '(None)'
    END) AS user_segment,
    (COUNT(*) / (SELECT COUNT(*) FROM tbl_customer)) * 100 as user_ratio
FROM tbl_customer 
GROUP BY user_segment
ORDER BY user_ratio DESC ;
-- 가장 많은 segment: F(~29)

-- 15. 2020년 7월, 성별에 따른 구매 건수와 총 revenue(남녀 외 성별은 하나로)
SELECT 
	CASE gender
		WHEN 'F' THEN gender
		WHEN 'M' THEN gender
		ELSE 'Other'
	END AS gender_all,
	COUNT(*) AS cnt_purchased,
    SUM(price) AS revenue
FROM tbl_purchase
JOIN tbl_customer
	ON tbl_purchase.customer_id = tbl_customer.customer_id 
WHERE purchased_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' 
GROUP BY gender_all ;


-- 16. 2020년 7월의 성별/연령대에 따라 구매 건수와 총 revenue(남녀 외 성별은 하나로)
SELECT CONCAT(
	CASE gender
		WHEN 'F' THEN gender
		WHEN 'M' THEN gender
		ELSE 'Other'
	END,
	CASE 
		WHEN age < 10 THEN '(~10)'
		WHEN age < 20 THEN '(~19)'
		WHEN age < 30 THEN '(~29)'
		WHEN age < 40 THEN '(~39)'
		WHEN age < 50 THEN '(~49)'
		WHEN 50 < age THEN '(49~)'
		ELSE '(None)'
    END) AS user_segment,
    COUNT(*) AS cnt_purchased,
    SUM(price) AS revenue
FROM tbl_purchase
JOIN tbl_customer
	ON tbl_purchase.customer_id = tbl_customer.customer_id
WHERE purchased_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' 
GROUP BY user_segment 
ORDER BY revenue DESC ;

-- 17. 2020년 7월 일별 매출과 증감폭, 증감률

WITH tbl_total 
	AS (SELECT purchased_date,
			SUM(price) AS revenue
		FROM tbl_purchase
		WHERE purchased_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' 
		GROUP BY purchased_date)

SELECT purchased_date,
	revenue,
    revenue - LAG(revenue) OVER (ORDER BY purchased_date) AS diff_rev,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY purchased_date)) / LAG(revenue) OVER (ORDER BY purchased_date) *100, 1) AS ratio
FROM tbl_total ;



-- 18. 2020년 7월 일별로 구매금액 기준 가장 많이 지출한 고객 top3 
-- 일별 구매금액 높은 유저 순으로 정렬
SELECT purchased_date,
	customer_id,
    SUM(price) AS revenue
FROM tbl_purchase
WHERE purchased_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' 
GROUP BY purchased_date, customer_id 
ORDER BY purchased_date, revenue DESC ;
-- 이 중에서 일별 3명씩을 뽑아야 한다. 어떻게 하면 될까
-- rank 관련 함수로 일자별 고객을 정렬, 같은 금액 있을 수 있으니 dense_rank로 가격이 같은 사람도 포함되도록
SELECT purchased_date,
	customer_id,
    revenue
FROM(
	SELECT purchased_date,
		customer_id,
		SUM(price) AS revenue,
		DENSE_RANK() OVER(PARTITION BY purchased_date ORDER BY SUM(price) DESC) AS ranking
	FROM tbl_purchase
	WHERE purchased_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' 
	GROUP BY purchased_date, customer_id 
	ORDER BY purchased_date, revenue DESC) AS tbl_ranking
WHERE ranking < 4 ;

-- +추가로 이 중에 가장 많이 count된 고객이 누구일까 궁금
WITH tbl_ranking AS(SELECT purchased_date,
						customer_id,
						SUM(price) AS revenue,
						DENSE_RANK() OVER(PARTITION BY purchased_date ORDER BY SUM(price) DESC) AS ranking
					FROM tbl_purchase
					WHERE purchased_at BETWEEN '2020-07-01 00:00:00' AND '2020-07-31 23:59:59' 
					GROUP BY purchased_date, customer_id 
					ORDER BY purchased_date, revenue DESC)
                    
SELECT customer_id,
	COUNT(*) AS cnt_user
FROM tbl_ranking
WHERE ranking < 4 
GROUP BY customer_id 
ORDER BY cnt_user DESC ;
-- 37563님 축하합니다~ 1등

-- 19. 2020년 7월 신규유저가 하루 내에 결제로 넘어가는 비율은? 결제까지 평균 소요 분?
-- 2020년 7월 신규 가입한 유저, 해당 유저들 중 하루 내에 결제한 유저, 구매 일시 - 신규 가입 일시 분 
WITH tbl_new_purchased AS(
	SELECT c.customer_id,
		p.customer_id AS paying_user,
		TIME_TO_SEC(TIMEDIFF(p.first_purchase_date, c.created_at)) AS diff_time
	-- 신규 가입 유저 테이블에
	FROM tbl_customer AS c
	-- 해당 유저들의 첫 구매 일시 left join
	LEFT JOIN(
				SELECT MIN(purchased_at) AS first_purchase_date,
					customer_id
				FROM tbl_purchase
				GROUP BY customer_id) AS p
		ON c.customer_id = p.customer_id
        -- 신규 가입 일시 + 1 > 구매 일시
        AND c.created_at + INTERVAL 1 DAY > p.first_purchase_date
	-- 2020년 7월 신규 가입자만
	WHERE created_at >= '2020-07-01 00:00:00'
		AND created_at < '2020-08-01 00:00:00')

SELECT ROUND(COUNT(paying_user) / COUNT(customer_id) * 100, 1) AS cvr,
	ROUND(AVG(diff_time) / 3600, 1) AS avg_time
FROM tbl_new_purchased ;-- conversion rate



-- 20. 2020년 7월 각 카테고리별 판매 금액과 비율 (%)
-- total_revenue
SELECT SUM(price)
FROM tbl_purchase
WHERE purchased_date BETWEEN '2020-07-01' AND '2020-07-31' ;

-- category revenue, ratio
SELECT category,
	SUM(price) AS revenue,
	ROUND(SUM(price) / 21060206300, 4) AS ratio
FROM tbl_purchase
WHERE purchased_date BETWEEN '2020-07-01' AND '2020-07-31'
GROUP BY category ;
-- 가끔은 단순하게 하는게 제일 빠를수도 있다


-- 21. 2020년 7월 기준, 누적 구매 횟수 3번 이상인 고객 리스트 추출, 많이 구매한 순서
SELECT customer_id,
	COUNT(*) AS cnt_purchase
FROM tbl_purchase
WHERE purchased_date <= '2020-07-31' 
GROUP BY customer_id 
HAVING cnt_purchase >= 3 
ORDER BY cnt_purchase DESC ;


-- 22. 2020년 7월 Furniture와 Education을 각 1회 이상씩 구매한 고객 수 
-- furniture
SELECT customer_id,
	category,
    COUNT(*) AS cnt_purchase
FROM tbl_purchase
WHERE purchased_date BETWEEN '2020-07-01' AND '2020-07-31'
	AND category = 'Furniture'
GROUP BY customer_id, category ;

-- Education
SELECT customer_id,
	category,
    COUNT(*) AS cnt_purchase
FROM tbl_purchase
WHERE purchased_date BETWEEN '2020-07-01' AND '2020-07-31'
	AND category = 'Education'
GROUP BY customer_id, category ;

-- customer_id 기준 join
SELECT COUNT(DISTINCT tbl_fp.customer_id) AS cnt_both_purchased_user
FROM (SELECT customer_id,
			category,
			COUNT(*) AS cnt_purchase
		FROM tbl_purchase
		WHERE purchased_date BETWEEN '2020-07-01' AND '2020-07-31'
			AND category = 'Furniture'
		GROUP BY customer_id, category) AS tbl_fp -- furniture_purchase
JOIN (SELECT customer_id,
			category,
			COUNT(*) AS cnt_purchase
		FROM tbl_purchase
		WHERE purchased_date BETWEEN '2020-07-01' AND '2020-07-31'
			AND category = 'Education'
		GROUP BY customer_id, category) AS tbl_ep -- education_purchase
ON tbl_fp.customer_id = tbl_ep.customer_id ;




-- 23. 전체 기간 동안 첫 구매는 Furniture, 마지막 구매는 다른 카테고리인 고객 수
-- 첫 구매 Furniture
SELECT customer_id,
	category,
    MIN(purchased_date)
FROM tbl_purchase
WHERE category = 'Furniture' 
GROUP BY customer_id, category ;

-- 마지막 구매 Education, Electronic
SELECT customer_id,
	category,
    MAX(purchased_date)
FROM tbl_purchase
WHERE category != 'Furniture'
GROUP BY customer_id, category ;

-- 두가지 합치기

WITH tbl_min_date AS (SELECT customer_id,
						category,
						MIN(purchased_date)
					FROM tbl_purchase
					WHERE category = 'Furniture' 
					GROUP BY customer_id, category),
	tbl_total AS (SELECT tbl_purchase.customer_id,
						tbl_min_date.category AS first_buy,
						tbl_purchase.category AS last_buy,
						MAX(purchased_date)
					FROM tbl_purchase
					INNER JOIN tbl_min_date
						ON tbl_purchase.customer_id = tbl_min_date.customer_id
					WHERE tbl_purchase.category != 'Furniture'
					GROUP BY customer_id, first_buy, last_buy)

SELECT COUNT(*) AS cnt_customer
-- 잘 나오는거 확인해서 주석처리
-- tbl_total.customer_id AS user_id,
-- 	first_buy,
--     last_buy
FROM tbl_total ;
-- ORDER BY user_id ;


-- 24. 가장 많이 팔린 상품은?
SELECT product_id,
	COUNT(*) cnt_product
FROM tbl_purchase
GROUP BY product_id
ORDER BY cnt_product DESC ;

-- 25. 가장 많이 팔린 상품을 가장 많이 구매한 고객?
-- 가장 많이 팔린 상품
WITH tbl_most_sold AS(
	SELECT product_id,
		MAX(customer_id),
		COUNT(*) cnt_product
	FROM tbl_purchase
	GROUP BY product_id
	ORDER BY cnt_product DESC 
	LIMIT 1)
-- 가장 많이 팔린 상품을 많이 구매한 고객 순서대로 
SELECT tbl_purchase.customer_id,
	COUNT(*) cnt_per_customer
FROM tbl_purchase
RIGHT JOIN tbl_most_sold
	ON tbl_purchase.product_id = tbl_most_sold.product_id
GROUP BY tbl_purchase.customer_id
ORDER BY cnt_per_customer DESC ;



-- 20. 2020년 7월 기준 day1 리텐션이 어떤가? 추세를 보기 위해 daily 추출
-- N-day Retention: N = 1,2,3,... 등

-- 21. 가입 기간별 고객 분포(기존/신규) dau 기준



-- 26. 첫 구매 카테고리별로 1달 리텐션