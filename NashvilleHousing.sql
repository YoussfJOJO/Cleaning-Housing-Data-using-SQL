-- standardize date format

SELECT *
from portfolioproject.dbo.NashvilleHousing

SELECT SaleDate, SaleDateconverted
from portfolioproject.dbo.NashvilleHousing

Alter table NashvilleHousing
add SaleDateconverted date;

update portfolioproject.dbo.NashvilleHousing
set SaleDateconverted = convert(date, SaleDate)

-----------------------------------------------------------------------------------------------

-- populate property adress data

SELECT PropertyAddress
from portfolioproject.dbo.NashvilleHousing
--where PropertyAddress is NULL
order by ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from portfolioproject.dbo.NashvilleHousing a
join portfolioproject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL

update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from portfolioproject.dbo.NashvilleHousing a
join portfolioproject.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL

------------------------------------------------------------------------------------------------


--breaking out address into indvidual columns (address, city, state)

SELECT PropertyAddress
from portfolioproject.dbo.NashvilleHousing

select
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
,substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as Address
from portfolioproject.dbo.NashvilleHousing


Alter table portfolioproject.dbo.NashvilleHousing
add PropertySplitAddress nvarchar(255);

update portfolioproject.dbo.NashvilleHousing
set PropertySplitAddress = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter table portfolioproject.dbo.NashvilleHousing
add PropertySplitCity nvarchar(255);

update portfolioproject.dbo.NashvilleHousing
set PropertySplitCity = substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress))

SELECT *
from portfolioproject.dbo.NashvilleHousing

---------------------------------------------------------------------------------------



SELECT OwnerAddress
from portfolioproject.dbo.NashvilleHousing

select
PARSENAME(replace(OwnerAddress, ',','.'), 3) as Address
,PARSENAME(replace(OwnerAddress, ',','.'), 2) as City
,PARSENAME(replace(OwnerAddress, ',','.'), 1) as State
from portfolioproject.dbo.NashvilleHousing

Alter table portfolioproject.dbo.NashvilleHousing
add address nvarchar(255);

update portfolioproject.dbo.NashvilleHousing
set address = PARSENAME(replace(OwnerAddress, ',','.'), 3)

Alter table portfolioproject.dbo.NashvilleHousing
add City nvarchar(255);

update portfolioproject.dbo.NashvilleHousing
set City = PARSENAME(replace(OwnerAddress, ',','.'), 2)

Alter table portfolioproject.dbo.NashvilleHousing
add State nvarchar(255);

update portfolioproject.dbo.NashvilleHousing
set State = PARSENAME(replace(OwnerAddress, ',','.'), 1)

SELECT *
from portfolioproject.dbo.NashvilleHousing

-----------------------------------------------------------------------------------

--change Y & N to yes & no in " soldasvacant " column




SELECT distinct(SoldAsVacant), count(SoldAsVacant)
from portfolioproject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

SELECT SoldAsVacant
,case when SoldAsVacant ='Y' then 'Yes'
 when SoldAsVacant ='N' then 'No'
 else SoldAsVacant
 end



update portfolioproject.dbo.NashvilleHousing
set SoldAsVacant = case when SoldAsVacant ='Y' then 'Yes'
 when SoldAsVacant ='N' then 'No'
 else SoldAsVacant
 end

 ------------------------------------------------------------------------------------

 -- remove dublicates

 with ROWNUMCTE AS(
 select *, 
 ROW_NUMBER() over(
 partition by ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference
 ORDER BY UniqueID
 ) as row_num
from portfolioproject.dbo.NashvilleHousing
)
select *
from ROWNUMCTE
where row_num > 1
order by PropertyAddress

------------------------------------------------------------------------------------

--delete columns

alter table portfolioproject.dbo.NashvilleHousing
drop column PropertyAddress, OwnerAddress, TaxDistrict

alter table portfolioproject.dbo.NashvilleHousing
drop column SaleDate

select *
from portfolioproject.dbo.NashvilleHousing