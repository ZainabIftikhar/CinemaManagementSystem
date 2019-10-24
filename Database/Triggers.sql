---------------------------------TRIGGERS--------------------------------------
-------------------------------------------------------------------------------

---- TRIGGER 1: DELETE REVIEW  	
alter TRIGGER DeleteReview ON REVIEW

	Instead of DELETE AS   
	declare @rID int 
	BEGIN
	select @rID =  ReviewID from deleted
	update REVIEW
    set ReviewStatus = 0
	where @rId = ReviewID 
	END
	
	
---- TRIGGER 2: BLOCK MEMBER
alter TRIGGER BlockMember ON MEMBER

	Instead of DELETE AS
	declare @mID int
	BEGIN 
	select @mID = MemberID from deleted
	update MEMBER
	set MemberStatus = 0
	where @mID = MemberID 
	END
