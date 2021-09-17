/*

Cleaning Data in SQL Queries

*/

Select *
From PortfolioProject..NashvilleHousing

------------------------------------------------------------------------------------------------------------------------------------------

--Standardize Date Format


Select SaleDateConverted, Convert(Date, SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = Convert(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = Convert(Date, SaleDate)

------------------------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address Data

Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is NULL
Order by ParcelID

-- As we have checked that the Property Address is same for all the same Parcel ID's
-- We will update the columns with the address where ever it is null and have the same Parcel ID's
--Lets do it by joining same table by keeping alias as (a & b)

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is NULL

-- as we have successfully found that the addresses are same, lets Update the column 'Property Address'

-- ISNULL s used to check if tehre are any Null and update it with the values or strings [Example: =ISNULL(a.PropertyAddress, 'No Address')]

Update a
SET PropertyAddress= ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is NULL


------------------------------------------------------------------------------------------------------------------------------------------------------

-- Breaking out PropertyAddress data


Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is NULL
--Order by ParcelID


Select
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress))


Select*
From PortfolioProject.dbo.NashvilleHousing




-- Breaking out OwnerAddress data


Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing


Select
PARSENAME(Replace(OwnerAddress,',','.'), 3)
,PARSENAME(Replace(OwnerAddress,',','.'), 2)
,PARSENAME(Replace(OwnerAddress,',','.'), 1)
From PortfolioProject.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'), 2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'), 1)


Select*
From PortfolioProject.dbo.NashvilleHousing




--------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in 'Sold and Vacant' field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group By SoldAsVacant
Order By 2

-- Lets do this with the casestatement


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant =  CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	   END


----------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Removing Duplicates


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() Over(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order By
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--Order By ParcelID
)
--Select *
Delete
From RowNumCTE
Where row_num > 1
Order By PropertyAddress


Select *
From  PortfolioProject.dbo.NashvilleHousing




------------------------------------------------------------------------------------------------------------------------------------------------------------



-- Delete Unused Columns



Select *
From  PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate





