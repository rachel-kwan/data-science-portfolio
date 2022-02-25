### PART 1 - Movie Ratings ###

/* Delete the tables if they already exist */
drop table if exists Movie;
drop table if exists Reviewer;
drop table if exists Rating;

/* Create the schema for our tables */
create table Movie(mID int, title text, year int, director text);
create table Reviewer(rID int, name text);
create table Rating(rID int, mID int, stars int, ratingDate date);

/* Populate the tables with our data */
insert into Movie values(101, 'Gone with the Wind', 1939, 'Victor Fleming');
insert into Movie values(102, 'Star Wars', 1977, 'George Lucas');
insert into Movie values(103, 'The Sound of Music', 1965, 'Robert Wise');
insert into Movie values(104, 'E.T.', 1982, 'Steven Spielberg');
insert into Movie values(105, 'Titanic', 1997, 'James Cameron');
insert into Movie values(106, 'Snow White', 1937, null);
insert into Movie values(107, 'Avatar', 2009, 'James Cameron');
insert into Movie values(108, 'Raiders of the Lost Ark', 1981, 'Steven Spielberg');

insert into Reviewer values(201, 'Sarah Martinez');
insert into Reviewer values(202, 'Daniel Lewis');
insert into Reviewer values(203, 'Brittany Harris');
insert into Reviewer values(204, 'Mike Anderson');
insert into Reviewer values(205, 'Chris Jackson');
insert into Reviewer values(206, 'Elizabeth Thomas');
insert into Reviewer values(207, 'James Cameron');
insert into Reviewer values(208, 'Ashley White');

insert into Rating values(201, 101, 2, '2011-01-22');
insert into Rating values(201, 101, 4, '2011-01-27');
insert into Rating values(202, 106, 4, null);
insert into Rating values(203, 103, 2, '2011-01-20');
insert into Rating values(203, 108, 4, '2011-01-12');
insert into Rating values(203, 108, 2, '2011-01-30');
insert into Rating values(204, 101, 3, '2011-01-09');
insert into Rating values(205, 103, 3, '2011-01-27');
insert into Rating values(205, 104, 2, '2011-01-22');
insert into Rating values(205, 108, 4, null);
insert into Rating values(206, 107, 3, '2011-01-15');
insert into Rating values(206, 106, 5, '2011-01-19');
insert into Rating values(207, 107, 5, '2011-01-20');
insert into Rating values(208, 104, 3, '2011-01-02');

# EXERCISES

select title
from EDX.Movie
where director like 'Steven Spielberg';

select distinct movie.year
from EDX.Movie movie join EDX.Rating rating on movie.mID = rating.mID
where rating.stars >= 4
order by movie.year;

# 3 - Titles of all movies that have no ratings (i.e. find mID's in movie which are not in rating)
select movie.title
from EDX.Movie movie left join EDX.Rating rating on movie.mID = rating.mID
where rating.mID is null;

# 4 - Names of reviewers who didn't provide date
select distinct reviewer.name
from EDX.Reviewer reviewer join EDX.Rating rating on reviewer.rID = rating.rID
where rating.ratingDate is null;

# 5 - Create more readable table combining all tables
select reviewer.name, movie.title, rating.stars, rating.ratingDate
from EDX.Rating rating inner join EDX.Movie movie on rating.mID = movie.mID
inner join EDX.Reviewer reviewer on rating.rID = reviewer.rID
order by reviewer.name, movie.title, rating.stars;

# 6 - For all cases where the same reviewer rated the same movie twice and gave it
# a higher rating the second time, return the reviewer's name and the title of the movie.
select name, title
from Movie
join Rating R1 using(mId)
join Rating R2 using(rId, mId)
join Reviewer using(rId)
where R1.ratingDate < R2.ratingDate and R1.stars < R2.stars;

# 7 - For each movie that has at least one rating, find the highest number of stars that movie received.
# Return the movie title and number of stars. Sort by movie title.
select title, max(stars) as highest_rating
from Movie left join Rating on Movie.mID = Rating.mID
where Rating.mID is not null
group by title
order by title;

# 8 - For each movie, return the title and the 'rating spread', that is, the difference between
# highest and lowest ratings given to that movie. Sort by rating spread from highest to lowest, then by movie title.
select title, max(stars)-min(stars) as rating_spread
from Movie left join Rating on Movie.mID = Rating.mID
where Rating.mID is not null
group by title
order by rating_spread desc, title;

# 9 - Find the difference between the average rating of movies released before 1980 and the average rating of
# movies released after 1980. (Make sure to calculate the average rating for each movie,
# then the average of those averages for movies before 1980 and movies after.
# Don't just calculate the overall average rating before and after 1980.)
select avg(Before1980.avg_rating) - avg(After1980.avg_rating)
from 
	(select avg(stars) as avg_rating
	from Movie inner join Rating using(mID)
    where year < 1980
    group by mId) as Before1980, 
    (select avg(stars) as avg_rating
    from Movie inner join Rating using(mID)
    where year > 1980
    group by mID) as After1980;

# EXTRA EXERCISES

# 1 - All reviewers who rated 'Gone with the Wind'
select distinct Reviewer.name
from Rating join Movie using(mID)
join Reviewer using (rID)
where Movie.title like 'Gone with the Wind';

# 2 - For any rating where the reviewer is the same as the director of the movie,
# return the reviewer name, movie title, and number of stars.
select Reviewer.name, Movie.title, Rating.stars
from Rating join Movie using(mID)
join Reviewer using (rID)
where Reviewer.name = Movie.director;

# 3 - Return all reviewer names and movie names together in a single list, alphabetized.
# (Sorting by the first name of the reviewer and first word in the title is fine;
# no need for special processing on last names or removing "The".)
with all_names (title) as
	(select Movie.title
	from (Movie left join Rating using(mID)
	left join Reviewer using(rID))
	union
	select Reviewer.name
	from (Movie left join Rating using(mID)
	left join Reviewer using(rID))
	where Reviewer.name is not null)
select title
from all_names
order by title;

# Alternative solution
select title from Movie
union
select name from Reviewer
order by name, title;

# 4 - Titles of all movies not reviewed by Chris Jackson.	
with not_chris (mID, title) as
	(select Movie.mID, Movie.title
	from Reviewer join Rating using(rID)
	join Movie using(mID)
	where Reviewer.name like 'Chris Jackson')
select Movie.title
from not_chris right join Movie using(mID)
where not_chris.title is null;

# Alternative solution
select title
from Movie
where mID not in 
	(select mID
	from Rating join Reviewer using(rID)
	where name like 'Chris Jackson');
    
# 5 - For all pairs of reviewers such that both reviewers gave a rating to the same movie,
# return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves,
# and include each pair only once. For each pair, return the names in the pair in alphabetical order.
select distinct Re1.name, Re2.name
from Rating R1, Rating R2, Reviewer Re1, Reviewer Re2
where R1.mID = R2.mID
and R1.rID = Re1.rID
and R2.rID = Re2.rID
and Re1.name < Re2.name
order by Re1.name, Re2.name;

# 6 - For each rating that is the lowest (fewest stars) currently in the database,
# return the reviewer name, movie title, and number of stars.
select Reviewer.name, Movie.title, Rating.stars
from Movie join Rating using(mID)
join Reviewer using(rID)
where stars = 
	(select min(stars)
    from Rating);
    
# 7 - List movie titles and average ratings, from highest-rated to lowest-rated.
# If two or more movies have the same average rating, list them in alphabetical order.
select Movie.title, avg(Rating.stars) as avg_rating
from Movie join Rating using(mID)
group by Movie.title
order by avg_rating desc, Movie.title;

# 8 - Find the names of all reviewers who have contributed three or more ratings.
with Re_Counts(name, counts) as
	(select Reviewer.name, count(rID)
	from Rating join Reviewer using(rID)
	group by Reviewer.name)
select name
from Re_Counts
where counts >= 3;

# Alternative solution using 'having'
select Reviewer.name
from Rating join Reviewer using(rID)
group by Reviewer.name
having count(*) >=3;

# 9 - Some directors directed more than one movie. For all such directors,
# return the titles of all movies directed by them, along with the director name.
# Sort by director name, then movie title.
select title, director
from (select director
	from Movie
	group by director
	having count(*) > 1) as top_directors
left join Movie using(director);

# 10 - Find the movie(s) with the highest average rating. Return the movie title(s) and average rating.
select title, avg(stars) as average
from Movie join Rating using(mID)
group by mID
having average = (
	select max(avg_rating) as max_avg_rating
	from 
		(select title, avg(stars) as avg_rating
		from Movie join Rating using(mID)
		group by mID) as avg_ratings);
        
# 11 - Find the movie(s) with the lowest average rating. Return the movie title(s) and average rating.
select title, avg(stars) as average
from Movie join Rating using(mID)
group by mID
having average = (
	select min(avg_rating) as min_avg_rating
	from 
		(select title, avg(stars) as avg_rating
		from Movie join Rating using(mID)
		group by mID) as avg_ratings);
        
# 12 - For each director, return the director's name together with the title(s) of the movie(s) they directed
# that received the highest rating among all of their movies, and the value of that rating.
# Ignore movies whose director is NULL.
select distinct max_ratings.director, table1.title, max_ratings.max_rating
from
	(select director, max(stars) as max_rating
	from Rating join Movie using(mID)
	where director is not null
	group by director) as max_ratings 
left join
	(select *
	from Rating join Movie using(mID)) as table1
on max_ratings.max_rating = table1.stars and max_ratings.director = table1.director;

### PART 2 - Social Network ###

/* Delete the tables if they already exist */
drop table if exists Highschooler;
drop table if exists Friend;
drop table if exists Likes;

/* Create the schema for our tables */
create table Highschooler(ID int, name text, grade int);
create table Friend(ID1 int, ID2 int);
create table Likes(ID1 int, ID2 int);

/* Populate the tables with our data */
insert into Highschooler values (1510, 'Jordan', 9);
insert into Highschooler values (1689, 'Gabriel', 9);
insert into Highschooler values (1381, 'Tiffany', 9);
insert into Highschooler values (1709, 'Cassandra', 9);
insert into Highschooler values (1101, 'Haley', 10);
insert into Highschooler values (1782, 'Andrew', 10);
insert into Highschooler values (1468, 'Kris', 10);
insert into Highschooler values (1641, 'Brittany', 10);
insert into Highschooler values (1247, 'Alexis', 11);
insert into Highschooler values (1316, 'Austin', 11);
insert into Highschooler values (1911, 'Gabriel', 11);
insert into Highschooler values (1501, 'Jessica', 11);
insert into Highschooler values (1304, 'Jordan', 12);
insert into Highschooler values (1025, 'John', 12);
insert into Highschooler values (1934, 'Kyle', 12);
insert into Highschooler values (1661, 'Logan', 12);

insert into Friend values (1510, 1381);
insert into Friend values (1510, 1689);
insert into Friend values (1689, 1709);
insert into Friend values (1381, 1247);
insert into Friend values (1709, 1247);
insert into Friend values (1689, 1782);
insert into Friend values (1782, 1468);
insert into Friend values (1782, 1316);
insert into Friend values (1782, 1304);
insert into Friend values (1468, 1101);
insert into Friend values (1468, 1641);
insert into Friend values (1101, 1641);
insert into Friend values (1247, 1911);
insert into Friend values (1247, 1501);
insert into Friend values (1911, 1501);
insert into Friend values (1501, 1934);
insert into Friend values (1316, 1934);
insert into Friend values (1934, 1304);
insert into Friend values (1304, 1661);
insert into Friend values (1661, 1025);
insert into Friend select ID2, ID1 from Friend;

insert into Likes values(1689, 1709);
insert into Likes values(1709, 1689);
insert into Likes values(1782, 1709);
insert into Likes values(1911, 1247);
insert into Likes values(1247, 1468);
insert into Likes values(1641, 1468);
insert into Likes values(1316, 1304);
insert into Likes values(1501, 1934);
insert into Likes values(1934, 1501);
insert into Likes values(1025, 1101);

# EXERCISES

# 1 - Names of all students who are friends with someone named Gabriel.
select H2.name
from Highschooler H1 join Friend on H1.ID = Friend.ID1
join Highschooler H2 on H2.ID = Friend.ID2
where H1.name like 'Gabriel';

# 2 - For every student who likes someone 2 or more grades younger than themselves,
# return that student's name and grade, and the name and grade of the student they like.
select H1.name, H1.grade, H2.name, H2.grade
from Highschooler H1 join Likes on H1.ID = Likes.ID1
join Highschooler H2 on H2.ID = Likes.ID2
where H1.grade - H2.grade >= 2;

# 3 - For every pair of students who both like each other, return the name and grade of both students.
# Include each pair only once, with the two names in alphabetical order.
select H1.name, H1.grade, H2.name, H2.grade
from Likes L1 join Likes L2 on L1.ID2 = L2.ID1
left join Highschooler H1 on H1.ID = L2.ID2
left join Highschooler H2 on H2.ID = L2.ID1
where L1.ID2 = L2.ID1 and L1.ID1 = L2.ID2 and H1.name < H2.name;

# 4 - Find all students who do not appear in the Likes table (as a student who likes or is liked)
# and return their names and grades. Sort by grade, then by name within each grade.
select H1.name, H1.grade
from Highschooler H1 left join Likes L1 on H1.ID = L1.ID1
left join Likes L2 on H1.ID = L2.ID2
where L1.ID1 is null and L2.ID2 is null
order by H1.grade, H1.name;

# 5 - For every situation where student A likes student B, but we have no information about whom B likes
# (that is, B does not appear as an ID1 in the Likes table), return A and B's names and grades.
select H1.name, H1.grade, H2.name, H2.grade
from Highschooler H1 join Likes L1 on H1.ID = L1.ID1
left join Likes L2 on L1.ID2 = L2.ID1
left join Highschooler H2 on L1.ID2 = H2.ID
where L2.ID1 is null;

# 6 - Find names and grades of students who only have friends in the same grade.
# Return the result sorted by grade, then by name within each grade.
select same_grade.name, same_grade.grade
from 
	(select distinct H1.name, H1.grade
	from Highschooler H1 join Friend on H1.ID = Friend.ID1
	join Highschooler H2 on H2.ID = Friend.ID2
	where H1.grade = H2.grade) as same_grade
left join 
	(select distinct H1.name, H1.grade
	from Highschooler H1 join Friend on H1.ID = Friend.ID1
	join Highschooler H2 on H2.ID = Friend.ID2
	where H1.grade != H2.grade) as diff_grade
on same_grade.name = diff_grade.name and same_grade.grade = diff_grade.grade
where diff_grade.name is null
order by same_grade.grade, same_grade.name;

# 7 - For each student A who likes a student B where the two are not friends, find if they have a friend C in common.
# For all such trios, return the name and grade of A, B, and C.
select H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
from
	(select not_friends.ID1, not_friends.ID2, F1.ID2 as mutual
	from
		(select L.ID1, L.ID2
		from Likes L left join Friend F on L.ID1 = F.ID1 and L.ID2 = F.ID2
		where F.ID1 is null) as not_friends
	left join Friend F1 on not_friends.ID1 = F1.ID1
	left join Friend F2 on not_friends.ID2 = F2.ID1
	where F1.ID2 = F2.ID2) as mutuals
left join Highschooler H1 on mutuals.ID1 = H1.ID
left join Highschooler H2 on mutuals.ID2 = H2.ID
left join Highschooler H3 on mutuals.mutual = H3.ID;

# 8 - Find the difference between the number of students in the school and the number of different first names.
select count(H.name) - count(distinct H.name)
from Highschooler H;

# 9 - Find the name and grade of all students who are liked by more than one other student.
select H.name, H.grade
from 
	(select ID2
	from Likes
	group by ID2
	having count(*) > 1) as many_likes
join Highschooler H on many_likes.ID2 = H.ID;

# EXTRA EXERCISES

# 1 - For every situation where student A likes student B, but student B likes a different student C,
# return the names and grades of A, B, and C.