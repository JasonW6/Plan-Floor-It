CREATE DATABASE Project;

GO

USE Project;

GO


CREATE TABLE [dbo].[Users]
(
    [UserId] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY, 
    [UserName] VARCHAR(MAX) NOT NULL, 
    [PasswordHash] VARCHAR(MAX) NULL, 
    [SecurityStamp] VARCHAR(MAX) NULL
);

CREATE TABLE [dbo].[UserRoles]
(
	[UserId] UNIQUEIDENTIFIER NOT NULL,
	[Role] VARCHAR(MAX) NOT NULL,

	CONSTRAINT pk_UserRoles PRIMARY KEY (UserId, Role),
	CONSTRAINT fk_UserRoles_Users FOREIGN KEY (UserId) REFERENCES Users(UserId)
);
 

 CREATE TABLE House
 (
	HouseId int identity(1, 1),
	UserId int, 
	HouseName varchar(50) not null, 
	Basement bit not null, 
	Floors int not null,
	SquareFootage int not null, 
	Region varchar(50), 
	Budget int not null, 

	CONSTRAINT pk_HouseId PRIMARY KEY(HouseId),
	CONSTRAINT fk_House_Users FOREIGN KEY(UserId) REFERENCES Users(UserId),

 );

 CREATE TABLE Floor
 (
	FloorId int identity(1, 1),
	HouseId int,
	FloorNumber int not null,
	FloorPlan JSON, --JSON was recognized as a column data type here. Assuming this will work?
	
	CONSTRAINT pk_FloorId PRIMARY KEY(FloorId),
	CONSTRAINT fk_Floor_House FOREIGN Key(HouseId) REFERENCES House(HouseId),
 );

 CREATE TABLE Materials
 (
	MaterialId int identity(1, 1),
	Material_Type_Item varchar(50) not null, 
	IsMaterial bit, 
	LowPrice decimal (7, 2) not null, 
	MidPrice decimal (7, 2) not null, 
	HighPrice decimal (7, 2) not null,
	ImageSource varchar not null,
	
	CONSTRAINT pk_MaterialId PRIMARY KEY(MaterialId),

 );
