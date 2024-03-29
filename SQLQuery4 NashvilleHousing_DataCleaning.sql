/*
Cleaning Data in SQL Queries
*/


SELECT *
FROM 
	PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------
-- Populate Property Address data

SELECT *
FROM 
	PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
ORDER BY 
	ParcelID



SELECT 
	a.ParcelID, 
	a.PropertyAddress, 
	b.ParcelID, 
	b.PropertyAddress, 
	ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM 
	PortfolioProject.dbo.NashvilleHousing a
JOIN 
	PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE 
	a.PropertyAddress is null


UPDATE 
	a
SET 
	PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM 
	PortfolioProject.dbo.NashvilleHousing a
JOIN 
	PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE 
	a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


SELECT 
	PropertyAddress
FROM 
	PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address, 
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

FROM 
	PortfolioProject.dbo.NashvilleHousing


ALTER TABLE 
	NashvilleHousing
	Add PropertySplitAddress Nvarchar(255);

UPDATE 
	NashvilleHousing
SET 
	PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE 
	NashvilleHousing
ADD 
	PropertySplitCity Nvarchar(255);

UPDATE 
	NashvilleHousing
SET 
	PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




SELECT *
FROM 
	PortfolioProject.dbo.NashvilleHousing





SELECT 
	OwnerAddress
FROM 
	PortfolioProject.dbo.NashvilleHousing


SELECT
	PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
	PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
	PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM 
	PortfolioProject.dbo.NashvilleHousing



ALTER TABLE 
	NashvilleHousing
ADD 
	OwnerSplitAddress Nvarchar(255);

UPDATE 
	NashvilleHousing
SET 
	OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE 
	NashvilleHousing
ADD 
	OwnerSplitCity Nvarchar(255);

UPDATE 
	NashvilleHousing
SET 
	OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE 
	NashvilleHousing
ADD 
	OwnerSplitState Nvarchar(255);

UPDATE 
	NashvilleHousing
SET 
	OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
FROM 
	PortfolioProject.dbo.NashvilleHousing




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


SELECT DISTINCT
	(SoldAsVacant), 
	Count(SoldAsVacant)
FROM 
	PortfolioProject.dbo.NashvilleHousing
GROUP BY 
	SoldAsVacant
ORDER BY
	2




SELECT 
	SoldAsVacant,
	CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM 
	PortfolioProject.dbo.NashvilleHousing


UPDATE 
	NashvilleHousing
SET 
	SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
SELECT 
	*,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	PropertyAddress,
	SalePrice,		
	SaleDate,
	LegalReference
ORDER BY
	UniqueID
	) row_num

FROM
	PortfolioProject.dbo.NashvilleHousing

--order by ParcelID
)
SELECT *
FROM 
	rownumCTE
WHERE 
	row_num > 1
ORDER BY 
	PropertyAddress



SELECT *
FROM 
	PortfolioProject.dbo.NashvilleHousing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



SELECT *
FROM 
	PortfolioProject.dbo.NashvilleHousing


ALTER TABLE 
	PortfolioProject.dbo.NashvilleHousing
DROP 
	COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
