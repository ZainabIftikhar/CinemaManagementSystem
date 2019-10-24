-------------------------------------VIEWS--------------------------------------
--------------------------------------------------------------------------------

--VIEW 1 : Show Reviews


	create view ShowReviews

	as
	select R.ThumbsUp, R.ThumbsDown, U.Username, R.Title, R.R_Description, M.Name
	from Review R, Movies M, Member U
	where R.MemberID = U.MemberID and R.MovieID=M.MovieID and R.ReviewStatus!=0
	

--VIEW 2 : Shows Members


	create view ShowMember

	as 
	select FirstName, LastName, Username
	from Member M
	where MemberStatus!=0 and M.UserType!=1
	

--VIEW 3 : SHOW REVIEWS 2

	create view AllReviews
	as
	select Username as Name, Title, R_Description AS Review
	from ShowReviews S
	

---VIEW 4: SHOW INFORMATION

create view ShowInformation
as
select Movies.Name, Movies.Category, Hall.HallName,Timings.Timing
from Movies inner join Timings on Movies.MovieID=Timings.MovieID
inner join Hall on Hall.HallID=Timings.HallID
	
select * from ShowInformation
