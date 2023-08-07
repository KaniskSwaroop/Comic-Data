drop database Excelsior_comic_test;
create database Excelsior_comic_test;
/**------------- POINTS TO BE CORRECTED
	-NM is the best possible condition for a back issue
    
    -the comics table should not contain fair, fine and other columns
		there should be another table that should contain
		the prices mapped to comic id and its condition.
        Later -> can create a view and make a join on comic id
        
	-Need to make adjustments where the price of the comics are null
    
    -in the update_inventory_after_order -> cannot go below 0 in inventory count 
		whenever an update is made in the trigger, then drop the trigger, create the trigger again by 
		running the create trigger query
	- before inserting an order in the orders table -> check if stock is left for that particular comic
    
    - in the procedure -> currently giving different comic with same condition -> can also give same comic with different condition
     
     - add the forign key relation
     - update inventory -> set on date to NOW() for the comic purchased
**/
use Excelsior_comic_test;
# Need table for the issues
# decide if separate tables are needed for old issues
# need to have a table for mapping numeric and symbolic comic conditions
# need to create a customer database for mappin customer tables 
# for maintining purchase history
# in stock comics
# entire database of comics
# need to maintain the stock count of a particular comic
# in each condition
# need to have one table each for the different comic conditions
# used for mapping th quatity of that constion left for a particular comic



## Addtional 
# customer cart
# managing FAQs
# comic is a part of personal collection of somebody popular
# then high price
# Near mint issue 1 of an old comic -> extremely high price
# SCHEDULE AND AUTO STOCKING OF THE COMICS -> RANDOM COMIC ID, 2 RANDOM CONDITION -> STOCK AFTER EVERY 12 HOURS
# ALLOW SOMEBODY TO SELL A COMIC TO EXCELSIOR -> ADD TO INVENTORY
	# CAN BUILD A NEW TABLE FOR HANDLING RE-SELL SECTION
# NEED AN EVENT FOR CREATING ORDER AUTOMATICALLY

## Table structures
/** ----------- Orders ----------- **/
# order_id	customer_id	customer_name	customer_age	
# comic_id	comic_title	issue_number	genre	is_elite_comic	
# comic_condition	price_of_purchase	date_of_purchase
# Will create index on customer_id
# auto increment on order_id

/** ---------- Customers ----------- **/
# customer_id	customer_name	customer_age	order_count
#	is_elite_customer
# auto increment on customer_id

/** ---------- Comics ------------- **/
# will need PL/SQL for updating is_classic column
# will need PL/SQL for updating is_part_of_collection column
# if any of the above is true then increment price
# comic_id	comic_title	issue_number	year	genre	
# fair	good	very_good	fine	very_fine	near_mint
# mint	is_elite	is_classic	is_part_of_collection


# if customer is elite then write PL/SQL to reduce price or 
# give some offers

/** -------------  CHECK NORMAL FORMS ---------- **/

# orders table only needs comic_id and no other detail of a comic
CREATE TABLE orders (
	`order_id` int NOT NULL AUTO_INCREMENT,
    `customer_id` int NOT NULL,
    `comic_id`int NOT NULL,
    `comic_condition`varchar(10),
    `price_of_purchase` float ,
	`date_of_purchase` date,
    PRIMARY KEY (`order_id`)
);

CREATE TABLE customers (
	`customer_id` int NOT NULL AUTO_INCREMENT,
    `customer_name` varchar(255),
    `customer_age`int,
    `order_count`int, # number of orders that customer has placed till date
	`is_elite_customer` boolean NOT NULL,
    PRIMARY KEY (`customer_id`)
);

CREATE TABLE comics (
	`comic_id`int NOT NULL AUTO_INCREMENT,
    `comic_title` varchar(255) NOT NULL,
    `issue_number`int NOT NULL,
    `year` int NOT NULL,
	`genre` varchar(255) NOT NULL,
    `fair` float,
    `good`float,
    `very_good`float,
    `fine`float,
    `very_fine`float,
    `near_mint`float,
    `mint`float,
    `is_elite_comic`boolean NOT NULL,
	`is_back_issue` boolean NOT NULL,
    `is_part_of_collection` boolean NOT NULL,
     PRIMARY KEY (`comic_id`)
);

CREATE TABLE comic_condition_to_price_map (
	`id` int NOT NULL AUTO_INCREMENT,
    `comic_id` int NOT NULL,
    `comic_condition` varchar(50) NOT NULL,
    `price` float,
    PRIMARY KEY (id)
);

CREATE TABLE inventory (
	`id` int NOT NULL AUTO_INCREMENT,
    `comic_id` int NOT NULL,
    `fair_stock` int NOT NULL,
    `good_stock` int NOT NULL,
    `very_good_stock` int NOT NULL,
    `fine_stock` int NOT NULL,
    `very_fine_stock` int NOT NULL,
    `near_mint_stock` int NOT NULL,
    `mint_stock` int NOT NULL,
    `on_date` date,
	 PRIMARY KEY (`id`)
);

CREATE TABLE comic_grade_map (
    `comic_grade` varchar(10) NOT NULL,
    `comic_score_lower` float NOT NULL,
    `comic_score_upper` float NOT NULL,
    PRIMARY KEY (`comic_grade`)
);

CREATE TABLE comic_condition (
	`comic_condition_id` int NOT NULL AUTO_INCREMENT,
    `comic_condition` varchar(50) NOT NULL,
    PRIMARY KEY (`comic_condition_id`)
);
/** Inserting values into comics**/
INSERT INTO comics (
    `comic_title` ,
    `issue_number`,
    `year`,
	`genre` ,
    `fair` ,
    `good`,
    `very_good`,
    `fine`,
    `very_fine`,
    `near_mint`,
    `mint`,
    `is_elite_comic`,
	`is_back_issue`,
    `is_part_of_collection`
    
) VALUES
("Superman","2","2023","Superhero","21","42","63","105","158","210","300","0","1","0"),
("Superman","1","2023","Superhero","3","4.25","6.5","10.5","15.75","21","35","0","1","0"),
("X-men red","1","2022","Superhero","4.5","8.75","13.25","22","33","44","60.5","0","1","0"),
("X-men red","2","2022","Superhero","3","5.25","8","13.25","20","27","32","0","1","0"),
("X-men red","3","2022","Superhero","3","5.25","8","13.25","20","27","38","0","1","0"),
("Batbear","1","2015","Superhero","7","14","21","35","53","70","150","1","1","0"),
("Fantastic Four","1","1961","Superhero","22750","45500","91000","54456","60000","110000","250000","1","1","0"),
("Music Comics Vol 1: Nirvana","1","1992","Biography & Memoirs, Music","17.5","35","53","88","132","175","250.75","0","1","0"),
("Rick & Morty: RickMobile Special Edition","1","2018","Vampire",null,null,null,null,null,"400",null,"1","0","0"),
("Tiger Division","2","2022","Superhero","3","4.25","6.5","10.5","15.75","21","50","0","0","0"),
("Avengers","1","1963","Superhero","13000","26000","52000","73125",null,null,null,"1","0","1"),
("Avengers","2","1963","Superhero","884","1768","3536","4973","8288",null,null,"0","0","0"),
("Avengers","3","1963","Superhero","780","1560","3120","4388",null,null,null,"0","0","1"),
("Avengers","330","1963","Superhero","3","5.25","10.5","14.75","23.25","30","49.5","0","0","0"),
("Avengers","331","1963","Superhero","3","5.25","10.5","14.75","23.25","30",null,"0","0","0"),
("Avengers","332","1963","Superhero","5.25","10.5","21","30","46","65","90","0","0","0"),
("Batman Detective comics","27","1937","Superhero",null,"4","5","6","7","8","15","0","1","0"),
("Detective Comics","10","1937","Superhero","1125","2249","4914","7722",null,null,null,"1","0","0"),
("Batman Detective comics","0","1937","Superhero","3","4","5","8.5","12","15","19","0","1","0"),
("Detective Comics","45","1937","Superhero","696","1937","4232","6650",null,null,null,"0","0","1"),
("Detective Comics","46","1937","Superhero","1248","2496","5460","8580",null,null,null,"1","1","0"),
("Daredevil: Man Without Fear","1","1964","Superhero","6500","13000","26000","36563","60938",null,null,"0","0","0"),
("Quick Stops","1","2022","Superhero","3","4.25","6.5","10.5","15.75","21","30","0","1","0"),
("Quick Stops","4","2022","Superhero","3","5.25","8","13.25","20","27","45","0","1","0"),
("World of Zorro","1","2021","Superhero",null,null,null,null,null,"5","10","0","1","0"),
("X-MEN","1","1963","Superhero","20800","41600","83200","11700","200000",null,null,"1","1","0"),
("X-MEN","3","1963","Superhero","780","1560","3120","4420",null,null,null,"0","0","0"),
("X-MEN","524","1963","Superhero","17.5","35","53","88","132","175","250","0","1","0"),
("X-MEN","527","1963","Superhero","3.5","7","10.5","16.5","26","34","47","0","1","0"),
("Rogues' Gallery","1","2022","Comedy","3","5.25","8","13.25","20","27","40","0","0","0"),
("Rogues' Gallery","3","2022","Comedy","3","5.25","8","13.25","20","27","40","0","0","0"),
("Absolute Sandman Special Edition","1","2006","Superhero","3","4","5","7","10.5","14","18","1","0","0"),
("Trapped (Columbia Universe Press)","1","1951","Drama","32","63","137","215","312","390",null,"0","1","0"),
("Art Brut","1","2022","police procedural, hyper-fantasy, and psychological thriller","3.5","7","10.5","17.5","27","35","56","0","0","0"),
("Art Brut","2","2022","police procedural, hyper-fantasy, and psychological thriller","3","5.25","8","13.25","20","27","45","0","0","0"),
("Art Brut","3","2022","police procedural, hyper-fantasy, and psychological thriller","3","5.25","8","13.25","20","27","45","0","0","0"),
("X: Lives Of Wolverine","1","2022","Superhero","3.5","7","10.5","17.5","27","35",null,"0","0","0"),
("X: Lives Of Wolverine","2","2022","Superhero","3","5.25","8","13.25","20","27",null,"0","0","0"),
("Closet","1","2022","Horror","10.5","21","32","53","79","105","150","0","1","0"),
("Heart Eyes","1","2022","supernatural drama and mystery","3","4.25","6.5","10.5","15.75","21","35","0","0","0"),
("All Out Pooh","0","2021","Fiction",null,null,null,null,null,"250",null,"1","0","0"),
("Legacy Of Violence","1","2022","Thriller","3","5.25","8","13.25","20","27","33","0","1","0"),
("Legacy Of Violence","2","2022","Thriller","3","5.25","8","13.25","20","27","33","0","1","0"),
("Legacy Of Violence","3","2022","Thriller","3","5.25","8","13.25","20","27","33","0","1","0"),
("Legacy Of Violence","4","2022","Thriller","3","5.25","8","13.25","20","27","33","0","1","0"),
("United States Of Captain America","1","2021","Superhero","3.5","7","10.5","17.5","27","35","52","0","0","1"),
("Invisible City","1","1999","Horror","10.5","21","32","53","79","105","140","0","0","0"),
("Teen Titans GO/DC Super Girls Giant","1","2020","Superhero","3.5","7","10.5","14","27","35","50","0","0","0"),
("King Conan","1","2021","Superhero","3.5","7","10.5","17.5","27","35","45","0","1","0")
;
select * from comics;

/** Inserting values into customers **/
INSERT INTO customers (
    `customer_name`,
    `customer_age`,
    `order_count`,
	`is_elite_customer`
)
VALUES 
("Kanisk Swaroop","25","0","0"),
("Jagrithi","24","0","0"),
("Prakhar","24","0","0"),
("Ayushi","26","0","0"),
("Jake","39","0","0"),
("Mich Clarke","11","0","0"),
("Ciara Jones","43","0","0"),
("Robert","57","0","0"),
("Kunal Jaiswal","19","0","0"),
("Ruth Shields","49","0","0"),
("Patel","30","0","0"),
("Sangeeta sri","55","0","0"),
("Rajeev Ranjan","61","0","0"),
("Manoj Kumar","23","0","0"),
("Nilima Singh","29","0","0"),
("Arundhathi Kumar","12","0","0"),
("Joe Carry","27","0","0"),
("Christina Morgan","21","0","0"),
("Ross","42","0","0"),
("Susan Bing","33","0","0")
;
select * from customers;

INSERT INTO inventory (
    `comic_id`,
    `fair_stock`,
    `good_stock`,
    `very_good_stock`,
    `fine_stock`,
    `very_fine_stock`,
    `near_mint_stock`,
    `mint_stock`,
    `on_date`
)
VALUES
("1","5","4","2","6","10","6","2","2023-01-01"),
("2","2","9","7","9","2","4","9","2023-01-01"),
("3","9","4","7","2","6","8","0","2023-01-01"),
("4","4","7","1","8","10","2","0","2023-01-01"),
("5","10","3","3","0","5","1","0","2023-01-01"),
("6","3","7","3","4","10","0","0","2023-01-01"),
("7","0","2","9","9","6","0","0","2023-01-01"),
("8","8","3","4","6","5","4","0","2023-01-01"),
("9","2","2","2","3","2","6","9","2023-01-01"),
("10","0","7","7","8","7","0","0","2023-01-01"),
("11","5","9","7","4","2","9","0","2023-01-01"),
("12","7","2","1","2","5","2","0","2023-01-01"),
("13","4","5","2","4","1","9","0","2023-01-01"),
("14","12","5","2","0","9","0","0","2023-01-01"),
("15","6","7","1","1","5","5","0","2023-01-01"),
("16","0","9","8","8","1","7","8","2023-01-01"),
("17","1","1","6","7","2","6","7","2023-01-01"),
("18","5","5","9","5","8","8","9","2023-01-01"),
("19","2","3","1","7","10","8","4","2023-01-01"),
("20","1","8","1","9","1","7","0","2023-01-01"),
("21","6","7","5","2","1","5","0","2023-01-01"),
("22","3","10","6","3","7","3","7","2023-01-01"),
("23","8","2","3","1","5","4","0","2023-01-01"),
("24","2","5","6","4","7","7","0","2023-01-01"),
("25","1","2","4","9","10","5","0","2023-01-01"),
("26","0","9","9","5","8","2","0","2023-01-01"),
("27","0","8","9","0","7","7","2","2023-01-01"),
("28","0","9","7","1","6","0","0","2023-01-01"),
("29","0","3","5","6","4","4","0","2023-01-01"),
("30","5","2","10","6","1","4","0","2023-01-01"),
("31","7","6","9","2","4","5","0","2023-01-01"),
("32","2","9","8","0","1","9","0","2023-01-01"),
("33","6","5","7","4","3","8","0","2023-01-01"),
("34","5","8","4","0","4","8","0","2023-01-01"),
("35","6","4","6","5","3","8","0","2023-01-01"),
("36","6","7","6","1","10","2","0","2023-01-01"),
("37","3","10","9","7","6","1","5","2023-01-01"),
("38","9","9","8","1","10","7","2","2023-01-01"),
("39","8","4","3","7","10","2","5","2023-01-01"),
("40","3","6","9","2","2","3","7","2023-01-01"),
("41","8","8","6","9","3","1","3","2023-01-01"),
("42","7","1","6","8","4","1","0","2023-01-01"),
("43","2","10","1","4","7","5","0","2023-01-01"),
("44","1","5","6","9","9","6","0","2023-01-01"),
("45","1","1","7","3","6","0","0","2023-01-01"),
("46","11","2","10","8","10","3","0","2023-01-01"),
("47","7","7","8","0","6","1","0","2023-01-01"),
("48","2","4","7","3","2","6","0","2023-01-01"),
("49","5","1","10","0","1","1","5","2023-01-01")
;
select * from inventory;

INSERT INTO comic_condition_to_price_map (
	`comic_id`,
    `comic_condition`,
    `price`
) VALUES 
(1,"fair",21),
(1,"good",42),
(1,"very good",63),
(1,"fine",105),
(1,"very fine",158),
(1,"near mint",210),
(2,"fair",3),
(2,"good",4.25),
(2,"very good",6.5),
(2,"fine",10.5),
(2,"very fine",15.75),
(2,"near mint",21),
(3,"fair",4.5),
(3,"good",8.75),
(3,"very good",13.25),
(3,"fine",22),
(3,"very fine",33),
(3,"near mint",44),
(4,"fair",3),
(4,"good",5.25),
(4,"very good",8),
(4,"fine",13.25),
(4,"very fine",20),
(4,"near mint",27),
(5,"fair",3),
(5,"good",5.25),
(5,"very good",8),
(5,"fine",13.25),
(5,"very fine",20),
(5,"near mint",27),
(6,"fair",7),
(6,"good",14),
(6,"very good",21),
(6,"fine",35),
(6,"very fine",53),
(6,"near mint",70),
(7,"fair",22750),
(7,"good",45500),
(7,"very good",91000),
(7,"fine",54456),
(7,"very fine",60000),
(7,"near mint",110000),
(8,"fair",17.5),
(8,"good",35),
(8,"very good",53),
(8,"fine",88),
(8,"very fine",132),
(8,"near mint",175),
(9,"fair",null),
(9,"good",null),
(9,"very good",null),
(9,"fine",null),
(9,"very fine",null),
(9,"near mint",400),
(10,"fair",3),
(10,"good",4.25),
(10,"very good",6.5),
(10,"fine",10.5),
(10,"very fine",15.75),
(10,"near mint",21),
(11,"fair",13000),
(11,"good",26000),
(11,"very good",52000),
(11,"fine",73125),
(11,"very fine",null),
(11,"near mint",null),
(12,"fair",884),
(12,"good",1768),
(12,"very good",3536),
(12,"fine",4973),
(12,"very fine",8288),
(12,"near mint",null),
(13,"fair",780),
(13,"good",1560),
(13,"very good",3120),
(13,"fine",4388),
(13,"very fine",null),
(13,"near mint",null),
(14,"fair",3),
(14,"good",5.25),
(14,"very good",10.5),
(14,"fine",14.75),
(14,"very fine",23.25),
(14,"near mint",30),
(15,"fair",3),
(15,"good",5.25),
(15,"very good",10.5),
(15,"fine",14.75),
(15,"very fine",23.25),
(15,"near mint",30),
(16,"fair",5.25),
(16,"good",10.5),
(16,"very good",21),
(16,"fine",30),
(16,"very fine",46),
(16,"near mint",65),
(17,"fair",null),
(17,"good",4),
(17,"very good",5),
(17,"fine",6),
(17,"very fine",7),
(17,"near mint",8),
(18,"fair",1125),
(18,"good",2249),
(18,"very good",4914),
(18,"fine",7722),
(18,"very fine",null),
(18,"near mint",null),
(19,"fair",3),
(19,"good",4),
(19,"very good",5),
(19,"fine",8.5),
(19,"very fine",12),
(19,"near mint",15),
(20,"fair",696),
(20,"good",1937),
(20,"very good",4232),
(20,"fine",6650),
(20,"very fine",null),
(20,"near mint",null),
(21,"fair",1248),
(21,"good",2496),
(21,"very good",5460),
(21,"fine",8580),
(21,"very fine",null),
(21,"near mint",null),
(22,"fair",6500),
(22,"good",13000),
(22,"very good",26000),
(22,"fine",36563),
(22,"very fine",60938),
(22,"near mint",null),
(23,"fair",3),
(23,"good",4.25),
(23,"very good",6.5),
(23,"fine",10.5),
(23,"very fine",15.75),
(23,"near mint",21),
(24,"fair",3),
(24,"good",5.25),
(24,"very good",8),
(24,"fine",13.25),
(24,"very fine",20),
(24,"near mint",27),
(25,"fair",null),
(25,"good",null),
(25,"very good",null),
(25,"fine",null),
(25,"very fine",null),
(25,"near mint",5),
(26,"fair",2800),
(26,"good",41600),
(26,"very good",83200),
(26,"fine",11700),
(26,"very fine",200000),
(26,"near mint",null),
(27,"fair",780),
(27,"good",1560),
(27,"very good",3120),
(27,"fine",4420),
(27,"very fine",null),
(27,"near mint",null),
(28,"fair",17.5),
(28,"good",35),
(28,"very good",53),
(28,"fine",88),
(28,"very fine",132),
(28,"near mint",175),
(29,"fair",3.5),
(29,"good",7),
(29,"very good",10.5),
(29,"fine",16.5),
(29,"very fine",26),
(29,"near mint",34),
(30,"fair",3),
(30,"good",5.25),
(30,"very good",8),
(30,"fine",13.25),
(30,"very fine",20),
(30,"near mint",27),
(31,"fair",3),
(31,"good",5.25),
(31,"very good",8),
(31,"fine",13.25),
(31,"very fine",20),
(31,"near mint",27),
(32,"fair",3),
(32,"good",4),
(32,"very good",5),
(32,"fine",7),
(32,"very fine",10.5),
(32,"near mint",14),
(33,"fair",32),
(33,"good",63),
(33,"very good",137),
(33,"fine",215),
(33,"very fine",312),
(33,"near mint",390),
(34,"fair",3.5),
(34,"good",7),
(34,"very good",10.5),
(34,"fine",17.5),
(34,"very fine",27),
(34,"near mint",35),
(35,"fair",3),
(35,"good",5.25),
(35,"very good",8),
(35,"fine",13.25),
(35,"very fine",20),
(35,"near mint",27),
(36,"fair",3),
(36,"good",5.25),
(36,"very good",8),
(36,"fine",13.25),
(36,"very fine",20),
(36,"near mint",27),
(37,"fair",3.5),
(37,"good",7),
(37,"very good",10.5),
(37,"fine",17.5),
(37,"very fine",27),
(37,"near mint",35),
(38,"fair",3),
(38,"good",5.25),
(38,"very good",8),
(38,"fine",13.25),
(38,"very fine",20),
(38,"near mint",27),
(39,"fair",10.5),
(39,"good",21),
(39,"very good",32),
(39,"fine",53),
(39,"very fine",79),
(39,"near mint",105),
(40,"fair",3),
(40,"good",4.25),
(40,"very good",6.5),
(40,"fine",10.5),
(40,"very fine",15.75),
(40,"near mint",21),
(41,"fair",null),
(41,"good",null),
(41,"very good",null),
(41,"fine",null),
(41,"very fine",null),
(41,"near mint",250),
(42,"fair",3),
(42,"good",5.25),
(42,"very good",8),
(42,"fine",13.25),
(42,"very fine",20),
(42,"near mint",27),
(43,"fair",3),
(43,"good",5.25),
(43,"very good",8),
(43,"fine",13.25),
(43,"very fine",20),
(43,"near mint",27),
(44,"fair",3),
(44,"good",5.25),
(44,"very good",8),
(44,"fine",13.25),
(44,"very fine",20),
(44,"near mint",27),
(45,"fair",3.5),
(45,"good",5.25),
(45,"very good",8),
(45,"fine",13.25),
(45,"very fine",20),
(45,"near mint",27),
(46,"fair",3.5),
(46,"good",7),
(46,"very good",10.5),
(46,"fine",17.5),
(46,"very fine",27),
(46,"near mint",35),
(47,"fair",10.5),
(47,"good",21),
(47,"very good",32),
(47,"fine",53),
(47,"very fine",79),
(47,"near mint",105),
(48,"fair",3.5),
(48,"good",7),
(48,"very good",10.5),
(48,"fine",14),
(48,"very fine",27),
(48,"near mint",35),
(49,"fair",3.5),
(49,"good",7),
(49,"very good",10.5),
(49,"fine",17.5),
(49,"very fine",27),
(49,"near mint",35)
;
select * from comic_condition_to_price_map;

INSERT INTO comic_grade_map (
	`comic_grade`,
	`comic_score_lower`,
    `comic_score_upper`
) VALUES
("MT",10,10),
("NM",9.5,9.9),
("VF",8.0,9.4),
("FN",6.0,7.9),
("VG",4.0,5.9),
("GD",2.2,3.9),
("FR",1.0,2.1),
("PR",0.5,0.9)
;
select * from comic_grade_map;
desc comics;
INSERT INTO comic_condition (
	`comic_condition`
) VALUES
("fair"),
("good"),
("very_good"),
("fine"),
("very_fine"),
("near_mint"),
("poor")
;
select * from comic_condition;

/** -----------------VIEWS -------------------*/
# 1) view for creating an order in orders using the RAND() query
# 2) view for giving the top 5 best selling comics
# 3) view for giving the top 5 most active customers -> not required -> can directly do from customers tables
# 4) view for analysing the order values
# 5) view for mapping customer affinity towards genre / comic
# 6) view to identify the genre that is the most selling and what % of it occupies the market
# 7) 
/* 1) creating an order in orders using the RAND() query*/
select * from customers;
select * from comics;
desc comics;
desc orders;
/** view for mapping comics with comic_condition_to_price_map . Helps in getting price for a random order **/
CREATE VIEW comic_condition_price as
select 
c.comic_id,
c.comic_title,
c.issue_number,
c.year,
c.genre,
c_map.comic_condition,
c_map.price
from comics as c
JOIN comic_condition_to_price_map c_map
ON c.comic_id = c_map.comic_id;
select * from comic_condition_price;



/** view for mapping customer affinity towards genre / comic **/
/** what percentage of purchase whas that particular comic **/
# orders -> comic id and customer id
# comics -> comic id and genre
CREATE VIEW customer_affinity_to_genre AS
SELECT 
o.customer_id AS customer_id,
c.genre AS genre,
100*((SELECT count(o1.order_id) FROM orders o1 JOIN comics c1
ON o1.comic_id = c1.comic_id WHERE o1.customer_id = o.customer_id AND c1.genre = c.genre
GROUP BY c1.genre, o1.customer_id)/(SELECT count(o2.order_id) from orders o2 JOIN comics c2
ON o2.comic_id = c2.comic_id WHERE o2.customer_id = o.customer_id))
AS percentage
FROM orders o 
JOIN comics c 
ON c.comic_id= o.comic_id
group by customer_id,genre;

select * from customer_affinity_to_genre;
/** view to identify the genre that is the most selling and what % of it occupies the market **/
# comic -> comic id , genre
# orders -> comic id
CREATE VIEW genre_demand_analysis AS
select 
c.genre,
count(c.genre) sold,
100*((select count(o1.order_id) from orders o1 JOIN comics c1
ON o1.comic_id = c1.comic_id WHERE c1.genre = c.genre )/
(select count(order_id) from orders))  as market_occupied
from comics c join orders o
on c.comic_id = o.comic_id
group by c.genre;

select * from genre_demand_analysis;
select * from comics;
/** view for getting the purchase history of a customer **/
select * from comics;
CREATE VIEW customer_purchase_history AS
select 
c.customer_id as customer_id,
c.customer_name as customer_name,
o.order_id as order_id,
o.comic_id as comic_id,
(select comic_title from comics where comic_id = o.comic_id ) as title,
(select issue_number from comics where comic_id = o.comic_id ) as issue
from customers c join orders o
on c.customer_id = o.customer_id
group by c.customer_id, o.order_id, o.comic_id;
select * from inventory;
select * from customer_purchase_history;

/** creating orders by selecting random customer IDs from the customers table
	selecting random comic id from the comics table
    getting a random comic condition from comic_condition table
    getting the price from the comic_condition_price view that joins the comics and the comic_condition_to_price_map tables
    on the grounds of comic_id. This gives the price of comic
**/
SET @r_customer_id := (SELECT customer_id FROM customers ORDER BY RAND() limit 1);
SET @r_comic_id := (SELECT comic_id FROM comics ORDER BY RAND() limit 1);
SET @r_comic_cond := (SELECT comic_condition FROM comic_condition ORDER BY RAND() limit 1);
SET @price_of_purchase := (select price from comic_condition_price where comic_id = @r_comic_id AND comic_condition = @r_comic_cond);
SET @date_of_purchase := NOW();

/** Procedure for reducing the price for elite customer **/
DELIMITER $$
CREATE PROCEDURE price_reduction_for_elite_customer()
BEGIN
	SET @customer_elite_status := (SELECT is_elite_customer from customers WHERE customer_id = @r_customer_id);
    IF @customer_elite_status = 1 THEN
		SET @price_of_purchase = @price_of_purchase - @price_of_purchase/10;
        select "Discount applied" AS message;
	END IF;
END$$
DELIMITER ; 
CALL price_reduction_for_elite_customer;
desc orders;
select * from orders;
select @r_customer_id;
select @r_comic_cond as message;
select @price_of_purchase as message;
select * from orders;
#INSERT INTO orders 
#VALUES(34,@r_customer_id, @r_comic_id, @r_comic_cond, @price_of_purchase,@date_of_purchase);
select * from comics;


# PROCEDURE for checking for the condition of no stock of a particular comic in a particular condition
DELIMITER $$
CREATE PROCEDURE check_for_no_stock()
BEGIN
	SET @r_stock_count := (SELECT CASE @r_comic_cond 
                            WHEN "fair" THEN fair_stock
                            WHEN "good" THEN good_stock
                            WHEN "very good" THEN very_good_stock
                            WHEN "fine" THEN fine_stock
                            WHEN "very fine" THEN very_fine_stock
                            WHEN "near mint" THEN near_mint_stock
                            END
                            as comic_condition_stock
                        from inventory where comic_id = @r_comic_id);
	IF @r_stock_count <=0 THEN
		WHILE @r_stock_count <=0 DO
			SET @r_comic_id := (SELECT comic_id FROM comics ORDER BY RAND() limit 1);
            SET @r_stock_count := (SELECT CASE @r_comic_cond 
				WHEN "fair" THEN fair_stock
				WHEN "good" THEN good_stock
				WHEN "very good" THEN very_good_stock
				WHEN "fine" THEN fine_stock
				WHEN "very fine" THEN very_fine_stock
				WHEN "near mint" THEN near_mint_stock
			END
		from inventory where comic_id = @r_comic_id);
        END WHILE;
	END IF;
    select @r_stock_count as message;
END$$
DELIMITER ;
call check_for_no_stock;
select 	* from orders;
INSERT INTO orders VALUES(36,@r_customer_id,@r_comic_id,@r_comic_cond,@price_of_purchase,@date_of_purchase);
select * from orders;
desc orders;
select * from comics;
#drop procedure prevent_negative_inventory;
#CALL prevent_negative_inventory();
select * from orders;
select * from inventory;
 /** ERROR -> because while loop cannot be declared 
 outside function or procedure **/

/** Trigger  for checking stock before plaing an order **/

/*-------------------PL/SQL AND other code-------------------*/
## --------------SELECT * FROM my_table ORDER BY RAND() LIMIT 10 ----------;
# above query -> VVI -> will help in selecting a random customer
# and create an order
## need to create a trigger for entering orders in the orders table
## need to schedule and event for re-stocking the inventory
## a schedule event can also be used for creating orders
## insert and order and update the inventory with a decrease in count


/** updating customer order count after every order **/
CREATE TRIGGER customer_order_count
AFTER INSERT ON orders
FOR EACH ROW
	UPDATE customers SET order_count = order_count + 1 
    WHERE customer_id = ( SELECT customer_id FROM orders
    ORDER BY order_id DESC LIMIT 1 );
select * from customers;

/** when a customer's order count > 5 , updating is_elite_customer to 1**/
CREATE TRIGGER customer_elite_status
AFTER INSERT ON orders
FOR EACH ROW
	UPDATE customers SET is_elite_customer = 1
    WHERE order_count >=5;
select * from customers;
select * from orders;
select * from inventory;
select * from comics;

/** Trigger for updating the stock after order creation**/
CREATE TRIGGER update_inventory_after_order 
AFTER INSERT ON orders
FOR EACH ROW
    UPDATE inventory 
    SET 
        fair_stock = CASE (select comic_condition from orders order by order_id desc limit 1) WHEN "fair" THEN fair_stock - 1 ELSE fair_stock END,
        good_stock = CASE (select comic_condition from orders order by order_id desc limit 1) WHEN "good" THEN good_stock - 1 ELSE good_stock END,
        very_good_stock = CASE (select comic_condition from orders order by order_id desc limit 1) WHEN "very good" THEN very_good_stock - 1 ELSE very_good_stock END,
        fine_stock = CASE (select comic_condition from orders order by order_id desc limit 1) WHEN "fine" THEN fine_stock - 1 ELSE fine_stock END,
        very_fine_stock = CASE (select comic_condition from orders order by order_id desc limit 1) WHEN "very fine" THEN very_fine_stock - 1 ELSE very_fine_stock END,
        near_mint_stock = CASE (select comic_condition from orders order by order_id desc limit 1) WHEN "near mint" THEN near_mint_stock - 1 ELSE near_mint_stock END,
        mint_stock = CASE (select comic_condition from orders order by order_id desc limit 1) WHEN "mint" THEN mint_stock - 1 ELSE mint_stock END
    WHERE comic_id = (select comic_id from orders ORDER BY order_id
    desc limit 1);
show triggers from Excelsior_comic_test ;
DESC orders;
desc inventory;
SHOW TRIGGERS WHERE `Trigger` = 'update_inventory_after_order';

/** ----------------- SCHEDULED EVENTS ------------------------- **/
show tables;
select * from comic_condition;
/** scheduler for adding stock in two randomly selected comic _id with 2 randomly selected comic conditions **/
CREATE EVENT add_stock
	ON SCHEDULE EVERY 6 HOUR STARTS NOW()
    DO
		SET @random_comic_id_1 := (SELECT comic_id from comics ORDER BY RAND() limit 1);
        SET @random_comic_id_2 := (SELECT comic_id from comics ORDER BY RAND() limit 1);
        SET @random_comic_condition_1 := (SELECT comic_condition from comics ORDER BY RAND() limit 1);
        SET @random_comic_condition_2 := (SELECT comic_condition from comics ORDER BY RAND() limit 1);
        UPDATE inventory
			SET 
				fair_stock = CASE (select comic_condition from comic_conditions WHERE comic_condition = @random_comic_condition_1) WHEN "fair" THEN fair_stock + 1 ELSE fair_stock END,
				good_stock = CASE (select comic_condition from comic_conditions WHERE comic_condition = @random_comic_condition_1) WHEN "good" THEN good_stock + 1 ELSE good_stock END,
				very_good_stock = CASE (select comic_condition from comic_conditions WHERE comic_condition = @random_comic_condition_1) WHEN "very good" THEN very_good_stock + 1 ELSE very_good_stock END,
				fine_stock = CASE (select comic_condition from comic_conditions WHERE comic_condition = @random_comic_condition_1) WHEN "fine" THEN fine_stock + 1 ELSE fine_stock END,
				very_fine_stock = CASE (select comic_condition from comic_conditions WHERE comic_condition = @random_comic_condition_1) WHEN "very fine" THEN very_fine_stock + 1 ELSE very_fine_stock END,
				near_mint_stock = CASE (select comic_condition from comic_conditions WHERE comic_condition = @random_comic_condition_1) WHEN "near mint" THEN near_mint_stock + 1 ELSE near_mint_stock END,
				mint_stock = CASE (select comic_condition from comic_conditions WHERE comic_condition = @random_comic_condition_1) WHEN "mint" THEN mint_stock + 1 ELSE mint_stock END
                ,
                fair_stock = CASE (select comic_condition from comic_conditions WHERE comic_condition = @random_comic_condition_2) WHEN "fair" THEN fair_stock + 1 ELSE fair_stock END,
				good_stock = CASE (select comic_condition from comic_conditions WHERE comic_condition = @random_comic_condition_2) WHEN "good" THEN good_stock + 1 ELSE good_stock END,
				very_good_stock = CASE (select comic_condition from comic_conditions WHERE comic_condition = @random_comic_condition_2) WHEN "very good" THEN very_good_stock + 1 ELSE very_good_stock END,
				fine_stock = CASE (select comic_condition from comic_conditions WHERE comic_condition = @random_comic_condition_2) WHEN "fine" THEN fine_stock + 1 ELSE fine_stock END,
				very_fine_stock = CASE (select comic_condition from comic_conditions WHERE comic_condition = @random_comic_condition_2) WHEN "very fine" THEN very_fine_stock + 1 ELSE very_fine_stock END,
				near_mint_stock = CASE (select comic_condition from comic_conditions WHERE comic_condition = @random_comic_condition_2) WHEN "near mint" THEN near_mint_stock + 1 ELSE near_mint_stock END,
				mint_stock = CASE (select comic_condition from comic_conditions WHERE comic_condition = @random_comic_condition_2) WHEN "mint" THEN mint_stock + 1 ELSE mint_stock END
			WHERE comic_id IN ( @random_comic_id_1 , @random_comic_id_2 );

/** EVENT FOR PLACING ORDERS PERIODICALLY **/
/** CREATES AN ORDER EVERY 15 MINUTES **/
select * from orders;
CREATE EVENT new_order_generation
	ON SCHEDULE EVERY 15 MINUTE STARTS NOW()
    DO
		SET @create_order_id := (SELECT COUNT(order_id) FROM orders);
        SET @create_order_id = @create_order_id + 1;
		SET @r_customer_id := (SELECT customer_id FROM customers ORDER BY RAND() limit 1);
		SET @r_comic_id := (SELECT comic_id FROM comics ORDER BY RAND() limit 1);
        SET @r_comic_cond := (SELECT comic_condition from comic_condition ORDER BY RAND() limit 1);
        SET @price_of_purchase := (select price from comic_condition_price where comic_id = @r_comic_id AND comic_condition = @r_comic_cond);
        CALL price_reduction_for_elite_customer;
        SET @date_of_purchase := NOW();
        CALL check_for_no_stock;
        INSERT INTO orders VALUES(@create_order_id, @r_customer_id, @r_comic_id, @r_comic_cond, @price_of_purchase, @date_pf_purchase);
        
        
show tables;
select * from comic_condition;
select * from comic_grade_map;	
desc comic_grade_map;
select * from comics;		



