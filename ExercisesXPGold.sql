-- --------- Exercise 1: DVD Rental
/*
	1 ) You were hired to babysit your cousin and you want to find a few movies 
	that he can watch with you.
*/
	-- 1) Find out how many films there are for each rating.
SELECT rating, COUNT(film_id)
	FROM film 
	GROUP BY rating;

	-- 2) Get a list of all the movies that have a rating of G or PG-13
		-- 1) Filter this list further: look for only movies that are under 2 hours long,
			-- and whose rental price (rental_rate) is under 3.00. Sort the list alphabetically.
SELECT *
	FROM film 
	WHERE (rating = 'G' OR rating = 'PG-13')
	AND length < 120
	AND rental_rate < 3;

	-- 3) Find a customer in the customer table, 
		-- and change his/her details to your details, using SQL UPDATE.
UPDATE customer
	SET first_name = 'Jean',
		last_name = 'Dupont',
		email = 'j.dupont@mail.fr',
	WHERE customer_id = 8

	-- 4) Now find the customer’s address, and use UPDATE to change 
		-- the address to your address (or make one up).
UPDATE address 
	SET address = '66000 Paris'
WHERE address_id = (SELECT customer.address_id 
						  FROM customer 
						  WHERE customer.last_name = 'ETOUMI');


-- -------- Exercise 2: Students Table
-- Update
/*
	1) ‘Lea Benichou’ and ‘Marc Benichou’ are twins, they should have 
	the same birth_dates. Update both their birth_dates to 02/11/1998.
*/
UPDATE students
	SET birth_date = '1998-11-02'
	WHERE last_name = 'Benichou';

-- 2) Change the last_name of David from ‘Grez’ to ‘Guez’.
UPDATE students
	SET last_name = 'Guez'
	WHERE id = 5;

--Delete
-- 1) Delete the student named ‘Lea Benichou’ from the table.
DELETE FROM students
	WHERE first_name || ' ' || last_name = 'Lea Benichou';

-- Count
-- 1) Count how many students are in the table
SELECT COUNT(*) 
	FROM students;

-- 2) Count how many students were born after 1/01/2000.
SELECT COUNT(*) 
	FROM students
	WHERE birth_date > '2000-01-01';

-- Insert / Alter
-- 1) Add a column to the student table called math_grade.
ALTER TABLE students
	ADD math_grade SMALLINT;

-- 2) Add 80 to the student which id is 1.
UPDATE students
	SET math_grade = 80
	WHERE id = 1;

-- 3) Add 90 to the students which have ids of 2 or 4.
UPDATE students
	SET math_grade = 90
	WHERE id IN (2, 4);

-- 4) Add 40 to the student which id is 6.
UPDATE students
	SET math_grade = 40
	WHERE id = 6;

-- 5) Count how many students have a grade bigger than 83
SELECT COUNT(*) 
	FROM students
	WHERE math_grade > 83;

-- 6) Add another student named ‘Omer Simpson’ with the same birth_date 
	-- as the one already in the table. Give him a grade of 70.
INSERT INTO students(last_name, first_name, birth_date, math_grade)
	VALUES ('Omer', 'Simpson', (
			SELECT birth_date FROM students WHERE id = 4
		), 70);

/*
	7) Now, in the table, ‘Omer Simpson’ should appear twice. 
	It’s the same student, although he received 2 different grades because he retook the math exam.
	Bonus: Count how many grades each student has.
	Tip: You should display the first_name, last_name and the number of grades 
	of each student. If you followed the instructions above correctly, all the students should have 1 math grade, except Omer Simpson which has 2.
	Tip : Use an alias called total_grade to fetch the grades.
	Hint : Use GROUP BY.
*/
SELECT first_name, last_name, COUNT(math_grade) AS total_grade
	FROM students
	GROUP BY first_name, last_name;

-- SUM
-- 1) Find the sum of all the students grades.
SELECT SUM(math_grade) AS total_students_grade
	FROM students;



-- ------ Exercise 3 : Items And Customers
-- ====== Part I ============
/*
	1) Create a table named purchases. It should have 3 columns :
		id : the primary key of the table
		customer_id : this column references the table customers
		item_id : this column references the table items
		quantity_purchased : this column is the quantity of items
		purchased by a certain customer
*/
CREATE TABLE IF NOT EXISTS purchases(
	id SERIAL PRIMARY KEY,
	customer_id INTEGER NOT NULL,
	item_id INTEGER NOT NULL,
	quantity_purchased SMALLINT NOT NULL,
	
	CONSTRAINT fk_customer FOREIGN KEY(customer_id) 
		REFERENCES customers(id) 
		ON UPDATE CASCADE 
		ON DELETE RESTRICT,
		
	CONSTRAINT fk_items FOREIGN KEY(item_id) 
		REFERENCES items(id) 
		ON UPDATE CASCADE 
		ON DELETE RESTRICT
);

/*
	2) Insert purchases for the customers, use subqueries:
		Scott Scott bought one fan
		Melanie Johnson bought ten large desks
		Greg Jones bougth two small desks
*/
INSERT INTO purchases(customer_id, item_id, quantity_purchased)
	VALUES
		((SELECT customers.id FROM customers WHERE customers.nom = 'Scott' AND customers.prenom = 'Scott'),
		(SELECT items.id FROM items  WHERE items.libelle ='Fan'),
		1),
		((SELECT customers.id FROM customers WHERE customers.nom = 'Melanie' AND customers.prenom = 'Johnson'), 
		(SELECT items.id FROM items  WHERE items.libelle ='Large Desk'),
		10),
		((SELECT customers.id FROM customers WHERE customers.nom = 'Jones' AND customers.prenom = 'Greg'), 
		(SELECT items.id FROM items  WHERE items.libelle ='Small Desk'),
		2);
	 


--========== Part II ============
-- 1) Use SQL to get the following from the database:
	-- 1) All purchases. Is this information useful to us?
SELECT * FROM purchases;

	-- 2) All purchases, joining with the customers table.
SELECT * 
	FROM purchases
	INNER JOIN customers ON customers.id = purchases.customer_id;

	-- 3) Purchases of the customer with the ID equal to 5.
SELECT * 
	FROM purchases
	INNER JOIN customers ON customers.id = purchases.customer_id
	WHERE customers.id = 5;

	-- 4) Purchases for a large desk AND a small desk
SELECT * 
	FROM purchases
	INNER JOIN items ON items.id = purchases.item_id
	WHERE items.libelle = 'Large Desk' OR items.libelle = 'Small Desk';

/*
	2) Use SQL to show all the customers who have made a purchase. Show the following fields/columns:
		Customer first name
		Customer last name
		Item name
*/
SELECT customers.prenom, customers.nom, items.libelle
	FROM customers
	INNER JOIN purchases ON purchases.customer_id = customers.id
	INNER JOIN items ON items.id = purchases.item_id

/*
	3) Add a row which references a customer by ID, but does not reference 
	an item by ID (leave it blank). Does this work? Why/why not?
*/
INSERT INTO purchases(customer_id, item_id, quantity_purchased)
	VALUES(1,,5);
-- Reponse requete
/* ERREUR:  erreur de syntaxe sur ou près de « , »
LINE 2: VALUES(1,,5) ^ */