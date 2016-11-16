SET search_path to bnb, public;

/*question 8 scratching backs*/

/*generate a list that holds given and received for each booking*/
/*caution: there might be null in some attributes, one missing rating one way or another*/
CREATE VIEW rating_table AS
    SELECT Booking.travelerId, TravelerRating.listingId, TravelerRating.startDate, 
        HomeownerRating.rating AS recv_rate, TravelerRating.rating AS give_rate 
    FROM Booking, HomeownerRating, TravelerRating
    WHERE Booking.listingId = HomeownerRating.listingId AND Booking.startdate = HomeownerRating.startDate
        AND Booking.listingId = TravelerRating.listingId AND Booking.startdate = TravelerRating.startDate;
    
/*find reciprocal: rating exactly the same*/
CREATE VIEW reciprocal AS
    SELECT travelerId, count(*) AS reciprocal_num
    FROM rating_table
    WHERE recv_rate = give_rate
    GROUP BY travelerId;

/*find scratching backs: rating differs by one*/
/*need to consider corner case such as the rating cannot go beyond 5 or below 1 (might be trivial)*/
CREATE VIEW scratch_backs AS
    SELECT travelerId, count(*) AS scratch_backs_num
    FROM rating_table
    WHERE recv_rate = give_rate + 1 OR recv_rate = give_rate - 1 OR recv_rate = give_rate
    GROUP BY travelerId;

/*combine two of the tables*/
CREATE VIEW result AS
    SELECT reciprocal.travelerId AS travelerID, 
        reciprocal.reciprocal_num AS reciprocals,
        scratch_backs.scratch_backs_num AS backScratches
    FROM reciprocal, scratch_backs
    WHERE reciprocal.travelerId = scratch_backs.travelerId;

/*might need to include those who has never received rating or never gave reatings*/

/*return the result in the required manner*/
SELECT *
FROM result
ORDER BY
    reciprocals DESC,
    backScratches DESC;
