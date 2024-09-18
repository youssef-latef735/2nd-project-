--cleaning data in sql queries

select*from nashville_housing

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--standarize data format
select saledateconverted,CAST(saledate as date)
from nashville_housing

update nashville_housing
set saledate=cast (saledate as date)

alter table nashville_housing
add  saledateconverted date

update nashville_housing
set saledateconverted=cast (saledate as date)

select saledateconverted from nashville_housing

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--populate property address date 
select  propertyaddress from nashville_housing
where propertyaddress is null

select a.parcelID,a.propertyaddress,b.parcelId,b.propertyaddress,ISNULL(a.propertyaddress,b.propertyaddress)
from nashville_housing a
join nashville_housing b
on  a.parcelId=b.parcelId
and a.uniqueID<>b.uniqueID
where a.propertyaddress is null

update a
set propertyaddress= ISNULL(a.propertyaddress,b.propertyaddress)
from nashville_housing a
join nashville_housing b
on  a.parcelId=b.parcelId
and a.uniqueID<>b.uniqueID
where a.propertyaddress is null

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--breaking out address into individual columns(address,city,state)

select propertyaddress
from nashville_housing

select 
PARSENAME(replace(propertyaddress,',','.'),2),
PARSENAME(replace(propertyaddress,',','.'),1)
from nashville_housing

alter table nashville_housing
add property_split_address nvarchar(255)

update nashville_housing
set property_split_address= PARSENAME(replace(propertyaddress,',','.'),2)

alter table nashville_housing
add property_split_city nvarchar(255)

update nashville_housing
set property_split_city=PARSENAME(replace(propertyaddress,',','.'),1)

select*from nashville_housing

select 
PARSENAME(replace(owneraddress,',','.'),3),
PARSENAME(replace(owneraddress,',','.'),2),
PARSENAME(replace(owneraddress,',','.'),1)
from nashville_housing

alter table nashville_housing
add owner_address nvarchar(255)

update nashville_housing
set owner_address=PARSENAME(replace(owneraddress,',','.'),3)

alter table nashville_housing
add owner_city nvarchar(255)

update nashville_housing
set owner_city=PARSENAME(replace(owneraddress,',','.'),2)

alter table nashville_housing
add owner_state nvarchar(255)

update nashville_housing
set owner_state=PARSENAME(replace(owneraddress,',','.'),1)

select*from nashville_housing

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--change y and n to yes and no in 'sold as vacant' field

select distinct soldasvacant , count( soldasvacant)
from nashville_housing
group by soldasvacant
order by count(soldasvacant) asc

select soldasvacant,
case when soldasvacant='n' then 'No'
     when soldasvacant='y'then 'Yes'
	 else soldasvacant
	 end 
	 from  nashville_housing


	 update  nashville_housing
	 set soldasvacant=case when soldasvacant='n' then 'No'
     when soldasvacant='y'then 'Yes'
	 else soldasvacant
	 end 
	 from  nashville_housing
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--remove duplicates 
with cte 
as
(
select* ,
row_number () over ( partition by parcelid,propertyaddress,saledate,saleprice,legalreference order by uniqueid) as 'row_num'
from nashville_housing
)
select*
from cte
where row_num =1
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 
--delete unused columns
select*from nashville_housing

alter table nashville_housing
drop column propertyaddress,saledate,owneraddress,taxdistrict


























