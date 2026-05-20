select * from geometries;

select  ST_Equals('POINT(0 0)', 'POINT(0 0)');

select 'POLYGON((0 0, 0 2, 2 2, 2 0, 0 0))'::geometry;

select ST_Intersects('POLYGON((0 0, 0 2, 2 2, 2 0, 0 0))', 'POINT(0 1)');
select ST_Crosses('POLYGON((0 0, 0 2, 2 2, 2 0, 0 0))', 'POINT(1 1)');

select ST_Touches('POINT(0 1)', 'POLYGON((0 0, 0 2, 2 2, 2 0, 0 0))');
select ST_Within('POINT(0 1)', 'POLYGON((0 0, 0 2, 2 2, 2 0, 0 0))');


select ST_Touches('POINT(0 0)', 'LINESTRING(0 0, 0 2, 2 2)');
select ST_Touches('POINT(0 1)', 'LINESTRING(0 0, 0 2, 2 2)');
select ST_Intersects('POINT(0 0)', 'LINESTRING(0 0, 0 2, 2 2)');
select ST_Intersects('POINT(0 1)', 'LINESTRING(0 0, 0 2, 2 2)');

select ST_Within('POINT(0 0)', 'LINESTRING(0 0, 0 2, 2 2)');
select ST_Within('POINT(0 1)', 'LINESTRING(0 0, 0 2, 2 2)');
select ST_Intersects('POINT(0 0)', 'LINESTRING(0 0, 0 2, 2 2)');
select ST_Intersects('POINT(0 1)', 'LINESTRING(0 0, 0 2, 2 2)');

select ST_Distance('POINT(0 0)', 'POINT(0 1)');
select ST_DWithin('POINT(0 0)', 'POINT(0 1)', ST_Distance('POINT(0 0)', 'POINT(0 1)'));