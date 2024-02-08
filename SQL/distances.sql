with ods as
(
    select postcode, pcd_long, pcd_lat
    from dental_practices_accepting_nhs_geo
    -- where rownum < 3
)
,
lkp as
(
    select postcode, pcd_long, pcd_lat
    from int646_postcode_lookup
    where rownum < 101
),
dist as
(
select 
    ods.postcode ods_postcode,
    lkp.postcode lkp_postcode,
    sdo_geom.sdo_distance(
      sdo_geometry(2001, 4326, sdo_point_type(ods.pcd_long, ods.pcd_lat, null), null, null),
      sdo_geometry(2001, 4326, sdo_point_type(lkp.pcd_long, lkp.pcd_lat, null), null, null),
      0.01,
      'unit=MILE'
    ) distance
from
    ods join lkp on 1=1
),
min_dist as
(
select
    lkp_postcode,
    ods_postcode,
    distance,
    RANK() OVER ( PARTITION BY  lkp_postcode
			       ORDER BY	    distance
			     ) r_num    
from dist
)
select
    lkp_postcode,
    ods_postcode,
    distance min_distance
from min_dist
where 1=1
      and r_num = 1
order by distance
;
