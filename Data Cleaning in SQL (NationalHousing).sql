Select *
From PortfolioProject.dbo.NationalHousing


---Convert Date to standardize Date format

Select SaleDate, CONVERT(DATE,SaleDate)
From PortfolioProject.dbo.NationalHousing

---Update the Sale Date to Standard date
 

 Alter Table NationalHousing
 Add SaleDateConverted Date

 Update NationalHousing
 Set SaleDateConverted = Convert(Date,SaleDate)

 Select SaleDateConverted, CONVERT(DATE,SaleDate)
From PortfolioProject.dbo.NationalHousing

Select *
From PortfolioProject.dbo.NationalHousing

---Populate Property Address Data

select *
From PortfolioProject.dbo.NationalHousing
where PropertyAddress is Null
Order by ParcelID


---Join ParcelID with PropertyAddress

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NationalHousing a
Join PortfolioProject.dbo.NationalHousing b
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is Null


Update a
set propertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NationalHousing a
Join PortfolioProject.dbo.NationalHousing b
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is Null

---Checking 
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NationalHousing a
Join PortfolioProject.dbo.NationalHousing b
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is Null


---Spliting Address into individual Columns( Address, City, State)

select PropertyAddress
From PortfolioProject.dbo.NationalHousing

---Seperate the address and also Remove Comma
select
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1, Len(PropertyAddress)) as Address
From PortfolioProject.dbo.NationalHousing


---Insert New Column(PropertySplitAddress and PropertySplitCity)


 Alter Table NationalHousing
 Add PropAddress Nvarchar(255);

 Update NationalHousing
 Set PropAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

  Alter Table NationalHousing
 Add PropCity Nvarchar(255)

 Update NationalHousing
 Set PropCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1, Len(PropertyAddress))

select *
From PortfolioProject.dbo.NationalHousing


---Split OwnerAddress

select OwnerAddress
From PortfolioProject.dbo.NationalHousing

select
PARSENAME(REPLACE(OwnerAddress, ',','.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',','.' ), 2)
,PARSENAME(REPLACE(OwnerAddress, ',','.') , 1)
From PortfolioProject.dbo.NationalHousing

Alter Table NationalHousing
 Add OwnerSplitAddress Nvarchar(255)

 Update NationalHousing
 Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.') , 3


 Alter Table NationalHousing
 Add OwnerSplitCity Nvarchar(255)

 Update NationalHousing
 Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.' ), 2)


 Alter Table NationalHousing
 Add OwnerSplitState  Nvarchar(255)

 Update NationalHousing
 Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.') , 1)


 select *
From PortfolioProject.dbo.NationalHousing

---Change Y and N to Yes and No in "Solid as Vacant" field

select distinct(SoldAsVacant)
From PortfolioProject.dbo.NationalHousing

select distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NationalHousing
Group by SoldAsVacant
Order by 2

select SoldAsVacant
  , CASE When SoldAsVacant = 'Y' Then 'Yes'
        When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		End
From PortfolioProject.dbo.NationalHousing

Update NationalHousing
set SoldAsVacant =  CASE When SoldAsVacant = 'Y' Then 'Yes'
        When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		End

--Remove Duplicates

WITH RowNumCTE AS(
Select *,
    Row_Number() Over(
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				    UniqueID
					) row_num

From PortfolioProject.dbo.NationalHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

---Delete Unused Column

Select *
From PortfolioProject.dbo.NationalHousing


ALTER TABLE PortfolioProject.dbo.NationalHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

Select *
From PortfolioProject.dbo.NationalHousing