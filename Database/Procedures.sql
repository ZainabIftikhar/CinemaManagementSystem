--PROCEDURE 1: GET MEMBER ID

	create procedure getMemberID
	@name varchar(50),
	@id int OUTPUT
	AS
	BEGIN
		select  @id=MemberID from Member where Username=@name
		if @id is null
			set @id = 0
	END

--PROCEDURE 2: GET MOVIEID	
	create procedure getMovieID
	@name varchar(50),
	@id int OUTPUT
	AS
	BEGIN
		select  @id=MovieID from Movies where Name=@name
		if @id is null
			set @id = 0
	END


--PROCEDURE 3: GET REVIEWID	
	create procedure getReviewID
	@title varchar(20),
	@id int OUTPUT
	AS
	BEGIN
		select  @id=ReviewID from Review where @title=Title
		if @id is null
			set @id = 0
	END

--PROCEDURE 4 : GET USERSTATUS
	create procedure getMemberStatus
	@id int,
	@status int OUTPUT
	AS
	BEGIN
		select @status=MemberStatus from Member where @id=MemberID
	END
	
--PROCEDURE 5: SIGNUP
	
	create PROCEDURE SignUp
	@FirstName varchar(50), 
	@LastName varchar(50), 
	@CNIC char(13), 
	@CreditCard char (16), 
	@Email varchar(50),
	@Contact char(11), 
	@UserName varchar(20), 
	@UserType bit, 
	@Password varchar(30),
	@status int OUTPUT, 
	@userid int OUTPUT
	AS
	BEGIN
	
	IF  exists( select * From Member where UserName=@UserName )
		BEGIN
			set @status='0' --loginname alread exists
			set @userid='0'
		END
	ELSE 
		BEGIN 
			INSERT into Member values (@FirstName,@LastName,@CNIC,@CreditCard,@Email,@Contact,@UserName,@Password,@UserType,1);
			select  @userid=MemberID from Member where Username=@UserName
			set @status='1' 
		END
	END

--PROCEDURE 6: LOGIN


	create PROCEDURE Login
	
	@loginName varchar(30),
	@password varchar(50),
	@status int OUTPUT,
	@userID int OUTPUT,
	@usertype int OUTPUT
	AS
	BEGIN
		IF @loginName not in (Select Username from Member)
			BEGIN
				set @status = 3 --Wrong Username
				set @userID = 0;	
				set @usertype = -1;
			END
		ELSE
			BEGIN
				declare @mid int
				select @mid = MemberID from Member where @loginName = Username
				IF EXISTS ( select Password from Member where @mid = MemberID and @password = Password)
					BEGIN 
					set @status = 1 --Successful
					set @userID = @mid
					select @userType = UserType from Member where @mid = MemberID
					END
	           ELSE
					BEGIN		

					set @status = 2 --Wrong Password
					set @userID = 0;
					set @usertype = -1;
	           END
		END
	END;

	
---PROCEDURE 7 : ADD REVIEW

	create PROCEDURE ADDREVIEW
	@Title varchar(20),
	@Memberid int,
	@desc varchar(500),
	@movieid int,
	@status int OUTPUT
	AS
	BEGIN
		INSERT into Review values (@Title,@Memberid,@desc,@movieid,1,0,0);
		set @status = 1
	END;


---PROCEDURE 8: SHOW REVIEW

	create procedure ShowReview
	@name varchar(50)
	AS 
	BEGIN
		select Username as Name, Title, R_Description AS Review ,ThumbsUp, ThumbsDown
		from ShowReviews S
		where @name = S.Name 
	END

--PROCEDURE 9: THUMBS UP

	create procedure thumbsup
	@title varchar(20)
	AS
	BEGIN
		update Review
		set ThumbsUp=ThumbsUp+1
		where @title=Title
	END


--PROCEDURE 10: THUMBS DOWN

	create procedure thumbsdown
	@title varchar(20)
	AS
	BEGIN
		update Review
		set ThumbsDown=ThumbsDown+1
		where @title=Title
	END
	
		
--PROCEDURE 11 : SEARCH		

	create procedure search
	@string nvarchar(50),
	@found int output
	AS
	BEGIN
		IF EXISTS (select M.Name from Movies M 
					where M.Name like @string or M.Category like @string or M.M_Actor like @string or M.F_Actor like @string)
			set @found = 1

		ELSE
			set @found = 0
	END


---PROCEDURE 12: MOVIES FOUND

	create PROCEDURE MoviesFound
	@string varchar (50) 
	AS
	BEGIN
		select M.Name , M.Category , M.M_Actor As MaleLead , M.F_Actor As FemaleLead ,M.Trailer, M.ReleaseDate
		from Movies	M
		where M.Name like @string or M.Category like @string or M.M_Actor like @string or M.F_Actor like @string
	END
	
	
---PROCEDURE 13: ADD MOVIES

	create PROCEDURE AddMovies
	@Name varchar(50), 
	@Category varchar(50), 
	@M_Actor varchar(50), 
	@F_Actor varchar(50),
	@Trailer varchar(50),
	@ReleaseDate date,
	@status bit OUTPUT
	AS
	BEGIN
		IF  exists( select * From Movies where Name=@Name )
			BEGIN
				set @status='0' --movie alread exists
			END
	
		ELSE
			BEGIN
			IF (@Trailer='')
			set @Trailer = null
				INSERT into Movies values (@Name,@Category,@M_Actor,@F_Actor,@Trailer,@ReleaseDate);
				set @status = 1
	END
	END;


---PROCEDURE 14: DISCOUNT

	CREATE PROCEDURE DISCOUNT

	@seatsreserved int,
	@discountprovided bit OUTPUT

	AS 
	BEGIN

		IF (@seatsreserved > 4)
		BEGIN
		set @discountprovided = 1
		END

		ELSE
		BEGIN
		set @discountprovided = 0
		END
	
	END



---PROCEDURE 15: HALL STATUS

	create PROCEDURE HallStatus
	@Hall int,
	@status bit OUTPUT,
	@diff int OUTPUT
	
	AS 
	BEGIN
		declare @seatsreserved int,@totalseats int
		select @seatsreserved=OccupiedSeats,@totalseats=TotalSeats 
		from Hall where HallID=@Hall
	
		set @diff=@totalseats-@seatsreserved
	
		IF (@diff = 0)
		BEGIN
			set @status = 1    ---if hall full
		END

		ELSE
			BEGIN
		set @status = 0    ---if hall not full
		END
	END

---PROCEDURE 16: RESERVE SEATS

	create PROCEDURE ReserveSeats
	@HID int,
	@NoOfseats int,
	@MID int,
	@status bit OUTPUT,
	@rid int OUTPUT
		
	AS 
		BEGIN
			declare @difference int, @st int
			exec HallStatus						--using hallstatus to check whether hall is full or not
				@Hall = @HID,
				@diff=@difference output,
				@status=@st output

	
		IF (@difference >= @NoOfseats)
		BEGIN
			set @status = 1    ---reservation is possible
			insert into Reservation values (@HID,@MID,@NoOfSeats);
			select TOP 1 @rid = R_ID 
			from Reservation
			order by R_ID desc
			
			update Hall set OccupiedSeats=OccupiedSeats+@NoOfseats where HallID=@HID
		
		END

		ELSE
		BEGIN
			set @status = 0    ---Required no of seats not available
			set @rid = 0
		END
	END

---PROCEDURE 17: Payable

	create PROCEDURE Payable
	@RID int,
	@payment int output
	AS 
	BEGIN
		declare @dis int,@bill int,@seats int,@MID int
		
		select @seats=SeatsReserved, @MID=MemberID from Reservation where R_ID=@RID
		exec DISCOUNT
		@seatsreserved = @seats,
		@discountprovided=@dis OUTPUT
	
		set @dis=@dis*500
		set @bill=(@seats*500)-@dis
	
		insert into Payment values(@RID,@MID,@bill,@dis);
		select @payment = @bill from Payment where @RID = Payment.R_ID
	
	END

--PROCEDURE 18
	create procedure getCCard
	@id int,
	@card varchar(50) OUTPUT
	AS
	BEGIN
		select  @card=CreditCard from Member where MemberID=@id
		if @card is null
			set @id = 0
	END