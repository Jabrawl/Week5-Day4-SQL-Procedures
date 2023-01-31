-- QUESTION 1: Takes in a fee, and applies it to each rental that is more then 7 days rented 
CREATE OR REPLACE PROCEDURE lateFee(
	lateFeeAmount DECIMAL(4,2)
)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE payment
	SET amount = amount + lateFeeAmount
	WHERE customer_id IN (
		SELECT customer_id 
		FROM rental
		WHERE return_date - INTERVAL '7 DAYS' > rental_date
);
	COMMIT;
END;
$$;

CALL lateFee(75.00);

SELECT * FROM rental;

SELECT * FROM payment;

-- QUESTION 2: Updates each customer under $200 to False, then Updates each over $200 to True

ALTER TABLE customer
ADD COLUMN platinum BOOLEAN;

CREATE OR REPLACE PROCEDURE platMemberCheck()
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE customer
	SET platinum = False
	WHERE customer_id IN (
		SELECT customer_id
		FROM payment
		WHERE amount <= 200
	);
	UPDATE customer
	SET platinum = True
	WHERE customer_id IN (
		SELECT customer_id
		FROM payment
		WHERE amount > 200
	);
	
	COMMIT;
END;
$$

CALL platMemberCheck()
