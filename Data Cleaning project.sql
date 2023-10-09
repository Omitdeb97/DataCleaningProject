--selecting all from NashvilleHousingdata in asc way---
select *
from PortfolioProject..NashvilleHousingdata
order by SaleDate asc



----------------------------------------------------------------------------------------------

--Cleaning data in SQL queries---
select *
from PortfolioProject.dbo.NashvilleHousingdata





-------------------------------------------------------------------------------------------
--Standardize Date Formate 
select SaleDateConverted , cast(SaleDate as date) as Date
from PortfolioProject..NashvilleHousingdata

-- Altering a column into NashvilleHousingdata table

alter table PortfolioProject..NashvilleHousingdata
add SaleDateConverted date;

---Updating the column with converting.  
update PortfolioProject..NashvilleHousingdata
set SaleDateConverted = CONVERT(date, SaleDate)




------------------------------------------------------------------------------------------------------

--Populate property address date
select PropertyAddress
from PortfolioProject..NashvilleHousingdata
where PropertyAddress is null



--
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousingdata as a
join PortfolioProject..NashvilleHousingdata as b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is not null



update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousingdata as a
join PortfolioProject..NashvilleHousingdata as b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null






-----------------------------------------------------------------------------------------------------------
--Breaking out address into individual columns ( Address, City, State)


select PropertyAddress
from PortfolioProject..NashvilleHousingdata

--Using subsrting and charindex to find out first address before comma--

select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address, --After  CHARINDEX(',', PropertyAddress) we can use -1 so we not see comma after first part of propertyaddress. 
CHARINDEX(',', PropertyAddress),
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address, --CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) we can use + 1 and the leangth of propertyaddress to find all rest of information after comma.
CHARINDEX(',', PropertyAddress) + 1
from PortfolioProject..NashvilleHousingdata


--Adding two columns for spliting addresses--

Alter table PortfolioProject..NashvilleHousingdata
Add SplitPropertyAddress nvarchar(255)

update PortfolioProject..NashvilleHousingdata
set SplitPropertyAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)


Alter table PortfolioProject..NashvilleHousingdata
add SplitPropertyCity nvarchar (255)

update PortfolioProject..NashvilleHousingdata
set SplitPropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))



----Spliting OwnerAddress-----
select OwnerAddress
from PortfolioProject.dbo.NashvilleHousingdata
where OwnerAddress is not null

---Usinf Parsename and replace method to replace comma(,) to period(.). 
select 
PARSENAME(Replace(OwnerAddress, ',', '.'), 3) as OwnerSplitAddress,
PARSENAME(Replace(OwnerAddress, ',', '.'), 2) as OwnerSplitCity,
PARSENAME(Replace(OwnerAddress, ',','.'), 1) as OwnerSplictState
from PortfolioProject.dbo.NashvilleHousingdata
where OwnerAddress is not null


-----Altering Owner splicting address---

Alter table PortfolioProject..NashvilleHousingdata
Add OwnerSplitAddress nvarchar(255)

update PortfolioProject..NashvilleHousingdata
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'), 3)

Alter table PortfolioProject..NashvilleHousingdata
Add OwnerSplitCity nvarchar(255)

update PortfolioProject..NashvilleHousingdata
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'), 2)

Alter table PortfolioProject..NashvilleHousingdata
Add  OwnerSplictState nvarchar (255)

Update PortfolioProject..NashvilleHousingdata
Set OwnerSplictState = PARSENAME(Replace(OwnerAddress, ',','.'), 1)



select *
from PortfolioProject.dbo.NashvilleHousingdata
where OwnerAddress is not null







------------------------------------------------------------------------------------------------------------------------


--Change Y and N to Yes and No in Sold As Vacant field

select distinct( SoldAsVacant), count(SoldAsVacant) as SoldCount
from PortfolioProject.dbo.NashvilleHousingdata
group by SoldAsVacant
order by SoldCount 


---Using case statement to to change Y and N into Yes and No

select SoldAsVacant,
Case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	Else SoldAsVacant
	End as FixedSoldAsVacant
from PortfolioProject.dbo.NashvilleHousingdata


--Update that Information--
Update PortfolioProject.dbo.NashvilleHousingdata
set SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	Else SoldAsVacant
	End

select *
from PortfolioProject..NashvilleHousingdata





-----------------------------------------------------------------------------------------------------------------------

--Remove Duplicates 
--Using CTE table
WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID,
                         PropertyAddress,
                         SalePrice,
                         SaleDate,
                         LegalReference
            ORDER BY UniqueID
        ) AS Row_Num
    FROM PortfolioProject.dbo.NashvilleHousingdata
)

--Deleting duplicates 
Delete
from RowNumCTE
where Row_Num > 1

select *
from RowNumCTE
where Row_Num > 1






----------------------------------------------------------------------------------------

--Delete unused columns

select * 
from PortfolioProject.dbo.NashvilleHousingdata


Alter table PortfolioProject.dbo.NashvilleHousingdata
Drop Column PropertyAddress, TaxDistrict, SaleDate, OwnerAddress





