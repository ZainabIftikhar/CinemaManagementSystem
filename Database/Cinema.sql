

	create table Member
	(
	MemberID int Identity(1,1) PRIMARY KEY, 
	-- auto increment should be there
	FirstName varchar(50) NOT NULL,
	LastName varchar(50) NOT NULL,
	CNIC char(13) NOT NULL,
	--CNIC has to be of 13 digits
	CreditCard char(16) NOT NULL,
	--Credit Card has to be of 19 digits
	Email varchar(50) NOT NULL,
	Contact char(11) NULL,
	--User can have no contact number
	Username varchar(20) NOT NULL,
	Password varchar (20) NOT NULL,
	UserType bit NOT NULL,
	--0 if member, 1 if admin
	MemberStatus bit NOT NULL,
	--0 if blocked, 1 if active

	CONSTRAINT unique_email UNIQUE(Email),
	CONSTRAINT unique_cnic UNIQUE (CNIC),
	CONSTRAINT unique_creditcard UNIQUE (CreditCard),
	CONSTRAINT unique_contact UNIQUE (Contact),
	CONSTRAINT unique_username UNIQUE (Username)
	);

	create table Movies
	(
	MovieID int Identity(1,1) NOT NULL,
	Name varchar(50) NOT NULL, 
	Category varchar(50) NOT NULL, 
	M_Actor varchar(50) NOT NULL, 
	F_Actor varchar(50) NOT NULL, 
	Trailer varchar(50) NULL, 
	ReleaseDate date NOT NULL,
	--will be present in form of YouTube link

	CONSTRAINT movie_key PRIMARY KEY(MovieID),
	CONSTRAINT unique_moviename UNIQUE (Name)
	);

	create table Hall
	(
	HallID int Identity(1,1) NOT NULL,
	HallName varchar(20) NOT NULL,
	TotalSeats int NOT NULL,
	OccupiedSeats int NOT NULL,

	CONSTRAINT key_hall PRIMARY KEY(HallID),
	CONSTRAINT unique_name UNIQUE (HallName)
	);



	create table Reservation
	(
	R_ID int Identity(1,1) NOT NULL,
	HallID int NOT NULL,
	MemberID int NOT NULL,
	SeatsReserved int NOT NULL,
	--seats reserved by a member

	CONSTRAINT key_reservation PRIMARY KEY(R_ID),
	CONSTRAINT fkr_member FOREIGN KEY(MemberID) REFERENCES Member(MemberID),
	CONSTRAINT fkr_hall FOREIGN KEY(HallID) REFERENCES Hall(HallID),
	);

	create table Payment
	(
	PaymentID int Identity(1,1) NOT NULL,
	R_ID int NOT NULL,
	MemberID int NOT NULL,
	TotalPayment float NOT NULL,
	Discount int NULL,

	CONSTRAINT key_payment PRIMARY KEY(PaymentID),
	CONSTRAINT fkp_reservation FOREIGN KEY(R_ID) REFERENCES Reservation(R_ID),
	CONSTRAINT fkp_member FOREIGN KEY(MemberID) REFERENCES Member(MemberID),
	);


	create table Review
	(
	ReviewID int Identity(1,1) NOT NULL,
	Title varchar(20) NOT NULL,
	MemberID int NOT NULL,
	R_Description varchar(500) NOT NULL,
	MovieID int NOT NULL,
	ReviewStatus bit NOT NULL,
	ThumbsUp int NULL,
	ThumbsDown int NULL,
	--0 if review has been spammed, 1 if not

	CONSTRAINT fkw_movie FOREIGN KEY(MovieID) REFERENCES Movies(MovieID),
	CONSTRAINT fkw_member FOREIGN KEY(MemberID) REFERENCES Member(MemberID),
	CONSTRAINT key_review PRIMARY KEY(ReviewID)
	);


	create table Timings 
	(
	TimingID int Identity(1,1) NOT NULL,
	MovieID int NOT NULL,
	HallID int NOT NULL,
	Timing varchar(20) NOT NULL,
	ShowDate date NOT NULL,
	CONSTRAINT fkt_movie FOREIGN KEY(MovieID) REFERENCES Movies(MovieID),
	CONSTRAINT fkt_hall FOREIGN KEY(HallID) REFERENCES Hall(HallID)
	);

