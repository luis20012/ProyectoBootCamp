CREATE PROCEDURE [dbo].[Access_Sp_Delete]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[Access] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Access_Sp_Get]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[Access] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Access_Sp_GetAll] 
AS
SET NOCOUNT ON;
SELECT * FROM dbo.[Access]

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Access_sp_GetByAccess_Id]
(@Access_Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;
if (@lstId is null)
begin
    select * from dbo.[Access] 
    WHERE [Id] = @Access_Id
end
else
begin
    select * from dbo.[Access] 
    WHERE [Id] in(select * from dbo.SplitID(@lstId))
end

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Access_Sp_GetByCode]
@Code varchar(100)
WITH 
EXECUTE AS CALLER
AS
SELECT * FROM Access
		WHERE Code =  @Code

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Access_Sp_GetByFilter]
@Type_Id smallint = null, @Name varchar(255) = null, @Description varchar(255) = null, @Code varchar(100) = null, @Data varchar(512) = null, @Url varchar(512) = null, @Icon varchar(50) = null, @Posicion smallint = null, @Parent_Access_Id int = null, @Page int = null, @PageSize int = null
WITH 
EXECUTE AS CALLER
AS
SET NOCOUNT ON;

SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[Access] AS PAG
WHERE (@Type_Id is null or [Type_Id] = @Type_Id)
	 and (@Name is null or [Name] = @Name)
	 and (@Description is null or [Description] = @Description)
	 and (@Code is null or [Code] = @Code)
	 and (@Data is null or [Data] = @Data)
	 and (@Url is null or [Url] = @Url)
	 and (@Icon is null or [Icon] = @Icon)
	 and (@Posicion is null or [Posicion] = @Posicion)
	 and (@Parent_Access_Id is null or [Parent_Access_Id] = @Parent_Access_Id)

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Access_Sp_GetByParent_Access_Id]
(@Parent_Access_Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[Access] 
WHERE ((not @Parent_Access_Id is null 
        and [Parent_Access_Id] = @Parent_Access_Id)
   or (not @lstId is null
        and [Parent_Access_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Access_sp_GetByProfile_Id]
@Profile_Id int = null, @lstId varchar(MAX) = null
WITH 
EXECUTE AS CALLER
AS
SELECT Access.*
             FROM dbo.ProfileAccess ProfileAccess
                  INNER JOIN dbo.Access Access
                  ON (ProfileAccess.Access_Id = Access.Id)
            WHERE (ProfileAccess.Profile_Id = @Profile_Id)
            or( not @lstId is null 
                and ProfileAccess.Profile_Id in(select * from dbo.SplitID(@lstId)))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Access_Sp_GetByType_Id]
(@Type_Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[Access] 
WHERE ((not @Type_Id is null 
        and [Type_Id] = @Type_Id)
   or (not @lstId is null
        and [Type_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Access_sp_GetByUser_Id]
@User_Id int = null, @lstId varchar(MAX) = null
WITH 
EXECUTE AS CALLER
AS
SELECT distinct  Access.*
  FROM ((dbo.ProfileAccess ProfileAccess
        INNER JOIN dbo.Profile Profile
        ON (ProfileAccess.Profile_Id = Profile.Id))
        INNER JOIN dbo.Access Access
        ON (ProfileAccess.Access_Id = Access.Id))
      INNER JOIN dbo.UserProfile UserProfile
      ON (UserProfile.Profile_Id = Profile.Id)
      inner join [Type] as State
      on State.Id = Profile.State_Type_Id
  WHERE (State.Code = 'Enable') 
    AND 
    (not @User_Id is null and 
    UserProfile.[User_Id] = @User_Id)
    or ((not @lstId is null)
    AND (UserProfile.[User_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Access_Sp_Save]
@Id int, @Type_Id smallint, @Name varchar(255), @Description varchar(255), @Code varchar(100), @Data varchar(512), @Url varchar(512), @Icon varchar(50), @Posicion smallint, @Parent_Access_Id int
WITH 
EXECUTE AS CALLER
AS
IF (SELECT COUNT(*) from dbo.[Access]  WHERE  [Id] = @Id) > 0
    BEGIN
        UPDATE dbo.[Access]
             SET  [Type_Id] = @Type_Id, [Name] = @Name, [Description] = @Description, [Code] = @Code, [Data] = @Data, [Url] = @Url, [Icon] = @Icon, [Posicion] = @Posicion, [Parent_Access_Id] = @Parent_Access_Id
             WHERE  [Id] = @Id
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[Access]   
               ([Type_Id], [Name], [Description], [Code], [Data], [Url], [Icon], [Posicion], [Parent_Access_Id]) 
        VALUES(@Type_Id,@Name,@Description,@Code,@Data,@Url,@Icon,@Posicion,@Parent_Access_Id)
        SELECT SCOPE_IDENTITY() as Id
    END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Accion_Sp_Delete]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[Accion] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Accion_Sp_Get]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[Accion] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Accion_Sp_GetAll] 
AS
SET NOCOUNT ON;
SELECT * FROM dbo.[Accion]

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Accion_Sp_GetByAccionCategory_Id]
(@AccionCategory_Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[Accion] 
WHERE (not @AccionCategory_Id is null 
        and Category_Type_Id = @AccionCategory_Id)
   or (not @lstId is null
        and Category_Type_Id in(select * from dbo.SplitID(@lstId)))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Accion_Sp_GetByCategory_Type_Id]
(@Category_Type_Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[Accion] 
WHERE ((not @Category_Type_Id is null 
        and [Category_Type_Id] = @Category_Type_Id)
   or (not @lstId is null
        and [Category_Type_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Accion_Sp_GetByCode] 
@Code VARCHAR(50) 
AS
	SELECT * FROM Accion
		WHERE Code =  @Code

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Accion_Sp_GetByFilter] 
(@Code varchar(50) = null, @Name varchar(255) = null, @Order smallint = null, @Category_Type_Id int = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;

SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[Accion] AS PAG
WHERE (@Code is null or [Code] = @Code)
	 and (@Name is null or [Name] = @Name)
	 and (@Order is null or [Order] = @Order)
	 and (@Category_Type_Id is null or [Category_Type_Id] = @Category_Type_Id)

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Accion_Sp_Save]
(@Id int, @Code varchar(50), @Name varchar(255), @Order smallint, @Category_Type_Id int) 
as
IF (SELECT COUNT(*) from dbo.[Accion]  WHERE  [Id] = @Id) > 0
    BEGIN
        UPDATE dbo.[Accion]
             SET  [Code] = @Code, [Name] = @Name, [Order] = @Order, [Category_Type_Id] = @Category_Type_Id
             WHERE  [Id] = @Id
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[Accion]   
               ([Code], [Name], [Order], [Category_Type_Id]) 
        VALUES(@Code,@Name,@Order,@Category_Type_Id)
        SELECT SCOPE_IDENTITY() as Id
    END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[BcpImport_Sp_CopyRepositoryData]
(@FromRepository_Id int = 0,@ToRepository_Id int, @ProcessConfig_Id smallint = null)
AS
SET NOCOUNT ON;
SET IDENTITY_INSERT [BcpImport] ON

insert into [BcpImport] ([Id], [Repository_Id],[ProcessConfig_Id], [Name], [RepositoryConfig_Id], [RepositoryCode], [Path], [Delimiter], [HasHeaderRow], [EnclosedInQuotes], [Conexion_Id], [SqlCommand], [Deleted], [Delimited], [SqlSource])
  Select [Id], @ToRepository_Id as [Repository_Id],[ProcessConfig_Id], [Name], [RepositoryConfig_Id], [RepositoryCode], [Path], [Delimiter], [HasHeaderRow], [EnclosedInQuotes], [Conexion_Id], [SqlCommand], [Deleted], [Delimited], [SqlSource]
  From [BcpImport]
  Where Repository_Id = @FromRepository_Id 
   AND  ProcessConfig_Id = @ProcessConfig_Id 

SET IDENTITY_INSERT [BcpImport] OFF
GO


GO
-------------------------------------
CREATE PROCEDURE [dbo].[BcpImport_Sp_Delete]
( 
@Id int = null, @lstId varchar(MAX) = null
, @Repository_Id int
)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[BcpImport] 
WHERE  
    
    ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))
    and Repository_Id = @Repository_Id
GO


-------------------------------------
CREATE PROCEDURE [dbo].[BcpImport_Sp_Get]  
( @Id int = null, @lstId varchar(MAX) = null 
, @Repository_Id int)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[BcpImport] 
WHERE   
    ((not @Id is null and [Id] = @Id)
   or (not @lstId is null and [Id] in(select * from dbo.SplitID(@lstId))))
   and Repository_Id = @Repository_Id
GO


-------------------------------------
CREATE PROCEDURE [dbo].[BcpImport_Sp_GetAll] (@Repository_Id int)
AS
	SET NOCOUNT ON;
	SELECT * 
	FROM dbo.[BcpImport]
	WHERE Repository_Id = @Repository_Id
GO
-------------------------------------
CREATE PROCEDURE [dbo].[BcpImport_Sp_GetByConexion_Id]  
( @Conexion_Id int = null, @lstId varchar(MAX) = null
, @Repository_Id int)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[BcpImport] 
	WHERE   
	   ((not @Conexion_Id is null and [Conexion_Id] = @Conexion_Id)
	   or (not @lstId is null and [Conexion_Id]  in(select * from dbo.SplitID(@lstId))))
	   and Repository_Id = @Repository_Id

GO
-------------------------------------
CREATE PROCEDURE [dbo].[BcpImport_Sp_GetByFilter] 
(@Repository_Id int = null, @Repository_Ids varchar(MAX) = null, @ProcessConfig_Id smallint = null, @ProcessConfig_Ids varchar(MAX) = null, @Name varchar(100) = null, @RepositoryConfig_Id smallint = null, @RepositoryConfig_Ids varchar(MAX) = null, @RepositoryCode varchar(100) = null, @Path varchar(255) = null, @Delimiter varchar(5) = null, @HasHeaderRow bit = null, @EnclosedInQuotes bit = null, @Conexion_Id int = null, @Conexion_Ids varchar(MAX) = null, @SqlCommand varchar(MAX) = null, @Deleted bit = null, @OriginalId int = null, @Delimited bit = null, @SqlSource bit = null, @Page int = null, @PageSize int = null) 
AS
	SET NOCOUNT ON;
	SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
	INTO #RESUL
	FROM dbo.[BcpImport] AS PAG
	WHERE (@Repository_Id is null or [Repository_Id] = @Repository_Id)
		 and (@Repository_Ids is null or [Repository_Id] in (select * from dbo.SplitID(@Repository_Ids)))
		 and (@ProcessConfig_Id is null or [ProcessConfig_Id] = @ProcessConfig_Id)
		 and (@ProcessConfig_Ids is null or [ProcessConfig_Id] in (select * from dbo.SplitID(@ProcessConfig_Ids)))
		 and (@Name is null or [Name] like @Name)
		 and (@RepositoryConfig_Id is null or [RepositoryConfig_Id] = @RepositoryConfig_Id)
		 and (@RepositoryConfig_Ids is null or [RepositoryConfig_Id] in (select * from dbo.SplitID(@RepositoryConfig_Ids)))
		 and (@RepositoryCode is null or [RepositoryCode] like @RepositoryCode)
		 and (@Path is null or [Path] like @Path)
		 and (@Delimiter is null or [Delimiter] like @Delimiter)
		 and (@HasHeaderRow is null or [HasHeaderRow] = @HasHeaderRow)
		 and (@EnclosedInQuotes is null or [EnclosedInQuotes] = @EnclosedInQuotes)
		 and (@Conexion_Id is null or [Conexion_Id] = @Conexion_Id)
		 and (@Conexion_Ids is null or [Conexion_Id] in (select * from dbo.SplitID(@Conexion_Ids)))
		 and (@SqlCommand is null or [SqlCommand] like @SqlCommand)
		 and (@Deleted is null or [Deleted] = @Deleted)
		 and (@OriginalId is null or [OriginalId] = @OriginalId)
		 and (@Delimited is null or [Delimited] = @Delimited)
		 and (@SqlSource is null or [SqlSource] = @SqlSource)

	DECLARE @RowsTotal int
	SET @RowsTotal = @@ROWCOUNT

	SELECT *, @RowsTotal AS RowsTotal
	FROM #RESUL
	WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

	DROP TABLE #RESUL

GO
-------------------------------------
CREATE PROCEDURE [dbo].[BcpImport_Sp_GetByProcessConfig_Id]  
(@ProcessConfig_Id smallint = null, @lstId varchar(MAX) = null, @Repository_Id int)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[BcpImport] 
	WHERE   
	   ((not @ProcessConfig_Id is null and [ProcessConfig_Id] = @ProcessConfig_Id)
	   or (not @lstId is null and [ProcessConfig_Id]  in(select * from dbo.SplitID(@lstId))))
	   and Repository_Id = @Repository_Id

GO
-------------------------------------
CREATE PROCEDURE [dbo].[BcpImport_Sp_GetByRepository_Id]  
(@Repository_Id int = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[BcpImport] 
	WHERE   
	   ((not @Repository_Id is null and [Repository_Id] = @Repository_Id)
	   or (not @lstId is null and [Repository_Id]  in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[BcpImport_Sp_GetByRepositoryConfig_Id]  
(@RepositoryConfig_Id smallint = null, @lstId varchar(MAX) = null, @Repository_Id int)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[BcpImport] 
	WHERE   
	   ((not @RepositoryConfig_Id is null and [RepositoryConfig_Id] = @RepositoryConfig_Id)
	   or (not @lstId is null and [RepositoryConfig_Id]  in(select * from dbo.SplitID(@lstId))))
	   and Repository_Id = @Repository_Id

GO
-------------------------------------
CREATE PROCEDURE [dbo].[BcpImport_Sp_Save]
(@Id int, @Repository_Id int, @ProcessConfig_Id smallint, @Name varchar(100), @RepositoryConfig_Id smallint, @RepositoryCode varchar(100), @Path varchar(255), @Delimiter varchar(5), @HasHeaderRow bit, @EnclosedInQuotes bit, @Conexion_Id int, @SqlCommand varchar(MAX), @Deleted bit, @OriginalId int = null, @Delimited bit, @SqlSource bit)
AS
	IF (SELECT COUNT(*) from dbo.[BcpImport] WHERE ( [Id] = @Id AND  [Repository_Id] = @Repository_Id)  ) > 0
		BEGIN
			UPDATE dbo.[BcpImport]
				SET  [ProcessConfig_Id] = @ProcessConfig_Id, [Name] = @Name, [RepositoryConfig_Id] = @RepositoryConfig_Id, [RepositoryCode] = @RepositoryCode, [Path] = @Path, [Delimiter] = @Delimiter, [HasHeaderRow] = @HasHeaderRow, [EnclosedInQuotes] = @EnclosedInQuotes, [Conexion_Id] = @Conexion_Id, [SqlCommand] = @SqlCommand, [Deleted] = @Deleted, [OriginalId] = @OriginalId, [Delimited] = @Delimited, [SqlSource] = @SqlSource
				WHERE ( [Id] = @Id AND  [Repository_Id] = @Repository_Id)
			SELECT @Id as Id
		END
	ELSE
		BEGIN
        
			INSERT INTO dbo.[BcpImport]   
				  ([Repository_Id], [ProcessConfig_Id], [Name], [RepositoryConfig_Id], [RepositoryCode], [Path], [Delimiter], [HasHeaderRow], [EnclosedInQuotes], [Conexion_Id], [SqlCommand], [Deleted], [OriginalId], [Delimited], [SqlSource]) 
		   VALUES (@Repository_Id , @ProcessConfig_Id , @Name , @RepositoryConfig_Id , @RepositoryCode , @Path , @Delimiter , @HasHeaderRow , @EnclosedInQuotes , @Conexion_Id , @SqlCommand , @Deleted , @OriginalId , @Delimited , @SqlSource )
			SELECT SCOPE_IDENTITY() as Id
		END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Comment_Sp_Get]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[Comment] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------
CREATE PROCEDURE [dbo].[Comment_Sp_GetAll]
WITH 
EXECUTE AS CALLER
AS
SET NOCOUNT ON;
SELECT * FROM dbo.[Comment]

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Comment_Sp_GetByFilter] 
(@Process_Id int = null, @Message varchar(2100) = null, @User_Id int = null, @Date datetime = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;

SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[Comment] AS PAG
WHERE (@Process_Id is null or [Process_Id] = @Process_Id)
	 and (@Message is null or [Message] = @Message)
	 and (@User_Id is null or [User_Id] = @User_Id)
	 and (@Date is null or [Date] = @Date)

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Comment_Sp_GetByProcess_Id]
(@Process_Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[Comment] 
WHERE ((not @Process_Id is null 
        and [Process_Id] = @Process_Id)
   or (not @lstId is null
        and [Process_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Comment_Sp_GetByUser_Id]
(@User_Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[Comment] 
WHERE ((not @User_Id is null 
        and [User_Id] = @User_Id)
   or (not @lstId is null
        and [User_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Comment_Sp_GetLastComment]
WITH 
EXECUTE AS CALLER
AS
SELECT TOP 1 [Message]
FROM [Comment]
order by Id desc

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Comment_Sp_Save]
(@Process_Id int, @Message varchar(2100), @User_Id int, @Id int, @Date datetime) 
as
IF (SELECT COUNT(*) from dbo.[Comment]  WHERE  [Id] = @Id) > 0
    BEGIN
        UPDATE dbo.[Comment]
             SET  [Process_Id] = @Process_Id, [Message] = @Message, [User_Id] = @User_Id, [Date] = @Date
             WHERE  [Id] = @Id
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[Comment]   
               ([Process_Id], [Message], [User_Id], [Date]) 
        VALUES(@Process_Id,@Message,@User_Id,@Date)
        SELECT SCOPE_IDENTITY() as Id
    END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Conexion_Sp_CopyRepositoryData]
(@FromRepository_Id int = 0,@ToRepository_Id int, @ProcessConfig_Id smallint = null)
AS
SET NOCOUNT ON;
SET IDENTITY_INSERT [Conexion] ON

insert into [Conexion] ([Id], [Repository_Id],[Name], [Code], [Provider], [ConexionString], [Encrypted], [Deleted])
  Select [Id], @ToRepository_Id as [Repository_Id],[Name], [Code], [Provider], [ConexionString], [Encrypted], [Deleted]
  From [Conexion]
  Where Repository_Id = @FromRepository_Id 

SET IDENTITY_INSERT [Conexion] OFF


GO
-------------------------------------
CREATE PROCEDURE [dbo].[Conexion_Sp_Delete]
( 
@Id smallint = null, @lstId varchar(MAX) = null
, @Repository_Id int
)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[Conexion] 
WHERE  
    
    ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))
    and Repository_Id = @Repository_Id


GO
-------------------------------------
CREATE PROCEDURE [dbo].[Conexion_Sp_Get]  
( @Id smallint = null, @lstId varchar(MAX) = null 
, @Repository_Id int)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[Conexion] 
WHERE   
    ((not @Id is null and [Id] = @Id)
   or (not @lstId is null and [Id] in(select * from dbo.SplitID(@lstId))))
   and Repository_Id = @Repository_Id
GO


-------------------------------------
CREATE PROCEDURE [dbo].[Conexion_Sp_GetAll] (@Repository_Id int)
AS
SET NOCOUNT ON;
SELECT * 
FROM dbo.[Conexion]
WHERE Repository_Id = @Repository_Id

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Conexion_Sp_GetByFilter] 
(@Repository_Id int = null, @Repository_Ids varchar(MAX) = null, @Name varchar(255) = null, @Code varchar(50) = null, @Provider varchar(512) = null, @ConexionString varchar(512) = null, @Encrypted bit = null, @Deleted bit = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;
SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[Conexion] AS PAG
WHERE (@Repository_Id is null or [Repository_Id] = @Repository_Id)
     and (@Repository_Ids is null or [Repository_Id] in (select * from dbo.SplitID(@Repository_Ids)))
     and (@Name is null or [Name] like @Name)
     and (@Code is null or [Code] like @Code)
     and (@Provider is null or [Provider] like @Provider)
     and (@ConexionString is null or [ConexionString] like @ConexionString)
     and (@Encrypted is null or [Encrypted] = @Encrypted)
     and (@Deleted is null or [Deleted] = @Deleted)

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL
GO


-------------------------------------
CREATE PROCEDURE [dbo].[Conexion_Sp_GetByRepository_Id]
(@Repository_Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[Conexion] 
WHERE ((not @Repository_Id is null 
        and [Repository_Id] = @Repository_Id)
   or (not @lstId is null
        and [Repository_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Conexion_Sp_Save]
(@Id smallint, @Repository_Id int, @Name varchar(255), @Code varchar(50), @Provider varchar(512), @ConexionString varchar(512), @Encrypted bit, @Deleted bit)
as
IF (SELECT COUNT(*) from dbo.[Conexion] WHERE ( [Id] = @Id AND  [Repository_Id] = @Repository_Id)  ) > 0
    BEGIN
        UPDATE dbo.[Conexion]
            SET  [Name] = @Name, [Code] = @Code, [Provider] = @Provider, [ConexionString] = @ConexionString, [Encrypted] = @Encrypted, [Deleted] = @Deleted
            WHERE ( [Id] = @Id AND  [Repository_Id] = @Repository_Id)
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[Conexion]   
              ([Repository_Id], [Name], [Code], [Provider], [ConexionString], [Encrypted], [Deleted]) 
       VALUES (@Repository_Id , @Name , @Code , @Provider , @ConexionString , @Encrypted , @Deleted )
        SELECT SCOPE_IDENTITY() as Id
    END
GO


-------------------------------------
CREATE PROCEDURE [dbo].[DataType_Sp_Delete]
(@Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[DataType] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[DataType_Sp_Get]
(@Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[DataType] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[DataType_Sp_GetAll] 
AS
SET NOCOUNT ON;
SELECT * FROM dbo.[DataType]

GO
-------------------------------------
CREATE PROCEDURE [dbo].[DataType_Sp_GetByFilter] 
(@Behavior tinyint = null, @SQL varchar(50) = null, @C varchar(50) = null, @Parameter varchar(50) = null, @Specified_Length bit = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;

SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[DataType] AS PAG
WHERE (@Behavior is null or [Behavior] = @Behavior)
	 and (@SQL is null or [SQL] = @SQL)
	 and (@C is null or [C] = @C)
	 and (@Parameter is null or [Parameter] = @Parameter)
	 and (@Specified_Length is null or [Specified_Length] = @Specified_Length)

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL

GO
-------------------------------------
CREATE PROCEDURE [dbo].[DataType_Sp_Save]
(@Id smallint, @Behavior tinyint, @SQL varchar(50), @C varchar(50), @Parameter varchar(50), @Specified_Length bit) 
as
IF (SELECT COUNT(*) from dbo.[DataType]  WHERE  [Id] = @Id) > 0
    BEGIN
        UPDATE dbo.[DataType]
             SET  [Behavior] = @Behavior, [SQL] = @SQL, [C] = @C, [Parameter] = @Parameter, [Specified_Length] = @Specified_Length
             WHERE  [Id] = @Id
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[DataType]   
               ([Id], [Behavior], [SQL], [C], [Parameter], [Specified_Length]) 
        VALUES(@Id,@Behavior,@SQL,@C,@Parameter,@Specified_Length)
        SELECT SCOPE_IDENTITY() as Id
    END
GO
-------------------------------------
CREATE PROCEDURE [dbo].[DynamicDataSet_Sp_Get]
(@Id bigint = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[DynamicDataSet] 
	WHERE ((not @Id is null 
			and [Id] = @Id)
	   or (not @lstId is null
			and [Id] in(select * from dbo.SplitID(@lstId))))
			
GO
-------------------------------------
CREATE PROCEDURE [dbo].[DynamicDataSet_Sp_GetAll] 
AS
	SET NOCOUNT ON;
	SELECT * FROM dbo.[DynamicDataSet]

GO
-------------------------------------
CREATE PROCEDURE [dbo].[DynamicDataSet_Sp_GetByEntity_Id]
(@Entity_Id int = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[DynamicDataSet] 
	WHERE ((not @Entity_Id is null 
			and [Entity_Id] = @Entity_Id)
	   or (not @lstId is null
			and [Entity_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[DynamicDataSet_Sp_GetByFilter] 
(@Type_Id bigint = null, @Entity_Id int = null, @Date datetime = null, @Page int = null, @PageSize int = null) 
AS
	SET NOCOUNT ON;

	SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
	INTO #RESUL
	FROM dbo.[DynamicDataSet] AS PAG
	WHERE (@Type_Id is null or [Type_Id] = @Type_Id)
		 and (@Entity_Id is null or [Entity_Id] = @Entity_Id)
		 and (@Date is null or [Date] = @Date)

	DECLARE @RowsTotal int
	SET @RowsTotal = @@ROWCOUNT

	SELECT *, @RowsTotal AS RowsTotal
	FROM #RESUL
	WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

	DROP TABLE #RESUL

GO
-------------------------------------
CREATE PROCEDURE [dbo].[DynamicDataSet_Sp_GetByType_Id]
(@Type_Id bigint = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[DynamicDataSet] 
	WHERE ((not @Type_Id is null 
			and [Type_Id] = @Type_Id)
	   or (not @lstId is null
			and [Type_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[DynamicDataSet_Sp_Save]
(@Id bigint, @Type_Id bigint, @Entity_Id int, @Date datetime) 
AS
	IF (SELECT COUNT(*) from dbo.[DynamicDataSet]  WHERE  [Id] = @Id) > 0
		BEGIN
			UPDATE dbo.[DynamicDataSet]
				 SET  [Type_Id] = @Type_Id, [Entity_Id] = @Entity_Id, [Date] = @Date
				 WHERE  [Id] = @Id
			SELECT @Id as Id
		END
	ELSE
		BEGIN
        
			INSERT INTO dbo.[DynamicDataSet]   
				   ([Type_Id], [Entity_Id], [Date]) 
			VALUES(@Type_Id,@Entity_Id,@Date)
			SELECT SCOPE_IDENTITY() as Id
		END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[DynamicDataSetData_Sp_GetByDynamicDataSetRow_Id]
(@DynamicDataSetRow_Id bigint = null, @lstId varchar(MAX) = null)
AS
	BEGIN
		SET NOCOUNT ON;
		SELECT * FROM dbo.[DynamicDataSetData] 
		WHERE (not @DynamicDataSetRow_Id is null 
				and [DynamicDataSetRow_Id] = @DynamicDataSetRow_Id)
		   or (not @lstId is null
				and [DynamicDataSetRow_Id] in(select * from dbo.SplitID(@lstId)))      
	END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[DynamicDataSetData_Sp_GetByFilter] 
(@Row_DynamicDataSetRow_Id bigint = null, @Struct_Id smallint = null, @OldValue varchar(MAX) = null, @Value varchar(MAX) = null, @Page int = null, @PageSize int = null) 
AS
	SET NOCOUNT ON;

	SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
	INTO #RESUL
	FROM dbo.[DynamicDataSetData] AS PAG
	WHERE (@Row_DynamicDataSetRow_Id is null or [DynamicDataSetRow_Id] = @Row_DynamicDataSetRow_Id)
		 and (@Struct_Id is null or [Struct_Id] = @Struct_Id)
		 and (@OldValue is null or [OldValue] = @OldValue)
		 and (@Value is null or [Value] = @Value)

	DECLARE @RowsTotal int
	SET @RowsTotal = @@ROWCOUNT

	SELECT *, @RowsTotal AS RowsTotal
	FROM #RESUL
	WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

	DROP TABLE #RESUL

GO
-------------------------------------
CREATE PROCEDURE [dbo].[DynamicDataSetData_Sp_GetByRow_DynamicDataSetRow_Id]
(@Row_DynamicDataSetRow_Id bigint = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[DynamicDataSetData] 
	WHERE ((not @Row_DynamicDataSetRow_Id is null 
			and [DynamicDataSetRow_Id] = @Row_DynamicDataSetRow_Id)
	   or (not @lstId is null
			and [DynamicDataSetRow_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[DynamicDataSetData_Sp_GetByStruct_Id]
(@Struct_Id smallint = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[DynamicDataSetData] 
	WHERE ((not @Struct_Id is null 
			and [Struct_Id] = @Struct_Id)
	   or (not @lstId is null
			and [Struct_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[DynamicDataSetData_Sp_Save]
(@Id bigint, @DynamicDataSetRow_Id bigint, @Struct_Id smallint, @OldValue varchar(MAX), @Value varchar(MAX))
as
IF (SELECT COUNT(*) from dbo.[DynamicDataSetData] WHERE ( [Id] = @Id)  ) > 0
    BEGIN
        UPDATE dbo.[DynamicDataSetData]
            SET  [DynamicDataSetRow_Id] = @DynamicDataSetRow_Id, [Struct_Id] = @Struct_Id, [OldValue] = @OldValue, [Value] = @Value
            WHERE ( [Id] = @Id)
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[DynamicDataSetData]   
              ([DynamicDataSetRow_Id], [Struct_Id], [OldValue], [Value]) 
       VALUES (@DynamicDataSetRow_Id , @Struct_Id , @OldValue , @Value )
        SELECT SCOPE_IDENTITY() as Id
    END
GO


-------------------------------------
CREATE PROCEDURE [dbo].[DynamicDataSetRow_Sp_Delete]
(@Id bigint = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;
	DELETE FROM dbo.[DynamicDataSetRow] 
	WHERE ((not @Id is null 
			and [Id] = @Id)
	   or (not @lstId is null
			and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[DynamicDataSetRow_Sp_Get]
(@Id bigint = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[DynamicDataSetRow] 
	WHERE ((not @Id is null 
			and [Id] = @Id)
	   or (not @lstId is null
			and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[DynamicDataSetRow_Sp_GetAll] 
AS
	SET NOCOUNT ON;
	SELECT * FROM dbo.[DynamicDataSetRow]

GO
-------------------------------------
CREATE PROCEDURE [dbo].[DynamicDataSetRow_Sp_GetByAccion_Type_Id]
(@Accion_Type_Id bigint = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[DynamicDataSetRow] 
	WHERE ((not @Accion_Type_Id is null 
			and [Accion_Type_Id] = @Accion_Type_Id)
	   or (not @lstId is null
			and [Accion_Type_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[DynamicDataSetRow_Sp_GetByDynamicDataSet_Id]
(@DynamicDataSet_Id bigint = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[DynamicDataSetRow] 
	WHERE ((not @DynamicDataSet_Id is null 
			and [DynamicDataSet_Id] = @DynamicDataSet_Id)
	   or (not @lstId is null
			and [DynamicDataSet_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[DynamicDataSetRow_Sp_GetByFilter] 
(@DynamicDataSet_Id bigint = null, @Accion_Type_Id bigint = null, @UniqueId bigint = null, @Page int = null, @PageSize int = null) 
AS
	SET NOCOUNT ON;

	SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
	INTO #RESUL
	FROM dbo.[DynamicDataSetRow] AS PAG
	WHERE (@DynamicDataSet_Id is null or [DynamicDataSet_Id] = @DynamicDataSet_Id)
		 and (@Accion_Type_Id is null or [Accion_Type_Id] = @Accion_Type_Id)
		 and (@UniqueId is null or [UniqueId] = @UniqueId)

	DECLARE @RowsTotal int
	SET @RowsTotal = @@ROWCOUNT

	SELECT *, @RowsTotal AS RowsTotal
	FROM #RESUL
	WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

	DROP TABLE #RESUL

GO
-------------------------------------
CREATE PROCEDURE [dbo].[DynamicDataSetRow_Sp_Save]
(@Id bigint, @DynamicDataSet_Id bigint, @Accion_Type_Id bigint, @UniqueId bigint) 
AS
	IF (SELECT COUNT(*) from dbo.[DynamicDataSetRow]  WHERE  [Id] = @Id) > 0
		BEGIN
			UPDATE dbo.[DynamicDataSetRow]
				 SET  [DynamicDataSet_Id] = @DynamicDataSet_Id, [Accion_Type_Id] = @Accion_Type_Id, [UniqueId] = @UniqueId
				 WHERE  [Id] = @Id
			SELECT @Id as Id
		END
	ELSE
		BEGIN
        
			INSERT INTO dbo.[DynamicDataSetRow]   
				   ([DynamicDataSet_Id], [Accion_Type_Id], [UniqueId]) 
			VALUES(@DynamicDataSet_Id,@Accion_Type_Id,@UniqueId)
			SELECT SCOPE_IDENTITY() as Id
		END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Entity_Sp_Delete]
(@Id int = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;
	DELETE FROM dbo.[Entity] 
	WHERE ((not @Id is null 
			and [Id] = @Id)
	   or (not @lstId is null
			and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Entity_Sp_Get]
(@Id int = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[Entity] 
	WHERE ((not @Id is null 
			and [Id] = @Id)
	   or (not @lstId is null
			and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Entity_Sp_GetAll] 
AS
	SET NOCOUNT ON;
	SELECT * FROM dbo.[Entity]

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Entity_Sp_GetByFilter] 
(@Name varchar(255) = null, @NameClass varchar(255) = null, @Description varchar(255) = null, @Class varchar(255) = null, @Assembly varchar(255) = null, @Page int = null, @PageSize int = null) 
AS
	SET NOCOUNT ON;

	SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
	INTO #RESUL
	FROM dbo.[Entity] AS PAG
	WHERE (@Name is null or [Name] = @Name)
		 and (@NameClass is null or [NameClass] = @NameClass)
		 and (@Description is null or [Description] = @Description)
		 and (@Class is null or [Class] = @Class)
		 and (@Assembly is null or [Assembly] = @Assembly)

	DECLARE @RowsTotal int
	SET @RowsTotal = @@ROWCOUNT

	SELECT *, @RowsTotal AS RowsTotal
	FROM #RESUL
	WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

	DROP TABLE #RESUL

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Entity_Sp_GetByName]
(@Name varchar(255))
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[Entity] 
	WHERE [Name] = @Name

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Entity_Sp_Save]
@Id int, @Name varchar(255), @NameClass varchar(255), @Description varchar(255), @Class varchar(255), @Assembly varchar(255), @LargeData bit
WITH 
EXECUTE AS CALLER
AS
	IF (SELECT COUNT(*) from dbo.[Entity]  WHERE  [Id] = @Id) > 0
		BEGIN
			UPDATE dbo.[Entity]
				 SET  [Name] = @Name, [NameClass] = @NameClass, [Description] = @Description, [Class] = @Class, [Assembly] = @Assembly,[LargeData] = @LargeData
				 WHERE  [Id] = @Id
			SELECT @Id as Id
		END
	ELSE
		BEGIN
        
			INSERT INTO dbo.[Entity]   
				   ([Name], [NameClass], [Description], [Class], [Assembly],[LargeData]) 
			VALUES(@Name,@NameClass,@Description,@Class,@Assembly,@LargeData)
			SELECT SCOPE_IDENTITY() as Id
		END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[File_Sp_Delete]
(@Company_Id int = null, @Id bigint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[File] 
WHERE (@Company_Id is null or Company_Id = @Company_Id or Company_Id = 0)
   and ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[File_Sp_Get]
(@Company_Id int = null, @Id bigint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[File] 
WHERE (@Company_Id is null or Company_Id = @Company_Id or Company_Id = 0)
   and ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[File_Sp_GetAll]
(@Company_Id int = null)  
AS
SET NOCOUNT ON;
SELECT * FROM dbo.[File]
WHERE @Company_Id is null or Company_Id = @Company_Id or Company_Id = 0

GO
-------------------------------------
CREATE PROCEDURE [dbo].[File_Sp_Save]
@Id bigint, @Name varchar(255), @Content varbinary(MAX), @ContentType varchar(100), @Company_Id int = null
WITH 
EXECUTE AS CALLER
AS
IF (SELECT COUNT(*) from dbo.[File]  WHERE  [Id] = @Id) > 0
    BEGIN
        UPDATE dbo.[File]
             SET  [Name] = @Name, [Content] = @Content, [ContentType] = @ContentType, [Company_Id] = @Company_Id
             WHERE  [Id] = @Id
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[File]   
               ([Name], [Content], [ContentType], [Company_Id]) 
        VALUES(@Name,@Content,@ContentType,@Company_Id)
        SELECT SCOPE_IDENTITY() as Id
    END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[FrequencyHolyDay_Sp_Delete]
(@Id int = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;
	DELETE FROM dbo.[FrequencyHolyDay] 
	WHERE ((not @Id is null 
			and [Id] = @Id)
	   or (not @lstId is null
			and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[FrequencyHolyDay_Sp_Get]
(@Id int = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[FrequencyHolyDay] 
	WHERE ((not @Id is null 
			and [Id] = @Id)
	   or (not @lstId is null
			and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[FrequencyHolyDay_Sp_GetAll] 
AS
	SET NOCOUNT ON;
	SELECT * FROM dbo.[FrequencyHolyDay]

GO
-------------------------------------
CREATE PROCEDURE [dbo].[FrequencyHolyDay_Sp_GetByFilter] 
(@Name varchar(255) = null, @Date date = null, @Deleted bit = null, @Page int = null, @PageSize int = null) 
AS
	SET NOCOUNT ON;

	SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
	INTO #RESUL
	FROM dbo.[FrequencyHolyDay] AS PAG
	WHERE (@Name is null or [Name] = @Name)
		 and (@Date is null or [Date] = @Date)
		 and (@Deleted is null or [Deleted] = @Deleted)

	DECLARE @RowsTotal int
	SET @RowsTotal = @@ROWCOUNT

	SELECT *, @RowsTotal AS RowsTotal
	FROM #RESUL
	WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

	DROP TABLE #RESUL

GO
-------------------------------------
CREATE PROCEDURE [dbo].[FrequencyHolyDay_Sp_Save]
(@Id int, @Name varchar(255), @Date date, @Deleted bit) 
AS
	IF (SELECT COUNT(*) from dbo.[FrequencyHolyDay]  WHERE  [Id] = @Id) > 0
		BEGIN
			UPDATE dbo.[FrequencyHolyDay]
				 SET  [Name] = @Name, [Date] = @Date, [Deleted] = @Deleted
				 WHERE  [Id] = @Id
			SELECT @Id as Id
		END
	ELSE
		BEGIN
        
			INSERT INTO dbo.[FrequencyHolyDay]   
				   ([Name], [Date], [Deleted]) 
			VALUES(@Name,@Date,@Deleted)
			SELECT SCOPE_IDENTITY() as Id
		END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[FrequencySimpleInput_Sp_Delete]
(@Id int = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;

	DELETE FROM dbo.[FrequencySimpleInput] 
	WHERE  
    
		((not @Id is null 
			and [Id] = @Id)
	   or (not @lstId is null
			and [Id] in(select * from dbo.SplitID(@lstId))))


GO
-------------------------------------
CREATE PROCEDURE [dbo].[FrequencySimpleInput_Sp_Get]  
(@Id int = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[FrequencySimpleInput] 
	WHERE   
		((not @Id is null and [Id] = @Id)
	   or (not @lstId is null and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[FrequencySimpleInput_Sp_GetAll] 
AS
	SET NOCOUNT ON;
	SELECT * 
	FROM dbo.[FrequencySimpleInput]

GO
-------------------------------------
CREATE PROCEDURE [dbo].[FrequencySimpleInput_Sp_GetByFilter] 
(@Name varchar(100) = null, @Frequency_Type_Id smallint = null, @Frequency_Type_Ids varchar(MAX) = null, @FrequencyIncrease smallint = null, @FrequencyAll bit = null, @Page int = null, @PageSize int = null) 
AS
	SET NOCOUNT ON;
	SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
	INTO #RESUL
	FROM dbo.[FrequencySimpleInput] AS PAG
	WHERE (@Name is null or [Name] like @Name)
		 and (@Frequency_Type_Id is null or [Frequency_Type_Id] = @Frequency_Type_Id)
		 and (@Frequency_Type_Ids is null or [Frequency_Type_Id] in (select * from dbo.SplitID(@Frequency_Type_Ids)))
		 and (@FrequencyIncrease is null or [FrequencyIncrease] = @FrequencyIncrease)
		 and (@FrequencyAll is null or [FrequencyAll] = @FrequencyAll)

	DECLARE @RowsTotal int
	SET @RowsTotal = @@ROWCOUNT

	SELECT *, @RowsTotal AS RowsTotal
	FROM #RESUL
	WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

	DROP TABLE #RESUL

GO
-------------------------------------
CREATE PROCEDURE [dbo].[FrequencySimpleInput_Sp_GetByFrequency_Type_Id]  
(@Frequency_Type_Id smallint = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[FrequencySimpleInput] 
	WHERE   
	   ((not @Frequency_Type_Id is null and [Frequency_Type_Id] = @Frequency_Type_Id)
	   or (not @lstId is null and [Frequency_Type_Id]  in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[FrequencySimpleInput_Sp_Save]
(@Id int, @Name varchar(100), @Frequency_Type_Id smallint, @FrequencyIncrease smallint, @FrequencyAll bit)
AS
	IF (SELECT COUNT(*) from dbo.[FrequencySimpleInput] WHERE ( [Id] = @Id)  ) > 0
		BEGIN
			UPDATE dbo.[FrequencySimpleInput]
				SET  [Name] = @Name, [Frequency_Type_Id] = @Frequency_Type_Id, [FrequencyIncrease] = @FrequencyIncrease, [FrequencyAll] = @FrequencyAll
				WHERE ( [Id] = @Id)
			SELECT @Id as Id
		END
	ELSE
		BEGIN
        
			INSERT INTO dbo.[FrequencySimpleInput]   
				  ([Name], [Frequency_Type_Id], [FrequencyIncrease], [FrequencyAll]) 
		   VALUES (@Name , @Frequency_Type_Id , @FrequencyIncrease , @FrequencyAll )
			SELECT SCOPE_IDENTITY() as Id
		END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Grid_Sp_Delete]
( 
@Id int = null, @lstId varchar(MAX) = null

)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[Grid] 
WHERE  
    
    ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Grid_Sp_Get]  
( @Id int = null, @lstId varchar(MAX) = null 
)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[Grid] 
WHERE   
    ((not @Id is null and [Id] = @Id)
   or (not @lstId is null and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Grid_Sp_GetAll] 
AS
SET NOCOUNT ON;
SELECT * 
FROM dbo.[Grid]

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Grid_Sp_GetByFilter] 
(@Id int = null, @Name varchar(150) = null, @Code varchar(100) = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;

SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[Grid] AS PAG
WHERE (@Id is null or [Id] = @Id)
	 and (@Name is null or [Name] = @Name)
	 and (@Code is null or [Code] = @Code)

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Grid_Sp_Save]
(@Id int, @Name varchar(150), @Code varchar(100))
as
IF (SELECT COUNT(*) from dbo.[Grid] WHERE ( [Id] = @Id)  ) > 0
    BEGIN
        UPDATE dbo.[Grid]
            SET  [Name] = @Name, [Code] = @Code
            WHERE ( [Id] = @Id)
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[Grid]   
              ([Name], [Code]) 
       VALUES (@Name , @Code )
        SELECT SCOPE_IDENTITY() as Id
    END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[GridCustomView_Sp_Delete]
( 
@Id bigint = null, @lstId varchar(MAX) = null

)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[GridCustomView] 
WHERE  
    
    ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[GridCustomView_Sp_Get]  
( @Id bigint = null, @lstId varchar(MAX) = null 
)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[GridCustomView] 
WHERE   
    ((not @Id is null and [Id] = @Id)
   or (not @lstId is null and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[GridCustomView_Sp_GetAll]  
AS
SET NOCOUNT ON;
SELECT * 
FROM dbo.[GridCustomView]

GO
-------------------------------------
CREATE PROCEDURE [dbo].[GridCustomView_Sp_GetByFilter] 
(@Id int = null,@Grid_Id int = null, @Grid_Ids varchar(MAX) = null, @Name varchar(50) = null, @State varchar(MAX) = null, @Owner_User_Id int = null, @Owner_User_Ids varchar(MAX) = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;

SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[GridCustomView] AS PAG
WHERE (@Grid_Id is null or [Grid_Id] = @Grid_Id)
	 and (@Grid_Ids is null or [Grid_Id] in (select * from dbo.SplitID(@Grid_Ids)))
	 and (@Name is null or [Name] = @Name)
	 and (@Id is null or [Id] = @Id)
	 and (@State is null or [State] = @State)
	 and (@Owner_User_Id is null or [Owner_User_Id] = @Owner_User_Id)
	 and (@Owner_User_Ids is null or [Owner_User_Id] in (select * from dbo.SplitID(@Owner_User_Ids)))

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL

GO
-------------------------------------
CREATE PROCEDURE [dbo].[GridCustomView_Sp_GetByGrid_Id]  
( @Grid_Id int = null, @lstId varchar(MAX) = null
)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[GridCustomView] 
WHERE   
   ((not @Grid_Id is null and [Grid_Id] = @Grid_Id)
   or (not @lstId is null and [Grid_Id]  in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[GridCustomView_Sp_GetByOwner_User_Id]  
( @Owner_User_Id int = null, @lstId varchar(MAX) = null
)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[GridCustomView] 
WHERE   
   ((not @Owner_User_Id is null and [Owner_User_Id] = @Owner_User_Id)
   or (not @lstId is null and [Owner_User_Id]  in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------            
CREATE PROCEDURE [dbo].[GridCustomView_Sp_GetForUser]  
( @User_Id bigint,
@grid_id bigint
)
AS
SET NOCOUNT ON;
--DECLARE @User_Id bigint = 2
--DECLARE @grid_id bigint = 8
select distinct GridCustomView.* 
from dbo.GridCustomView
where Owner_User_Id=@User_Id and Grid_Id=@grid_id
union

select GridCustomView.* from UserProfile 
join GridCustomViewShared on GridCustomViewShared.Profile_Id = UserProfile.Profile_Id 
and UserProfile.User_Id=@User_Id 
join GridCustomView 
on GridCustomView.Id  = GridCustomViewShared.GridCustomView_Id 
and GridCustomView.Grid_Id=@grid_id


GO
-------------------------------------
CREATE PROCEDURE [dbo].[GridCustomView_Sp_Save]
(@Id bigint, @Grid_Id int, @Name varchar(50), @State varchar(MAX), @Owner_User_Id int)
as
IF (SELECT COUNT(*) from dbo.[GridCustomView] WHERE ( [Id] = @Id)  ) > 0
    BEGIN
        UPDATE dbo.[GridCustomView]
            SET  [Grid_Id] = @Grid_Id, [Name] = @Name, [State] = @State, [Owner_User_Id] = @Owner_User_Id
            WHERE ( [Id] = @Id)
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[GridCustomView]   
              ([Grid_Id], [Name], [State], [Owner_User_Id]) 
       VALUES (@Grid_Id , @Name , @State , @Owner_User_Id )
        SELECT SCOPE_IDENTITY() as Id
    END

GO
-------------------------------------            
CREATE PROCEDURE [dbo].[GridCustomViewDefault_Sp_Delete]
( 
@Id bigint = null, @lstId varchar(MAX) = null

)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[GridCustomViewDefault] 
WHERE  
    
    ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))
    
GO
-------------------------------------            
CREATE PROCEDURE [dbo].[GridCustomViewDefault_Sp_Get]  
( @Id bigint = null, @lstId varchar(MAX) = null 
)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[GridCustomViewDefault] 
WHERE   
    ((not @Id is null and [Id] = @Id)
   or (not @lstId is null and [Id] in(select * from dbo.SplitID(@lstId))))
   
GO
-------------------------------------            
CREATE PROCEDURE [dbo].[GridCustomViewDefault_Sp_GetAll] 
AS
SET NOCOUNT ON;
SELECT * 
FROM dbo.[GridCustomViewDefault]

GO
-------------------------------------
CREATE PROCEDURE [dbo].[GridCustomViewDefault_Sp_GetByFilter] 
(@Grid_Id bigint = null, @Grid_Ids varchar(MAX) = null, @GridCustomView_Id bigint = null, @GridCustomView_Ids varchar(MAX) = null, @Date datetime = null, @DateStart datetime = null, @DateEnd datetime = null, @User_Id bigint = null, @User_Ids varchar(MAX) = null, @Profile_Id bigint = null, @Profile_Ids varchar(MAX) = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;

SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[GridCustomViewDefault] AS PAG
WHERE (@Grid_Id is null or [Grid_Id] = @Grid_Id)
	 and (@Grid_Ids is null or [Grid_Id] in (select * from dbo.SplitID(@Grid_Ids)))
	 and (@GridCustomView_Id is null or [GridCustomView_Id] = @GridCustomView_Id)
	 and (@GridCustomView_Ids is null or [GridCustomView_Id] in (select * from dbo.SplitID(@GridCustomView_Ids)))
	 and (@Date is null or [Date] = @Date)
	 and (@DateStart is null or [Date] between @DateStart and @DateEnd)
	 and (@User_Id is null or [User_Id] = @User_Id)
	 and (@User_Ids is null or [User_Id] in (select * from dbo.SplitID(@User_Ids)))
	 and (@Profile_Id is null or [Profile_Id] = @Profile_Id)
	 and (@Profile_Ids is null or [Profile_Id] in (select * from dbo.SplitID(@Profile_Ids)))

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL

GO
-------------------------------------            
CREATE PROCEDURE [dbo].[GridCustomViewDefault_Sp_GetByGrid_Id]  
( @Grid_Id bigint = null, @lstId varchar(MAX) = null
)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[GridCustomViewDefault] 
WHERE   
   ((not @Grid_Id is null and [Grid_Id] = @Grid_Id)
   or (not @lstId is null and [Grid_Id]  in(select * from dbo.SplitID(@lstId))))
   
GO
-------------------------------------
CREATE PROCEDURE [dbo].[GridCustomViewDefault_Sp_GetByGridCustomView_Id]  
( @GridCustomView_Id bigint = null, @lstId varchar(MAX) = null
)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[GridCustomViewDefault] 
WHERE   
   ((not @GridCustomView_Id is null and [GridCustomView_Id] = @GridCustomView_Id)
   or (not @lstId is null and [GridCustomView_Id]  in(select * from dbo.SplitID(@lstId))))
   
GO
-------------------------------------            
CREATE PROCEDURE [dbo].[GridCustomViewDefault_Sp_GetByProfile_Id]  
( @Profile_Id bigint = null, @lstId varchar(MAX) = null
)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[GridCustomViewDefault] 
WHERE   
   ((not @Profile_Id is null and [Profile_Id] = @Profile_Id)
   or (not @lstId is null and [Profile_Id]  in(select * from dbo.SplitID(@lstId))))
   
GO
-------------------------------------            
CREATE PROCEDURE [dbo].[GridCustomViewDefault_Sp_GetByUser_Id]  
( @User_Id bigint = null, @lstId varchar(MAX) = null
)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[GridCustomViewDefault] 
WHERE   
   ((not @User_Id is null and [User_Id] = @User_Id)
   or (not @lstId is null and [User_Id]  in(select * from dbo.SplitID(@lstId))))
   
GO
-------------------------------------            
CREATE PROCEDURE [dbo].[GridCustomViewDefault_Sp_GetForUser]  
( @User_Id bigint,
@grid_id bigint
)
AS
SET NOCOUNT ON;
--declare @User_Id bigint = 1
--declare @grid_id bigint = 2
select top 1 * 
from dbo.GridCustomViewDefault
left join [UserProfile]  on [UserProfile].[User_Id] = @User_Id
where grid_id=@grid_id and  
(GridCustomViewDefault.[USER_ID] = @user_id or [UserProfile].profile_id = GridCustomViewDefault.Profile_Id)
order by [date] desc

GO
-------------------------------------            
CREATE PROCEDURE [dbo].[GridCustomViewDefault_Sp_Save]
(@Id bigint, @Grid_Id bigint, @GridCustomView_Id bigint, @Date datetime, @User_Id bigint, @Profile_Id bigint)
as
IF (SELECT COUNT(*) from dbo.[GridCustomViewDefault] WHERE ( [Id] = @Id)  ) > 0
    BEGIN
        UPDATE dbo.[GridCustomViewDefault]
            SET  [Grid_Id] = @Grid_Id, [GridCustomView_Id] = @GridCustomView_Id, [Date] = @Date, [User_Id] = @User_Id, [Profile_Id] = @Profile_Id
            WHERE ( [Id] = @Id)
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[GridCustomViewDefault]   
              ([Grid_Id], [GridCustomView_Id], [Date], [User_Id], [Profile_Id]) 
       VALUES (@Grid_Id , @GridCustomView_Id , @Date , @User_Id , @Profile_Id )
        SELECT SCOPE_IDENTITY() as Id
    END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[GridCustomViewDefault_Sp_SetAsDefaultForUsers] 
(@GridCustomView_id bigint,@Ids varchar(max),@User_ID bigint)
AS
--declare @GridCustomView_id bigint = 238
--declare @Ids varchar(max) = '1,2'
--declare @User_ID bigint = 1
declare @New_id bigint=0
if (select COUNT(*) from GridCustomView where Id= @GridCustomView_id and Owner_User_Id=@User_ID)=1
begin
delete from GridCustomViewDefault 
where GridCustomView_Id= @GridCustomView_id and Profile_id not in (select data from SplitID(@Ids))

update GridCustomViewDefault 
set [Date] = GETDATE() where GridCustomView_id = @GridCustomView_id and Profile_id in (select data from SplitID(@Ids))

insert into GridCustomViewDefault
select (
		select GridCustomView.Grid_Id from GridCustomView
		 where GridCustomView.Id= @GridCustomView_id)
				,@GridCustomView_id
				,null,
				[data],
				GETDATE() 
from 
	SplitID(@Ids)
where 
	[Data] not in (
		select Profile_id 
		from GridCustomViewDefault 
		where GridCustomView_Id=@GridCustomView_id and Profile_Id is not null
)
end
else
begin
declare @indice_default varchar(5) = cast(
	(select COUNT(*) + 1
	from GridCustomView as g1
	where name like 
	(select g2.Name from GridCustomView as g2 where Id=@GridCustomView_id) + '-default%'
	) as varchar(5))
		
insert into 
	GridCustomView
select 
	grid_id,
	name + '-default-' + @indice_default,
	state,
	@User_ID
from 
	GridCustomView
where 
	Id=@GridCustomView_id
set @New_id = @@IDENTITY
insert into GridCustomViewDefault
select (select GridCustomView.Grid_Id from GridCustomView where GridCustomView.Id= @GridCustomView_id),
		@New_id,
		null
		,[data]
		,GETDATE() 
from 
	SplitID(@Ids)
where 
	[Data] not in (
		select Profile_id 
		from GridCustomViewDefault 
		where GridCustomView_Id=@GridCustomView_id and Profile_Id is not null
)
end
insert into GridCustomViewShared
select @GridCustomView_id,[data],GETDATE() from SplitID(@Ids)
where Data not in (select Profile_id from GridCustomViewShared where GridCustomView_id = @GridCustomView_id)
select @New_id

GO
-------------------------------------         
CREATE PROCEDURE [dbo].[GridCustomViewShared_Sp_Delete]
( 
@Id bigint = null, @lstId varchar(MAX) = null

)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[GridCustomViewShared] 
WHERE  
    
    ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))    
GO
-------------------------------------            
CREATE PROCEDURE [dbo].[GridCustomViewShared_Sp_Get]  
( @Id bigint = null, @lstId varchar(MAX) = null 
)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[GridCustomViewShared] 
WHERE   
    ((not @Id is null and [Id] = @Id)
   or (not @lstId is null and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------            
CREATE PROCEDURE [dbo].[GridCustomViewShared_Sp_GetAll] 
AS
SET NOCOUNT ON;
SELECT * 
FROM dbo.[GridCustomViewShared]

GO
-------------------------------------
CREATE PROCEDURE [dbo].[GridCustomViewShared_Sp_GetByFilter] 
(@Id bigint = null, @GridCustomView_Id bigint = null, @GridCustomView_Ids varchar(MAX) = null, @Profile_Id bigint = null, @Profile_Ids varchar(MAX) = null, @Date datetime = null, @DateStart datetime = null, @DateEnd datetime = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;

SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[GridCustomViewShared] AS PAG
WHERE (@Id is null or [Id] = @Id)
	 and (@GridCustomView_Id is null or [GridCustomView_Id] = @GridCustomView_Id)
	 and (@GridCustomView_Ids is null or [GridCustomView_Id] in (select * from dbo.SplitID(@GridCustomView_Ids)))
	 and (@Profile_Id is null or [Profile_Id] = @Profile_Id)
	 and (@Profile_Ids is null or [Profile_Id] in (select * from dbo.SplitID(@Profile_Ids)))
	 and (@Date is null or [Date] = @Date)
	 and (@DateStart is null or [Date] between @DateStart and @DateEnd)

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL

GO
-------------------------------------            
CREATE PROCEDURE [dbo].[GridCustomViewShared_Sp_GetByGridCustomView_Id]  
( @GridCustomView_Id bigint = null, @lstId varchar(MAX) = null
)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[GridCustomViewShared] 
WHERE   
   ((not @GridCustomView_Id is null and [GridCustomView_Id] = @GridCustomView_Id)
   or (not @lstId is null and [GridCustomView_Id]  in(select * from dbo.SplitID(@lstId))))
   
GO
-------------------------------------            
CREATE PROCEDURE [dbo].[GridCustomViewShared_Sp_GetByProfile_Id]  
( @Profile_Id bigint = null, @lstId varchar(MAX) = null
)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[GridCustomViewShared] 
WHERE   
   ((not @Profile_Id is null and [Profile_Id] = @Profile_Id)
   or (not @lstId is null and [Profile_Id]  in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------            
CREATE PROCEDURE [dbo].[GridCustomViewShared_Sp_Save]
(@Id bigint, @GridCustomView_Id bigint, @Profile_Id bigint, @Date datetime)
as
IF (SELECT COUNT(*) from dbo.[GridCustomViewShared] WHERE ( [Id] = @Id)  ) > 0
    BEGIN
        UPDATE dbo.[GridCustomViewShared]
            SET  [GridCustomView_Id] = @GridCustomView_Id, [Profile_Id] = @Profile_Id, [Date] = @Date
            WHERE ( [Id] = @Id)
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[GridCustomViewShared]   
              ([Id], [GridCustomView_Id], [Profile_Id], [Date]) 
       VALUES (@Id , @GridCustomView_Id , @Profile_Id , @Date )
        SELECT SCOPE_IDENTITY() as Id
    END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[GridCustomViewShared_Sp_Share] 
(@GridCustomView_id bigint,@Ids varchar(max))
AS
--declare @GridCustomView_id bigint = 280
--declare @Ids varchar(max) = ''

delete from GridCustomViewShared 
where GridCustomView_Id= @GridCustomView_id and Profile_id not in (select data from SplitID(@Ids))


update GridCustomViewShared 
set [Date] = GETDATE() where GridCustomView_id = @GridCustomView_id and Profile_id in (select data from SplitID(@Ids))

insert into GridCustomViewShared
select @GridCustomView_id,[data],GETDATE() from SplitID(@Ids)
where data <> '' and Data not in (select Profile_id from GridCustomViewShared where GridCustomView_id = @GridCustomView_id)


GO
-------------------------------------
CREATE PROCEDURE [dbo].[LogAccion_Sp_Delete]
(@Id bigint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[LogAccion] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[LogAccion_Sp_Get]
(@Id bigint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[LogAccion] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[LogAccion_Sp_GetAll] 
AS
SET NOCOUNT ON;
SELECT * FROM dbo.[LogAccion]
ORDER BY [DATE] DESC

GO
-------------------------------------
CREATE PROCEDURE [dbo].[LogAccion_Sp_GetByAccess_Id]
(@Access_Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[LogAccion] 
WHERE ((not @Access_Id is null 
        and [Access_Id] = @Access_Id)
   or (not @lstId is null
        and [Access_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[LogAccion_Sp_GetByAccion_Id]
(@Accion_Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[LogAccion] 
WHERE ((not @Accion_Id is null 
        and [Accion_Id] = @Accion_Id)
   or (not @lstId is null
        and [Accion_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[LogAccion_Sp_GetByAccionCategory_Id]
(@AccionCategory_Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[LogAccion_v] 
WHERE (not @AccionCategory_Id is null 
        and [AccionCategory_Id] = @AccionCategory_Id)
   or (not @lstId is null
        and [AccionCategory_Id] in(select * from dbo.SplitID(@lstId)))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[LogAccion_Sp_GetByDynamicDataSet_Id]
(@DynamicDataSet_Id bigint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[LogAccion] 
WHERE ((not @DynamicDataSet_Id is null 
        and [DynamicDataSet_Id] = @DynamicDataSet_Id)
   or (not @lstId is null
        and [DynamicDataSet_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[LogAccion_Sp_GetByFilter] 
(@Date datetime = null, @DateStart datetime = null, @DateEnd datetime = null, @User_Id int = null, @User_Ids varchar(MAX) = null, @Accion_Id int = null, @Accion_Ids varchar(MAX) = null, @AccionTo varchar(255) = null, @AccionToId bigint = null, @Access_Id int = null, @Access_Ids varchar(MAX) = null, @Data varchar(4000) = null, @DynamicDataSet_Id bigint = null, @DynamicDataSet_Ids varchar(MAX) = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;



SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[DATE] DESC) AS RowNumber 
INTO #RESUL
FROM dbo.[LogAccion] AS PAG
WHERE (@Date is null or [Date] = @Date)
	 and (@DateStart is null or Convert(date,[Date])between @DateStart and @DateEnd)
	 and (@User_Id is null or [User_Id] = @User_Id)
	 and (@User_Ids is null or [User_Id] in (select * from dbo.SplitID(@User_Ids)))
	 and (@Accion_Id is null or [Accion_Id] = @Accion_Id)
	 and (@Accion_Ids is null or [Accion_Id] in (select * from dbo.SplitID(@Accion_Ids)))
	 and (@AccionTo is null or [AccionTo] = @AccionTo)
	 and (@AccionToId is null or [AccionToId] = @AccionToId)
	 and (@Access_Id is null or [Access_Id] = @Access_Id)
	 and (@Access_Ids is null or [Access_Id] in (select * from dbo.SplitID(@Access_Ids)))
	 and (@Data is null or [Data] = @Data)
	 and (@DynamicDataSet_Id is null or [DynamicDataSet_Id] = @DynamicDataSet_Id)
	 and (@DynamicDataSet_Ids is null or [DynamicDataSet_Id] in (select * from dbo.SplitID(@DynamicDataSet_Ids)))
ORDER BY PAG.[DATE] DESC



DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))
ORDER BY [DATE] DESC
DROP TABLE #RESUL
GO

-------------------------------------
CREATE PROCEDURE [dbo].[LogAccion_Sp_GetByFloating_Id]
(@Floating_Id bigint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[LogAccion_v] 
WHERE (not @Floating_Id is null 
        and [Floating_Id] = @Floating_Id)
   or (not @lstId is null
        and [Floating_Id] in(select * from dbo.SplitID(@lstId)))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[LogAccion_Sp_GetByUser_Id]
(@User_Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[LogAccion] 
WHERE ((not @User_Id is null 
        and [User_Id] = @User_Id)
   or (not @lstId is null
        and [User_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
--CREATE PROCEDURE [dbo].[LogAccion_sp_GetSubAcciones]
--@Accion_Id int
--WITH 
--EXECUTE AS CALLER
--AS
--select distinct SubAccion
--from LogAccion
--where Accion_Id = @Accion_Id or @Accion_Id = 0

--GO
-------------------------------------
CREATE PROCEDURE [dbo].[LogAccion_Sp_Save]
@Id bigint, @Date datetime, @User_Id int, @Accion_Id int, @AccionTo varchar(255), @Access_Id int, @Data varchar(4000), @DynamicDataSet_Id bigint, @AccionToId bigint
WITH 
EXECUTE AS CALLER
AS
IF (SELECT COUNT(*) from dbo.[LogAccion]  WHERE  [Id] = @Id) > 0
    BEGIN
        UPDATE dbo.[LogAccion]
             SET  [Date] = @Date, [User_Id] = @User_Id, [Accion_Id] = @Accion_Id, [AccionTo] = @AccionTo,[AccionToId] = @AccionToId, [Access_Id] = @Access_Id, [Data] = @Data, [DynamicDataSet_Id] = @DynamicDataSet_Id
             WHERE  [Id] = @Id
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[LogAccion]   
               ([Date], [User_Id], [Accion_Id], [AccionTo],[AccionToId], [Access_Id], [Data], [DynamicDataSet_Id]) 
        VALUES(@Date,@User_Id,@Accion_Id,@AccionTo,@AccionToId,@Access_Id,@Data,@DynamicDataSet_Id)
        SELECT SCOPE_IDENTITY() as Id
    END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[LogError_Sp_Delete]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[LogError] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[LogError_Sp_Get]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[LogError] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[LogError_Sp_GetAll] 
AS
SET NOCOUNT ON;
SELECT * FROM dbo.[LogError]

GO
-------------------------------------
CREATE PROCEDURE [dbo].[LogError_Sp_GetByFilter] 
(@Date datetime = null, @Thread varchar(255) = null, @Level varchar(50) = null, @Logger varchar(255) = null, @Message varchar(4000) = null, @Exception varchar(MAX) = null, @Detail varchar(MAX) = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;

SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[LogError] AS PAG
WHERE (@Date is null or [Date] = @Date)
	 and (@Thread is null or [Thread] = @Thread)
	 and (@Level is null or [Level] = @Level)
	 and (@Logger is null or [Logger] = @Logger)
	 and (@Message is null or [Message] = @Message)
	 and (@Exception is null or [Exception] = @Exception)
	 and (@Detail is null or [Detail] = @Detail)

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL

GO
-------------------------------------
CREATE PROCEDURE [dbo].[LogError_Sp_Save]
(@Id int, @Date datetime, @Thread varchar(255), @Level varchar(50), @Logger varchar(255), @Message varchar(4000), @Exception varchar(MAX), @Detail varchar(MAX)) 
as
IF (SELECT COUNT(*) from dbo.[LogError]  WHERE  [Id] = @Id) > 0
    BEGIN
        UPDATE dbo.[LogError]
             SET  [Date] = @Date, [Thread] = @Thread, [Level] = @Level, [Logger] = @Logger, [Message] = @Message, [Exception] = @Exception, [Detail] = @Detail
             WHERE  [Id] = @Id
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[LogError]   
               ([Date], [Thread], [Level], [Logger], [Message], [Exception], [Detail]) 
        VALUES(@Date,@Thread,@Level,@Logger,@Message,@Exception,@Detail)
        SELECT SCOPE_IDENTITY() as Id
    END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[PivotCube_Sp_Delete]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[PivotCube] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[PivotCube_Sp_Get]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[PivotCube] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[PivotCube_Sp_GetAll] 
AS
SET NOCOUNT ON;
SELECT * FROM dbo.[PivotCube]

GO
-------------------------------------
CREATE PROCEDURE [dbo].[PivotCube_Sp_GetByEntity_Id]
(@Entity_Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[PivotCube] 
WHERE ((not @Entity_Id is null 
        and [Entity_Id] = @Entity_Id)
   or (not @lstId is null
        and [Entity_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[PivotCube_Sp_GetByFilter] 
(@Entity_Id int = null, @Entity_Ids varchar(MAX) = null, @Name varchar(100) = null, @Code char(30) = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;

SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[PivotCube] AS PAG
WHERE (@Entity_Id is null or [Entity_Id] = @Entity_Id)
	 and (@Entity_Ids is null or [Entity_Id] in (select * from dbo.SplitID(@Entity_Ids)))
	 and (@Name is null or [Name] = @Name)
	 and (@Code is null or [Code] = @Code)

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL

GO
-------------------------------------
CREATE PROCEDURE [dbo].[PivotCube_Sp_Save]
(@Id int, @Entity_Id int, @Name varchar(100), @Code char(30)) 
as
IF (SELECT COUNT(*) from dbo.[PivotCube]  WHERE  [Id] = @Id) > 0
    BEGIN
        UPDATE dbo.[PivotCube]
             SET  [Entity_Id] = @Entity_Id, [Name] = @Name, [Code] = @Code
             WHERE  [Id] = @Id
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[PivotCube]   
               ([Entity_Id], [Name], [Code]) 
        VALUES(@Entity_Id,@Name,@Code)
        SELECT SCOPE_IDENTITY() as Id
    END

GO
-------------------------------------            
CREATE PROCEDURE [dbo].[PivotQuery_Sp_Delete]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[PivotQuery] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------            
CREATE PROCEDURE [dbo].[PivotQuery_Sp_Get]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[PivotQuery] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------            
CREATE PROCEDURE [dbo].[PivotQuery_Sp_GetAll] 
AS
SET NOCOUNT ON;
SELECT * FROM dbo.[PivotQuery]

GO
-------------------------------------
CREATE PROCEDURE [dbo].[PivotQuery_Sp_GetByFilter] 
(@Name varchar(255) = null, @Code char(30) = null, @User_Id int = null, @User_Ids varchar(MAX) = null, @RepositoryConfig_Id int = null, @RepositoryConfig_Ids varchar(MAX) = null, @Report_Id int = null, @Report_Ids varchar(MAX) = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;

SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[PivotQuery] AS PAG
WHERE (@Name is null or [Name] = @Name)
	 and (@Code is null or [Code] = @Code)
	 and (@User_Id is null or [User_Id] = @User_Id)
	 and (@User_Ids is null or [User_Id] in (select * from dbo.SplitID(@User_Ids)))
	 and (@RepositoryConfig_Id is null or [RepositoryConfig_Id] = @RepositoryConfig_Id)
	 and (@RepositoryConfig_Ids is null or [RepositoryConfig_Id] in (select * from dbo.SplitID(@RepositoryConfig_Ids)))
	 and (@Report_Id is null or [Report_Id] = @Report_Id)
	 and (@Report_Ids is null or [Report_Id] in (select * from dbo.SplitID(@Report_Ids)))

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL

GO
-------------------------------------            
CREATE PROCEDURE [dbo].[PivotQuery_Sp_GetByReport_Id]
(@Report_Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[PivotQuery] 
WHERE ((not @Report_Id is null 
        and [Report_Id] = @Report_Id)
   or (not @lstId is null
        and [Report_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------            
CREATE PROCEDURE [dbo].[PivotQuery_Sp_GetByRepositoryConfig_Id]
(@RepositoryConfig_Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[PivotQuery] 
WHERE ((not @RepositoryConfig_Id is null 
        and [RepositoryConfig_Id] = @RepositoryConfig_Id)
   or (not @lstId is null
        and [RepositoryConfig_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------            
CREATE PROCEDURE [dbo].[PivotQuery_Sp_GetByUser_Id]
(@User_Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[PivotQuery] 
WHERE ((not @User_Id is null 
        and [User_Id] = @User_Id)
   or (not @lstId is null
        and [User_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------         

CREATE PROCEDURE [dbo].[PivotQuery_Sp_Save]
(@Id int, @Name varchar(255), @Code char(30), @User_Id int, @RepositoryConfig_Id int, @Report_Id int) 
as
IF (SELECT COUNT(*) from dbo.[PivotQuery]  WHERE  [Id] = @Id) > 0
    BEGIN
        UPDATE dbo.[PivotQuery]
             SET  [Name] = @Name, [Code] = @Code, [User_Id] = @User_Id, [RepositoryConfig_Id] = @RepositoryConfig_Id, [Report_Id] = @Report_Id
             WHERE  [Id] = @Id
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[PivotQuery]   
               ([Name], [Code], [User_Id], [RepositoryConfig_Id], [Report_Id]) 
        VALUES(@Name,@Code,@User_Id,@RepositoryConfig_Id,@Report_Id)
        SELECT SCOPE_IDENTITY() as Id
    END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[PivotQueryStruct_Sp_Delete]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[PivotQueryStruct] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[PivotQueryStruct_Sp_Get]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[PivotQueryStruct] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------
CREATE PROCEDURE [dbo].[PivotQueryStruct_Sp_GetAll] 
AS
SET NOCOUNT ON;
SELECT * FROM dbo.[PivotQueryStruct]

GO
-------------------------------------
CREATE PROCEDURE [dbo].[PivotQueryStruct_Sp_GetByFilter] 
(@PivotQuery_Id int = null, @PivotQuery_Ids varchar(MAX) = null, @HiddenAttributes varchar(MAX) = null, @MenuLimit varchar(MAX) = null, @Cols varchar(MAX) = null, @Rows varchar(MAX) = null, @Vals varchar(MAX) = null, @Exclusions varchar(MAX) = null, @Inclusions varchar(MAX) = null, @UnusedAttrsVertical varchar(MAX) = null, @AutoSortUnusedAttrs varchar(MAX) = null, @InclusionsInfo varchar(MAX) = null, @AggregatorName varchar(MAX) = null, @RendererName varchar(MAX) = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;

SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[PivotQueryStruct] AS PAG
WHERE (@PivotQuery_Id is null or [PivotQuery_Id] = @PivotQuery_Id)
	 and (@PivotQuery_Ids is null or [PivotQuery_Id] in (select * from dbo.SplitID(@PivotQuery_Ids)))
	 and (@HiddenAttributes is null or [HiddenAttributes] = @HiddenAttributes)
	 and (@MenuLimit is null or [MenuLimit] = @MenuLimit)
	 and (@Cols is null or [Cols] = @Cols)
	 and (@Rows is null or [Rows] = @Rows)
	 and (@Vals is null or [Vals] = @Vals)
	 and (@Exclusions is null or [Exclusions] = @Exclusions)
	 and (@Inclusions is null or [Inclusions] = @Inclusions)
	 and (@UnusedAttrsVertical is null or [UnusedAttrsVertical] = @UnusedAttrsVertical)
	 and (@AutoSortUnusedAttrs is null or [AutoSortUnusedAttrs] = @AutoSortUnusedAttrs)
	 and (@InclusionsInfo is null or [InclusionsInfo] = @InclusionsInfo)
	 and (@AggregatorName is null or [AggregatorName] = @AggregatorName)
	 and (@RendererName is null or [RendererName] = @RendererName)

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL

GO
-------------------------------------
CREATE PROCEDURE [dbo].[PivotQueryStruct_Sp_GetByPivotQuery_Id]
(@PivotQuery_Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[PivotQueryStruct] 
WHERE ((not @PivotQuery_Id is null 
        and [PivotQuery_Id] = @PivotQuery_Id)
   or (not @lstId is null
        and [PivotQuery_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[PivotQueryStruct_Sp_Save]
(@Id int, @PivotQuery_Id int, @HiddenAttributes varchar(MAX), @MenuLimit varchar(MAX), @Cols varchar(MAX), @Rows varchar(MAX), @Vals varchar(MAX), @Exclusions varchar(MAX), @Inclusions varchar(MAX), @UnusedAttrsVertical varchar(MAX), @AutoSortUnusedAttrs varchar(MAX), @InclusionsInfo varchar(MAX), @AggregatorName varchar(MAX), @RendererName varchar(MAX)) 
as
IF (SELECT COUNT(*) from dbo.[PivotQueryStruct]  WHERE  [Id] = @Id) > 0
    BEGIN
        UPDATE dbo.[PivotQueryStruct]
             SET  [PivotQuery_Id] = @PivotQuery_Id, [HiddenAttributes] = @HiddenAttributes, [MenuLimit] = @MenuLimit, [Cols] = @Cols, [Rows] = @Rows, [Vals] = @Vals, [Exclusions] = @Exclusions, [Inclusions] = @Inclusions, [UnusedAttrsVertical] = @UnusedAttrsVertical, [AutoSortUnusedAttrs] = @AutoSortUnusedAttrs, [InclusionsInfo] = @InclusionsInfo, [AggregatorName] = @AggregatorName, [RendererName] = @RendererName
             WHERE  [Id] = @Id
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[PivotQueryStruct]   
               ([PivotQuery_Id], [HiddenAttributes], [MenuLimit], [Cols], [Rows], [Vals], [Exclusions], [Inclusions], [UnusedAttrsVertical], [AutoSortUnusedAttrs], [InclusionsInfo], [AggregatorName], [RendererName]) 
        VALUES(@PivotQuery_Id,@HiddenAttributes,@MenuLimit,@Cols,@Rows,@Vals,@Exclusions,@Inclusions,@UnusedAttrsVertical,@AutoSortUnusedAttrs,@InclusionsInfo,@AggregatorName,@RendererName)
        SELECT SCOPE_IDENTITY() as Id
    END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Process_Sp_Delete]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[Process] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Process_Sp_Get]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[Process] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Process_Sp_GetAll] 
AS
SET NOCOUNT ON;
SELECT * FROM dbo.[Process]

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Process_Sp_GetByFilter] 
(@ProcessConfig_Id smallint = null, @ProcessConfig_Ids varchar(MAX) = null, @Status_Id smallint = null, @Status_Ids varchar(MAX) = null, @Date datetime = null, @DateStart datetime = null, @DateEnd datetime = null, @Period date = null, @PeriodStart datetime = null, @PeriodEnd datetime = null, @Version int = null, @IsOpen bit = null, @LastRefresh datetime = null, @LastRefreshStart datetime = null, @LastRefreshEnd datetime = null, @Data varbinary(MAX) = null, @Error varchar(MAX) = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;

SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[Process] AS PAG
WHERE (@ProcessConfig_Id is null or [ProcessConfig_Id] = @ProcessConfig_Id)
	 and (@ProcessConfig_Ids is null or [ProcessConfig_Id] in (select * from dbo.SplitID(@ProcessConfig_Ids)))
	 and (@Status_Id is null or [Status_Id] = @Status_Id)
	 and (@Status_Ids is null or [Status_Id] in (select * from dbo.SplitID(@Status_Ids)))
	 and (@Date is null or [Date] = @Date)
	 and (@DateStart is null or [Date] between @DateStart and @DateEnd)
	 and (@Period is null or [Period] = @Period)
	 and (@PeriodStart is null or [Period] between @PeriodStart and @PeriodEnd)
	 and (@Version is null or [Version] = @Version)
	 and (@IsOpen is null or [IsOpen] = @IsOpen)
	 and (@LastRefresh is null or [LastRefresh] = @LastRefresh)
	 and (@LastRefreshStart is null or [LastRefresh] between @LastRefreshStart and @LastRefreshEnd)
	 and (@Data is null or [Data] = @Data)
	 and (@Error is null or [Error] = @Error)

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Process_Sp_GetByProcessConfig_Id]
(@ProcessConfig_Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[Process] 
WHERE ((not @ProcessConfig_Id is null 
        and [ProcessConfig_Id] = @ProcessConfig_Id)
   or (not @lstId is null
        and [ProcessConfig_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Process_Sp_GetByStatus_Id]
(@Status_Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[Process] 
WHERE ((not @Status_Id is null 
        and [Status_Id] = @Status_Id)
   or (not @lstId is null
        and [Status_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Process_Sp_GetCurrentApprove]
@Period datetime, @ProcessConfigId smallint
WITH 
EXECUTE AS CALLER
AS
select top 1 process.* 
from process
  inner join [Status] on dbo.Process.Status_Id = [status].id
Where  Period = @Period
  and ProcessConfig_Id =  @processConfigId
  and Status.Code = 'Approve'
Order by  dbo.Process.Version desc

GO
-------------------------------------
CREATE procedure [dbo].[Process_Sp_GetCurrentVersion](
@ProcessConfigId int , @Period Datetime
)
as
select max(Version)
from [Process]
Where ProcessConfig_Id = @ProcessConfigId
  and Period = @Period

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Process_Sp_Save]
(@Id int, @ProcessConfig_Id smallint, @Status_Id smallint, @Date datetime, @Period date, @Version int, @IsOpen bit, @LastRefresh datetime, @Data varbinary(MAX), @Error varchar(MAX)) 
as
IF (SELECT COUNT(*) from dbo.[Process]  WHERE  [Id] = @Id) > 0
    BEGIN
        UPDATE dbo.[Process]
             SET  [ProcessConfig_Id] = @ProcessConfig_Id, [Status_Id] = @Status_Id, [Date] = @Date, [Period] = @Period, [Version] = @Version, [IsOpen] = @IsOpen, [LastRefresh] = @LastRefresh, [Data] = @Data, [Error] = @Error
             WHERE  [Id] = @Id
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[Process]   
               ([ProcessConfig_Id], [Status_Id], [Date], [Period], [Version], [IsOpen], [LastRefresh], [Data], [Error]) 
        VALUES(@ProcessConfig_Id,@Status_Id,@Date,@Period,@Version,@IsOpen,@LastRefresh,@Data,@Error)
        SELECT SCOPE_IDENTITY() as Id
    END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessConfig_Sp_Delete]
(@Id smallint = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;
	DELETE FROM dbo.[ProcessConfig] 
	WHERE  
    
		((not @Id is null 
			and [Id] = @Id)
	   or (not @lstId is null
			and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessConfig_Sp_Get]  
(@Id smallint = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[ProcessConfig] 
	WHERE   
		((not @Id is null and [Id] = @Id)
	   or (not @lstId is null and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessConfig_Sp_GetAll] 
AS
	SET NOCOUNT ON;
	SELECT * 
	FROM dbo.[ProcessConfig]

GO

CREATE PROCEDURE [dbo].[ProcessConfig_Sp_GetByCode]
@Code varchar(50)
WITH 
EXECUTE AS CALLER
AS
	select * from ProcessConfig where Code = @Code

GO
-------------------------------------
CREATE PROCEDURE [ProcessConfig_Sp_GetByFilter] 
(@Name varchar(255) = null, @Description nvarchar(MAX) = null, @Code varchar(50) = null, @Type_Id tinyint = null, @Type_Ids varchar(MAX) = null, @NewPage varchar(255) = null, @Class varchar(255) = null, @Deleted bit = null, @AutoExecute bit = null, @RealTime bit = null, @RealTimeRefreshMinutes int = null, @ExecuteOnHour smallint = null, @ExecuteOnMinute smallint = null, @ExecuteDelayDays smallint = null, @AutoApprove bit = null, @Assembly varchar(255) = null, @HolyDays_Type_Id int = null, @HolyDays_Type_Ids varchar(MAX) = null, @Frequency_Type_Id smallint = null, @Frequency_Type_Ids varchar(MAX) = null, @Regenerate bit = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;
SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[ProcessConfig] AS PAG
WHERE (@Name is null or [Name] like @Name)
	 and (@Description is null or [Description] like @Description)
	 and (@Code is null or [Code] like @Code)
	 and (@Type_Id is null or [Type_Id] = @Type_Id)
	 and (@Type_Ids is null or [Type_Id] in (select * from dbo.SplitID(@Type_Ids)))
	 and (@NewPage is null or [NewPage] like @NewPage)
	 and (@Class is null or [Class] like @Class)
	 and (@Deleted is null or [Deleted] = @Deleted)
	 and (@AutoExecute is null or [AutoExecute] = @AutoExecute)
	 and (@RealTime is null or [RealTime] = @RealTime)
	 and (@RealTimeRefreshMinutes is null or [RealTimeRefreshMinutes] = @RealTimeRefreshMinutes)
	 and (@ExecuteOnHour is null or [ExecuteOnHour] = @ExecuteOnHour)
	 and (@ExecuteOnMinute is null or [ExecuteOnMinute] = @ExecuteOnMinute)
	 and (@ExecuteDelayDays is null or [ExecuteDelayDays] = @ExecuteDelayDays)
	 and (@AutoApprove is null or [AutoApprove] = @AutoApprove)
	 and (@Assembly is null or [Assembly] like @Assembly)
	 and (@HolyDays_Type_Id is null or [HolyDays_Type_Id] = @HolyDays_Type_Id)
	 and (@HolyDays_Type_Ids is null or [HolyDays_Type_Id] in (select * from dbo.SplitID(@HolyDays_Type_Ids)))
	 and (@Frequency_Type_Id is null or [Frequency_Type_Id] = @Frequency_Type_Id)
	 and (@Frequency_Type_Ids is null or [Frequency_Type_Id] in (select * from dbo.SplitID(@Frequency_Type_Ids)))
	 and (@Regenerate is null or [Regenerate] = @Regenerate)

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL
GO


-------------------------------------
CREATE PROCEDURE [dbo].[ProcessConfig_Sp_GetByFrequency_Type_Id]  
(@Frequency_Type_Id smallint = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[ProcessConfig] 
	WHERE   
	   ((not @Frequency_Type_Id is null and [Frequency_Type_Id] = @Frequency_Type_Id)
	   or (not @lstId is null and [Frequency_Type_Id]  in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessConfig_Sp_GetByHolyDays_Type_Id]  
(@HolyDays_Type_Id int = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[ProcessConfig] 
	WHERE   
	   ((not @HolyDays_Type_Id is null and [HolyDays_Type_Id] = @HolyDays_Type_Id)
	   or (not @lstId is null and [HolyDays_Type_Id]  in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessConfig_Sp_GetByType_Id]  
(@Type_Id tinyint = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[ProcessConfig] 
	WHERE   
	   ((not @Type_Id is null and [Type_Id] = @Type_Id)
	   or (not @lstId is null and [Type_Id]  in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [ProcessConfig_Sp_Save]
(@Id smallint, @Name varchar(255), @Description nvarchar(MAX), @Code varchar(50), @Type_Id tinyint, @NewPage varchar(255), @Class varchar(255), @Deleted bit, @AutoExecute bit, @RealTime bit, @RealTimeRefreshMinutes int, @ExecuteOnHour smallint, @ExecuteOnMinute smallint, @ExecuteDelayDays smallint, @AutoApprove bit, @Assembly varchar(255), @HolyDays_Type_Id int, @Frequency_Type_Id smallint, @Regenerate bit)
as
IF (SELECT COUNT(*) from dbo.[ProcessConfig] WHERE ( [Id] = @Id)  ) > 0
    BEGIN
        UPDATE dbo.[ProcessConfig]
            SET  [Name] = @Name, [Description] = @Description, [Code] = @Code, [Type_Id] = @Type_Id, [NewPage] = @NewPage, [Class] = @Class, [Deleted] = @Deleted, [AutoExecute] = @AutoExecute, [RealTime] = @RealTime, [RealTimeRefreshMinutes] = @RealTimeRefreshMinutes, [ExecuteOnHour] = @ExecuteOnHour, [ExecuteOnMinute] = @ExecuteOnMinute, [ExecuteDelayDays] = @ExecuteDelayDays, [AutoApprove] = @AutoApprove, [Assembly] = @Assembly, [HolyDays_Type_Id] = @HolyDays_Type_Id, [Frequency_Type_Id] = @Frequency_Type_Id, [Regenerate] = @Regenerate
            WHERE ( [Id] = @Id)
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[ProcessConfig]   
              ([Name], [Description], [Code], [Type_Id], [NewPage], [Class], [Deleted], [AutoExecute], [RealTime], [RealTimeRefreshMinutes], [ExecuteOnHour], [ExecuteOnMinute], [ExecuteDelayDays], [AutoApprove], [Assembly], [HolyDays_Type_Id], [Frequency_Type_Id], [Regenerate]) 
       VALUES (@Name , @Description , @Code , @Type_Id , @NewPage , @Class , @Deleted , @AutoExecute , @RealTime , @RealTimeRefreshMinutes , @ExecuteOnHour , @ExecuteOnMinute , @ExecuteDelayDays , @AutoApprove , @Assembly , @HolyDays_Type_Id , @Frequency_Type_Id , @Regenerate )
        SELECT SCOPE_IDENTITY() as Id
    END
GO


-------------------------------------
CREATE PROCEDURE [dbo].[ProcessInput_Sp_Delete]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[ProcessInput] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessInput_Sp_Get]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[ProcessInput] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessInput_Sp_GetAll] 
AS
SET NOCOUNT ON;
SELECT * FROM dbo.[ProcessInput]

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessInput_Sp_GetByProcess_Id]
(@Process_Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[ProcessInput] 
WHERE ((not @Process_Id is null 
        and [Process_Id] = @Process_Id)
   or (not @lstId is null
        and [Process_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessInput_Sp_GetByRepository_Id]
(@Repository_Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[ProcessInput] 
WHERE ((not @Repository_Id is null 
        and [Repository_Id] = @Repository_Id)
   or (not @lstId is null
        and [Repository_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [ProcessInput_Sp_Save]
(@Id int, @Process_Id int, @ProcessInputConfig_Id smallint, @Repository_Id int)
as
IF (SELECT COUNT(*) from dbo.[ProcessInput] WHERE ( [Id] = @Id)  ) > 0
   BEGIN
       UPDATE dbo.[ProcessInput]
           SET  [Process_Id] = @Process_Id, [ProcessInputConfig_Id] = @ProcessInputConfig_Id, [Repository_Id] = @Repository_Id
           WHERE ( [Id] = @Id)
       SELECT @Id as Id
   END
ELSE
   BEGIN
       
       INSERT INTO dbo.[ProcessInput]   
             ([Process_Id], [ProcessInputConfig_Id], [Repository_Id]) 
      VALUES (@Process_Id , @ProcessInputConfig_Id , @Repository_Id )
       SELECT SCOPE_IDENTITY() as Id
   END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessInputConfig_Sp_Delete]
(@Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[ProcessInputConfig] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessInputConfig_Sp_Get]
(@Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[ProcessInputConfig] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessInputConfig_Sp_GetAll] 
AS
SET NOCOUNT ON;
SELECT * FROM dbo.[ProcessInputConfig]
GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessInputConfig_Sp_GetByFilter] 
(@Code varchar(50) = null, @ProcessConfig_Id smallint = null, @ProcessConfig_Ids varchar(MAX) = null, @RepositoryConfig_Id smallint = null, @RepositoryConfig_Ids varchar(MAX) = null, @FrequencySimpleInput_Id int = null, @FrequencySimpleInput_Ids varchar(MAX) = null, @Frequency_Type_Id smallint = null, @Frequency_Type_Ids varchar(MAX) = null, @FrequencyIncrease smallint = null, @FrequencyAll bit = null, @Visibility_Type_Id smallint = null, @Visibility_Type_Ids varchar(MAX) = null, @Deleted bit = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;
SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[ProcessInputConfig] AS PAG
WHERE (@Code is null or [Code] like @Code)
     and (@ProcessConfig_Id is null or [ProcessConfig_Id] = @ProcessConfig_Id)
     and (@ProcessConfig_Ids is null or [ProcessConfig_Id] in (select * from dbo.SplitID(@ProcessConfig_Ids)))
     and (@RepositoryConfig_Id is null or [RepositoryConfig_Id] = @RepositoryConfig_Id)
     and (@RepositoryConfig_Ids is null or [RepositoryConfig_Id] in (select * from dbo.SplitID(@RepositoryConfig_Ids)))
     and (@FrequencySimpleInput_Id is null or [FrequencySimpleInput_Id] = @FrequencySimpleInput_Id)
     and (@FrequencySimpleInput_Ids is null or [FrequencySimpleInput_Id] in (select * from dbo.SplitID(@FrequencySimpleInput_Ids)))
     and (@Frequency_Type_Id is null or [Frequency_Type_Id] = @Frequency_Type_Id)
     and (@Frequency_Type_Ids is null or [Frequency_Type_Id] in (select * from dbo.SplitID(@Frequency_Type_Ids)))
     and (@FrequencyIncrease is null or [FrequencyIncrease] = @FrequencyIncrease)
     and (@FrequencyAll is null or [FrequencyAll] = @FrequencyAll)
     and (@Visibility_Type_Id is null or [Visibility_Type_Id] = @Visibility_Type_Id)
     and (@Visibility_Type_Ids is null or [Visibility_Type_Id] in (select * from dbo.SplitID(@Visibility_Type_Ids)))
     and (@Deleted is null or [Deleted] = @Deleted)

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL
GO


-------------------------------------
CREATE PROCEDURE [dbo].[ProcessInputConfig_Sp_GetByFrequency_Type_Id]
(@Frequency_Type_Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[ProcessInputConfig] 
WHERE ((not @Frequency_Type_Id is null 
        and [Frequency_Type_Id] = @Frequency_Type_Id)
   or (not @lstId is null
        and [Frequency_Type_Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessInputConfig_Sp_GetByProcessConfig_Id]
(@ProcessConfig_Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[ProcessInputConfig] 
WHERE ((not @ProcessConfig_Id is null 
        and [ProcessConfig_Id] = @ProcessConfig_Id)
   or (not @lstId is null
        and [ProcessConfig_Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessInputConfig_Sp_GetByRepositoryConfig_Id]
(@RepositoryConfig_Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[ProcessInputConfig] 
WHERE ((not @RepositoryConfig_Id is null 
        and [RepositoryConfig_Id] = @RepositoryConfig_Id)
   or (not @lstId is null
        and [RepositoryConfig_Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessInputConfig_Sp_GetByVisibility_Type_Id]
(@Visibility_Type_Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[ProcessInputConfig] 
WHERE ((not @Visibility_Type_Id is null 
        and [Visibility_Type_Id] = @Visibility_Type_Id)
   or (not @lstId is null
        and [Visibility_Type_Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessInputConfig_Sp_Save]
(@Id smallint, @Code varchar(50), @ProcessConfig_Id smallint, @RepositoryConfig_Id smallint, @FrequencySimpleInput_Id int, @Frequency_Type_Id smallint, @FrequencyIncrease smallint, @FrequencyAll bit, @Visibility_Type_Id smallint, @Deleted bit)
as
IF (SELECT COUNT(*) from dbo.[ProcessInputConfig] WHERE ( [Id] = @Id)  ) > 0
    BEGIN
        UPDATE dbo.[ProcessInputConfig]
            SET  [Code] = @Code, [ProcessConfig_Id] = @ProcessConfig_Id, [RepositoryConfig_Id] = @RepositoryConfig_Id, [FrequencySimpleInput_Id] = @FrequencySimpleInput_Id, [Frequency_Type_Id] = @Frequency_Type_Id, [FrequencyIncrease] = @FrequencyIncrease, [FrequencyAll] = @FrequencyAll, [Visibility_Type_Id] = @Visibility_Type_Id, [Deleted] = @Deleted
            WHERE ( [Id] = @Id)
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[ProcessInputConfig]   
              ([Code], [ProcessConfig_Id], [RepositoryConfig_Id], [FrequencySimpleInput_Id], [Frequency_Type_Id], [FrequencyIncrease], [FrequencyAll], [Visibility_Type_Id], [Deleted]) 
       VALUES (@Code , @ProcessConfig_Id , @RepositoryConfig_Id , @FrequencySimpleInput_Id , @Frequency_Type_Id , @FrequencyIncrease , @FrequencyAll , @Visibility_Type_Id , @Deleted )
        SELECT SCOPE_IDENTITY() as Id
    END
GO


-------------------------------------
CREATE PROCEDURE [dbo].[ProcessOutput_Sp_Delete]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[ProcessOutput] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessOutput_Sp_Get]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[ProcessOutput] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessOutput_Sp_GetAll] 
AS
SET NOCOUNT ON;
SELECT * FROM dbo.[ProcessOutput]

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessOutput_Sp_GetByFilter] 
(@Process_Id int = null, @ProcessOutputConfig_Id smallint = null, @Repository_Id int = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;

SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[ProcessOutput] AS PAG
WHERE (@Process_Id is null or [Process_Id] = @Process_Id)
	 and (@ProcessOutputConfig_Id is null or [ProcessOutputConfig_Id] = @ProcessOutputConfig_Id)
	 and (@Repository_Id is null or [Repository_Id] = @Repository_Id)

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessOutput_Sp_GetByProcess_Id]
(@Process_Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[ProcessOutput] 
WHERE ((not @Process_Id is null 
        and [Process_Id] = @Process_Id)
   or (not @lstId is null
        and [Process_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessOutput_Sp_GetByProcessOutputConfig_Id]
(@ProcessOutputConfig_Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[ProcessOutput] 
WHERE ((not @ProcessOutputConfig_Id is null 
        and [ProcessOutputConfig_Id] = @ProcessOutputConfig_Id)
   or (not @lstId is null
        and [ProcessOutputConfig_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessOutput_Sp_GetByRepository_Id]
(@Repository_Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[ProcessOutput] 
WHERE ((not @Repository_Id is null 
        and [Repository_Id] = @Repository_Id)
   or (not @lstId is null
        and [Repository_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessOutput_Sp_Save]
(@Id int, @Process_Id int, @ProcessOutputConfig_Id smallint, @Repository_Id int) 
as
IF (SELECT COUNT(*) from dbo.[ProcessOutput]  WHERE  [Id] = @Id) > 0
    BEGIN
        UPDATE dbo.[ProcessOutput]
             SET  [Process_Id] = @Process_Id, [ProcessOutputConfig_Id] = @ProcessOutputConfig_Id, [Repository_Id] = @Repository_Id
             WHERE  [Id] = @Id
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[ProcessOutput]   
               ([Process_Id], [ProcessOutputConfig_Id], [Repository_Id]) 
        VALUES(@Process_Id,@ProcessOutputConfig_Id,@Repository_Id)
        SELECT SCOPE_IDENTITY() as Id
    END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessOutputConfig_Sp_Delete]
(@Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[ProcessOutputConfig] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessOutputConfig_Sp_Get]
(@Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[ProcessOutputConfig] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessOutputConfig_Sp_GetAll] 
AS
SET NOCOUNT ON;
SELECT * FROM dbo.[ProcessOutputConfig]

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessOutputConfig_Sp_GetByFilter] 
(@ProcessConfig_Id smallint = null, @Name varchar(255) = null, @Code varchar(50) = null, @RepositoryConfig_Id smallint = null, @Visibility_Type_Id smallint = null, @Deleted bit = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;

SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[ProcessOutputConfig] AS PAG
WHERE (@ProcessConfig_Id is null or [ProcessConfig_Id] = @ProcessConfig_Id)
	 and (@Name is null or [Name] = @Name)
	 and (@Code is null or [Code] = @Code)
	 and (@RepositoryConfig_Id is null or [RepositoryConfig_Id] = @RepositoryConfig_Id)
	 and (@Visibility_Type_Id is null or [Visibility_Type_Id] = @Visibility_Type_Id)
	 and (@Deleted is null or [Deleted] = @Deleted)

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessOutputConfig_Sp_GetByProcessConfig_Id]
(@ProcessConfig_Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[ProcessOutputConfig] 
WHERE ((not @ProcessConfig_Id is null 
        and [ProcessConfig_Id] = @ProcessConfig_Id)
   or (not @lstId is null
        and [ProcessConfig_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessOutputConfig_Sp_GetByRepositoryConfig_Id]
(@RepositoryConfig_Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[ProcessOutputConfig] 
WHERE ((not @RepositoryConfig_Id is null 
        and [RepositoryConfig_Id] = @RepositoryConfig_Id)
   or (not @lstId is null
        and [RepositoryConfig_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessOutputConfig_Sp_GetByVisibility_Type_Id]
(@Visibility_Type_Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[ProcessOutputConfig] 
WHERE ((not @Visibility_Type_Id is null 
        and [Visibility_Type_Id] = @Visibility_Type_Id)
   or (not @lstId is null
        and [Visibility_Type_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProcessOutputConfig_Sp_Save]
(@Id smallint, @ProcessConfig_Id smallint, @Name varchar(255), @Code varchar(50), @RepositoryConfig_Id smallint, @Visibility_Type_Id smallint, @Deleted bit) 
as
IF (SELECT COUNT(*) from dbo.[ProcessOutputConfig]  WHERE  [Id] = @Id) > 0
    BEGIN
        UPDATE dbo.[ProcessOutputConfig]
             SET  [ProcessConfig_Id] = @ProcessConfig_Id, [Name] = @Name, [Code] = @Code, [RepositoryConfig_Id] = @RepositoryConfig_Id, [Visibility_Type_Id] = @Visibility_Type_Id, [Deleted] = @Deleted
             WHERE  [Id] = @Id
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[ProcessOutputConfig]   
               ([ProcessConfig_Id], [Name], [Code], [RepositoryConfig_Id], [Visibility_Type_Id], [Deleted]) 
        VALUES(@ProcessConfig_Id,@Name,@Code,@RepositoryConfig_Id,@Visibility_Type_Id,@Deleted)
        SELECT SCOPE_IDENTITY() as Id
    END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Profile_Sp_Delete]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[Profile] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Profile_Sp_Get]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[Profile] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Profile_Sp_GetAll] 
AS
SET NOCOUNT ON;
SELECT * FROM dbo.[Profile]

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Profile_Sp_GetByFilter] 
(@Name varchar(255) = null, @State_Type_Id bigint = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;

SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[Profile] AS PAG
WHERE (@Name is null or [Name] = @Name)
	 and (@State_Type_Id is null or [State_Type_Id] = @State_Type_Id)

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Profile_Sp_GetByState_Type_Id]
(@State_Type_Id bigint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[Profile] 
WHERE ((not @State_Type_Id is null 
        and [State_Type_Id] = @State_Type_Id)
   or (not @lstId is null
        and [State_Type_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Profile_Sp_Save]
(@Id int, @Name varchar(255), @State_Type_Id bigint) 
as
IF (SELECT COUNT(*) from dbo.[Profile]  WHERE  [Id] = @Id) > 0
    BEGIN
        UPDATE dbo.[Profile]
             SET  [Name] = @Name, [State_Type_Id] = @State_Type_Id
             WHERE  [Id] = @Id
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[Profile]   
               ([Name], [State_Type_Id]) 
        VALUES(@Name,@State_Type_Id)
        SELECT SCOPE_IDENTITY() as Id
    END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProfileAccess_Sp_Delete]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[ProfileAccess] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProfileAccess_Sp_Get]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[ProfileAccess] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProfileAccess_Sp_GetAll] 
AS
SET NOCOUNT ON;
SELECT        ProfileAccess.Id, ProfileAccess.Profile_Id, ProfileAccess.Access_Id
FROM            ProfileAccess INNER JOIN
                         Access ON ProfileAccess.Access_Id = Access.Id INNER JOIN
                         Profile ON ProfileAccess.Profile_Id = Profile.Id
order by Profile.Name
GO


-------------------------------------
CREATE PROCEDURE [dbo].[ProfileAccess_Sp_GetByAccess_Id]
(@Access_Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[ProfileAccess] 
WHERE ((not @Access_Id is null 
        and [Access_Id] = @Access_Id)
   or (not @lstId is null
        and [Access_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [ProfileAccess_Sp_GetByFilter] 
(@Profile_Id int = null, @Profile_Ids varchar(MAX) = null, @Access_Id int = null, @Access_Ids varchar(MAX) = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;
SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[ProfileAccess] AS PAG
WHERE (@Profile_Id is null or [Profile_Id] = @Profile_Id)
	 and (@Profile_Ids is null or [Profile_Id] in (select * from dbo.SplitID(@Profile_Ids)))
	 and (@Access_Id is null or [Access_Id] = @Access_Id)
	 and (@Access_Ids is null or [Access_Id] in (select * from dbo.SplitID(@Access_Ids)))

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL
GO

-------------------------------------
CREATE PROCEDURE [dbo].[ProfileAccess_Sp_GetByProfile_Id]
(@Profile_Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[ProfileAccess] 
WHERE ((not @Profile_Id is null 
        and [Profile_Id] = @Profile_Id)
   or (not @lstId is null
        and [Profile_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[ProfileAccess_Sp_Save]
(@Id int, @Profile_Id int, @Access_Id int) 
as
IF (SELECT COUNT(*) from dbo.[ProfileAccess]  WHERE  [Id] = @Id) > 0
    BEGIN
        UPDATE dbo.[ProfileAccess]
             SET  [Profile_Id] = @Profile_Id, [Access_Id] = @Access_Id
             WHERE  [Id] = @Id
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[ProfileAccess]   
               ([Profile_Id], [Access_Id]) 
        VALUES(@Profile_Id,@Access_Id)
        SELECT SCOPE_IDENTITY() as Id
    END

GO
-------------------------------------            
CREATE PROCEDURE [dbo].[Report_Sp_Delete]
(@Id bigint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[Report] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------            
CREATE PROCEDURE [dbo].[Report_Sp_Get]
(@Id bigint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[Report] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------            
CREATE PROCEDURE [dbo].[Report_Sp_GetAll] 
AS
SET NOCOUNT ON;
SELECT * FROM dbo.[Report]


GO
-------------------------------------            
CREATE PROCEDURE [dbo].[Report_Sp_GetByEntity_Id]
(@Entity_Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[Report] 
WHERE ((not @Entity_Id is null 
        and [Entity_Id] = @Entity_Id)
   or (not @lstId is null
        and [Entity_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Report_Sp_GetByFilter] 
(@Name varchar(100) = null, @Code varchar(50) = null, @Description varchar(MAX) = null, @Entity_Id int = null, @Entity_Ids varchar(MAX) = null, @PivotEnabled bit = null, @Deleted bit = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;

SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[Report] AS PAG
WHERE (@Name is null or [Name] = @Name)
	 and (@Code is null or [Code] = @Code)
	 and (@Description is null or [Description] = @Description)
	 and (@Entity_Id is null or [Entity_Id] = @Entity_Id)
	 and (@Entity_Ids is null or [Entity_Id] in (select * from dbo.SplitID(@Entity_Ids)))
	 and (@PivotEnabled is null or [PivotEnabled] = @PivotEnabled)
	 and (@Deleted is null or [Deleted] = @Deleted)

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Report_Sp_Save]
(@Id bigint, @Name varchar(100), @Code varchar(50), @Description varchar(MAX), @Entity_Id int, @PivotEnabled bit, @Deleted bit) 
as
IF (SELECT COUNT(*) from dbo.[Report]  WHERE  [Id] = @Id) > 0
    BEGIN
        UPDATE dbo.[Report]
             SET  [Name] = @Name, [Code] = @Code, [Description] = @Description, [Entity_Id] = @Entity_Id, [PivotEnabled] = @PivotEnabled, [Deleted] = @Deleted
             WHERE  [Id] = @Id
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[Report]   
               ([Name], [Code], [Description], [Entity_Id], [PivotEnabled], [Deleted]) 
        VALUES(@Name,@Code,@Description,@Entity_Id,@PivotEnabled,@Deleted)
        SELECT SCOPE_IDENTITY() as Id
    END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Repository_Sp_Delete]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[Repository] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Repository_Sp_Get]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[Repository] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Repository_Sp_GetAll] 
AS
SET NOCOUNT ON;
SELECT * FROM dbo.[Repository]

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Repository_Sp_GetByFilter] 
(@RepositoryConfig_Id smallint = null, @RepositoryConfig_Ids varchar(MAX) = null, @ProcessConfig_Id smallint = null, @ProcessConfig_Ids varchar(MAX) = null, @Period date = null, @PeriodStart datetime = null, @PeriodEnd datetime = null, @Version smallint = null, @Valid bit = null, @Open bit = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;

SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[Repository] AS PAG
WHERE (@RepositoryConfig_Id is null or [RepositoryConfig_Id] = @RepositoryConfig_Id)
	 and (@RepositoryConfig_Ids is null or [RepositoryConfig_Id] in (select * from dbo.SplitID(@RepositoryConfig_Ids)))
	 and (@ProcessConfig_Id is null or [ProcessConfig_Id] = @ProcessConfig_Id)
	 and (@ProcessConfig_Ids is null or [ProcessConfig_Id] in (select * from dbo.SplitID(@ProcessConfig_Ids)))
	 and (@Period is null or [Period] = @Period)
	 and (@PeriodStart is null or [Period] between @PeriodStart and @PeriodEnd)
	 and (@Version is null or [Version] = @Version)
	 and (@Valid is null or [Valid] = @Valid)
	 and (@Open is null or [Open] = @Open)

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Repository_Sp_GetByPeriod]
	@RepositoryConfigId smallint, 
	@PeriodStart datetime, 
	@PeriodEnd datetime, 
	@Valid bit 
WITH 
EXECUTE AS CALLER
AS

	SELECT *
	FROM [Repository]
		WHERE [RepositoryConfig_Id] = @RepositoryConfigId
			AND ([Period] BETWEEN @PeriodStart AND @PeriodEnd)
			AND ([Valid] = @Valid)
	

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Repository_Sp_GetByProcessConfig_Id]
(@ProcessConfig_Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[Repository] 
WHERE ((not @ProcessConfig_Id is null 
        and [ProcessConfig_Id] = @ProcessConfig_Id)
   or (not @lstId is null
        and [ProcessConfig_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Repository_Sp_GetByRepositoryConfig_Id]
(@RepositoryConfig_Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[Repository] 
WHERE ((not @RepositoryConfig_Id is null 
        and [RepositoryConfig_Id] = @RepositoryConfig_Id)
   or (not @lstId is null
        and [RepositoryConfig_Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Repository_Sp_GetLastValid]
@repositoryConfigId smallint, @ProcessConfigId smallint
WITH 
EXECUTE AS CALLER
AS
Select top 1 * 
from Repository
Where RepositoryConfig_Id = @repositoryConfigId
      and (ProcessConfig_Id = @ProcessConfigId or @ProcessConfigId is null)
      and Valid = 1
order by Period desc

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Repository_Sp_GetMaxVersion]
	@repositoryConfigId smallint, 
	@ProcessConfigId smallint
WITH 
EXECUTE AS CALLER
AS

	SELECT ISNULL(MAX(Version), 0)
	FROM [Repository]
		WHERE RepositoryConfig_Id = @repositoryConfigId
			AND (ProcessConfig_Id = @ProcessConfigId
			OR @ProcessConfigId IS NULL)

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Repository_Sp_Save]
(@Id int, @RepositoryConfig_Id smallint, @ProcessConfig_Id smallint, @Period date, @Version smallint, @Valid bit, @Open bit) 
as
IF (SELECT COUNT(*) from dbo.[Repository]  WHERE  [Id] = @Id) > 0
    BEGIN
        UPDATE dbo.[Repository]
             SET  [RepositoryConfig_Id] = @RepositoryConfig_Id, [ProcessConfig_Id] = @ProcessConfig_Id, [Period] = @Period, [Version] = @Version, [Valid] = @Valid, [Open] = @Open
             WHERE  [Id] = @Id
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[Repository]   
               ([RepositoryConfig_Id], [ProcessConfig_Id], [Period], [Version], [Valid], [Open]) 
        VALUES(@RepositoryConfig_Id,@ProcessConfig_Id,@Period,@Version,@Valid,@Open)
        SELECT SCOPE_IDENTITY() as Id
    END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[RepositoryConfig_Sp_Delete]
(@Id smallint = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;
	DELETE FROM dbo.[RepositoryConfig] 
	WHERE  
    
		((not @Id is null 
			and [Id] = @Id)
	   or (not @lstId is null
			and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[RepositoryConfig_Sp_Get]  
(@Id smallint = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[RepositoryConfig] 
	WHERE   
		((not @Id is null and [Id] = @Id)
	   or (not @lstId is null and [Id] in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[RepositoryConfig_Sp_GetAll] 
AS
	SET NOCOUNT ON;
	SELECT * 
	FROM dbo.[RepositoryConfig]

GO
-------------------------------------
CREATE PROCEDURE [dbo].[RepositoryConfig_Sp_GetByEntity_Id]  
(@Entity_Id int = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[RepositoryConfig] 
	WHERE   
	   ((not @Entity_Id is null and [Entity_Id] = @Entity_Id)
	   or (not @lstId is null and [Entity_Id]  in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[RepositoryConfig_Sp_GetByFilter] 
(@Name varchar(255) = null, @Code varchar(100) = null, @Type_Id smallint = null, @Type_Ids varchar(MAX) = null, @Entity_Id int = null, @Entity_Ids varchar(MAX) = null, @ViewPage varchar(255) = null, @EditPage varchar(255) = null, @Deleted bit = null, @Page int = null, @PageSize int = null) 
AS
	SET NOCOUNT ON;
	SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
	INTO #RESUL
	FROM dbo.[RepositoryConfig] AS PAG
	WHERE (@Name is null or [Name] like @Name)
		 and (@Code is null or [Code] like @Code)
		 and (@Type_Id is null or [Type_Id] = @Type_Id)
		 and (@Type_Ids is null or [Type_Id] in (select * from dbo.SplitID(@Type_Ids)))
		 and (@Entity_Id is null or [Entity_Id] = @Entity_Id)
		 and (@Entity_Ids is null or [Entity_Id] in (select * from dbo.SplitID(@Entity_Ids)))
		 and (@ViewPage is null or [ViewPage] like @ViewPage)
		 and (@EditPage is null or [EditPage] like @EditPage)
		 and (@Deleted is null or [Deleted] = @Deleted)

	DECLARE @RowsTotal int
	SET @RowsTotal = @@ROWCOUNT

	SELECT *, @RowsTotal AS RowsTotal
	FROM #RESUL
	WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

	DROP TABLE #RESUL

GO
-------------------------------------
CREATE PROCEDURE [dbo].[RepositoryConfig_Sp_GetByType_Id]  
(@Type_Id smallint = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[RepositoryConfig] 
	WHERE   
	   ((not @Type_Id is null and [Type_Id] = @Type_Id)
	   or (not @lstId is null and [Type_Id]  in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[RepositoryConfig_Sp_Save]
(@Id smallint, @Name varchar(255), @Code varchar(100), @Type_Id smallint, @Entity_Id int, @ViewPage varchar(255), @EditPage varchar(255), @Deleted bit)
AS
	IF (SELECT COUNT(*) from dbo.[RepositoryConfig] WHERE ( [Id] = @Id)  ) > 0
		BEGIN
			UPDATE dbo.[RepositoryConfig]
				SET  [Name] = @Name, [Code] = @Code, [Type_Id] = @Type_Id, [Entity_Id] = @Entity_Id, [ViewPage] = @ViewPage, [EditPage] = @EditPage, [Deleted] = @Deleted
				WHERE ( [Id] = @Id)
			SELECT @Id as Id
		END
	ELSE
		BEGIN
        
			INSERT INTO dbo.[RepositoryConfig]   
				  ([Name], [Code], [Type_Id], [Entity_Id], [ViewPage], [EditPage], [Deleted]) 
		   VALUES (@Name , @Code , @Type_Id , @Entity_Id , @ViewPage , @EditPage , @Deleted )
			SELECT SCOPE_IDENTITY() as Id
		END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[SpProcess_Sp_CopyRepositoryData]
(@FromRepository_Id int = 0,@ToRepository_Id int, @ProcessConfig_Id smallint = null)
AS
	SET NOCOUNT ON;
	SET IDENTITY_INSERT [SpProcess] ON

	insert into [SpProcess] ([Id], [Repository_Id],[ProcessConfig_Id], [Content])
	  Select [Id], @ToRepository_Id as [Repository_Id],[ProcessConfig_Id], [Content]
	  From [SpProcess]
	  Where Repository_Id = @FromRepository_Id 
	   AND  ProcessConfig_Id = @ProcessConfig_Id 

	SET IDENTITY_INSERT [SpProcess] OFF

GO
-------------------------------------
CREATE PROCEDURE [dbo].[SpProcess_Sp_Delete]
(@Id int = null, @lstId varchar(MAX) = null, @Repository_Id int)
AS
	SET NOCOUNT ON;
	DELETE FROM dbo.[SpProcess] 
	WHERE  
    
		((not @Id is null 
			and [Id] = @Id)
	   or (not @lstId is null
			and [Id] in(select * from dbo.SplitID(@lstId))))
		and Repository_Id = @Repository_Id

GO
-------------------------------------
CREATE PROCEDURE [dbo].[SpProcess_Sp_Get]  
(@Id int = null, @lstId varchar(MAX) = null, @Repository_Id int)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[SpProcess] 
	WHERE   
		((not @Id is null and [Id] = @Id)
	   or (not @lstId is null and [Id] in(select * from dbo.SplitID(@lstId))))
	   and Repository_Id = @Repository_Id

GO
-------------------------------------
CREATE PROCEDURE [dbo].[SpProcess_Sp_GetAll] (@Repository_Id int)
AS
	SET NOCOUNT ON;
	SELECT * 
	FROM dbo.[SpProcess]
	WHERE Repository_Id = @Repository_Id

GO
-------------------------------------
CREATE PROCEDURE [dbo].[SpProcess_Sp_GetByFilter] 
(@Repository_Id int = null, @Repository_Ids varchar(MAX) = null, @ProcessConfig_Id int = null, @ProcessConfig_Ids varchar(MAX) = null, @Content varchar(MAX) = null, @Page int = null, @PageSize int = null) 
AS
	SET NOCOUNT ON;
	SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
	INTO #RESUL
	FROM dbo.[SpProcess] AS PAG
	WHERE (@Repository_Id is null or [Repository_Id] = @Repository_Id)
		 and (@Repository_Ids is null or [Repository_Id] in (select * from dbo.SplitID(@Repository_Ids)))
		 and (@ProcessConfig_Id is null or [ProcessConfig_Id] = @ProcessConfig_Id)
		 and (@ProcessConfig_Ids is null or [ProcessConfig_Id] in (select * from dbo.SplitID(@ProcessConfig_Ids)))
		 and (@Content is null or [Content] like @Content)

	DECLARE @RowsTotal int
	SET @RowsTotal = @@ROWCOUNT

	SELECT *, @RowsTotal AS RowsTotal
	FROM #RESUL
	WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

	DROP TABLE #RESUL

GO
-------------------------------------
CREATE PROCEDURE [dbo].[SpProcess_Sp_GetByProcessConfig_Id]  
(@ProcessConfig_Id int = null, @lstId varchar(MAX) = null, @Repository_Id INT)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[SpProcess] 
	WHERE   
	   ((not @ProcessConfig_Id is null and [ProcessConfig_Id] = @ProcessConfig_Id)
	   or (not @lstId is null and [ProcessConfig_Id]  in(select * from dbo.SplitID(@lstId))))
	   and Repository_Id = @Repository_Id

GO
-------------------------------------
CREATE PROCEDURE [dbo].[SpProcess_Sp_GetByRepository_Id]  
(@Repository_Id int = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[SpProcess] 
	WHERE   
	   ((not @Repository_Id is null and [Repository_Id] = @Repository_Id)
	   or (not @lstId is null and [Repository_Id]  in(select * from dbo.SplitID(@lstId))))
 
GO
-------------------------------------
CREATE PROCEDURE [dbo].[SpProcess_Sp_Save]
(@Id int, @Repository_Id int, @ProcessConfig_Id int, @Content varchar(MAX))
AS
	IF (SELECT COUNT(*) from dbo.[SpProcess] WHERE ( [Id] = @Id AND  [Repository_Id] = @Repository_Id)  ) > 0
		BEGIN
			UPDATE dbo.[SpProcess]
				SET  [ProcessConfig_Id] = @ProcessConfig_Id, [Content] = @Content
				WHERE ( [Id] = @Id AND  [Repository_Id] = @Repository_Id)
			SELECT @Id as Id
		END
	ELSE
		BEGIN
		   INSERT INTO dbo.[SpProcess]   
				  ([Repository_Id], [ProcessConfig_Id], [Content]) 
		   VALUES (@Repository_Id , @ProcessConfig_Id , @Content )
			SELECT SCOPE_IDENTITY() as Id
		END

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Status_Sp_Delete]
(@Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[Status] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------
CREATE PROCEDURE [dbo].[Status_Sp_Get]
(@Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[Status] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------

CREATE PROCEDURE [dbo].[Status_Sp_GetAll] 
AS
SET NOCOUNT ON;
SELECT * FROM dbo.[Status]
GO
-------------------------------------

CREATE PROCEDURE [dbo].[Status_Sp_GetByFilter] 
(@Name varchar(100) = null, @Code varchar(50) = null, @Description varchar(500) = null, @StatusConfig_Id smallint = null, @Order smallint = null, @Icon varchar(255) = null, @Active bit = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;

SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[Status] AS PAG
WHERE (@Name is null or [Name] = @Name)
	 and (@Code is null or [Code] = @Code)
	 and (@Description is null or [Description] = @Description)
	 and (@StatusConfig_Id is null or [StatusConfig_Id] = @StatusConfig_Id)
	 and (@Order is null or [Order] = @Order)
	 and (@Icon is null or [Icon] = @Icon)
	 and (@Active is null or [Active] = @Active)

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL
GO
-------------------------------------

CREATE PROCEDURE [dbo].[Status_Sp_GetByStatusConfig_Id]
(@StatusConfig_Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[Status] 
WHERE ((not @StatusConfig_Id is null 
        and [StatusConfig_Id] = @StatusConfig_Id)
   or (not @lstId is null
        and [StatusConfig_Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------

CREATE PROCEDURE [dbo].[Status_Sp_Save]
(@Id smallint, @Name varchar(100), @Code varchar(50), @Description varchar(500), @StatusConfig_Id smallint, @Order smallint, @Icon varchar(255), @Active bit) 
as
IF (SELECT COUNT(*) from dbo.[Status]  WHERE  [Id] = @Id) > 0
    BEGIN
        UPDATE dbo.[Status]
             SET  [Name] = @Name, [Code] = @Code, [Description] = @Description, [StatusConfig_Id] = @StatusConfig_Id, [Order] = @Order, [Icon] = @Icon, [Active] = @Active
             WHERE  [Id] = @Id
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[Status]   
               ([Name], [Code], [Description], [StatusConfig_Id], [Order], [Icon], [Active]) 
        VALUES(@Name,@Code,@Description,@StatusConfig_Id,@Order,@Icon,@Active)
        SELECT SCOPE_IDENTITY() as Id
    END
GO
-------------------------------------

CREATE PROCEDURE [dbo].[StatusConfig_Sp_Delete]
(@Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[StatusConfig] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------

CREATE PROCEDURE [dbo].[StatusConfig_Sp_Get]
(@Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[StatusConfig] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------

CREATE PROCEDURE [dbo].[StatusConfig_Sp_GetAll] 
AS
SET NOCOUNT ON;
SELECT * FROM dbo.[StatusConfig]
GO
-------------------------------------

CREATE PROCEDURE [dbo].[StatusConfig_Sp_GetByFilter] 
(@Name varchar(100) = null, @Code varchar(50) = null, @Description varchar(500) = null, @Order int = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;

SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[StatusConfig] AS PAG
WHERE (@Name is null or [Name] = @Name)
	 and (@Code is null or [Code] = @Code)
	 and (@Description is null or [Description] = @Description)
	 and (@Order is null or [Order] = @Order)

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL
GO
-------------------------------------

CREATE PROCEDURE [dbo].[StatusConfig_Sp_Save]
(@Id smallint, @Name varchar(100), @Code varchar(50), @Description varchar(500), @Order int) 
as
IF (SELECT COUNT(*) from dbo.[StatusConfig]  WHERE  [Id] = @Id) > 0
    BEGIN
        UPDATE dbo.[StatusConfig]
             SET  [Name] = @Name, [Code] = @Code, [Description] = @Description, [Order] = @Order
             WHERE  [Id] = @Id
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[StatusConfig]   
               ([Name], [Code], [Description], [Order]) 
        VALUES(@Name,@Code,@Description,@Order)
        SELECT SCOPE_IDENTITY() as Id
    END
GO
-------------------------------------

CREATE PROCEDURE [dbo].[StatusWorkflow_Sp_Delete]
(@Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[StatusWorkflow] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------

CREATE PROCEDURE [dbo].[StatusWorkflow_Sp_Get]
(@Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[StatusWorkflow] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------

CREATE PROCEDURE [dbo].[StatusWorkflow_Sp_GetAll] 
AS
SET NOCOUNT ON;
SELECT * FROM dbo.[StatusWorkflow]
GO
-------------------------------------

CREATE PROCEDURE [dbo].[StatusWorkflow_Sp_GetByFilter] 
(@Start_Status_Id smallint = null, @To_Status_Id smallint = null, @All bit = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;

SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[StatusWorkflow] AS PAG
WHERE (@Start_Status_Id is null or [Start_Status_Id] = @Start_Status_Id)
	 and (@To_Status_Id is null or [To_Status_Id] = @To_Status_Id)
	 and (@All is null or [All] = @All)

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL
GO
-------------------------------------

CREATE PROCEDURE [dbo].[StatusWorkflow_Sp_GetByStart_Status_Id]
(@Start_Status_Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[StatusWorkflow] 
WHERE ((not @Start_Status_Id is null 
        and [Start_Status_Id] = @Start_Status_Id)
   or (not @lstId is null
        and [Start_Status_Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------

CREATE PROCEDURE [dbo].[StatusWorkflow_Sp_GetByTo_Status_Id]
(@To_Status_Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[StatusWorkflow] 
WHERE ((not @To_Status_Id is null 
        and [To_Status_Id] = @To_Status_Id)
   or (not @lstId is null
        and [To_Status_Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------

CREATE PROCEDURE [dbo].[StatusWorkflow_Sp_Save]
(@Id smallint, @Start_Status_Id smallint, @To_Status_Id smallint, @All bit) 
as
IF (SELECT COUNT(*) from dbo.[StatusWorkflow]  WHERE  [Id] = @Id) > 0
    BEGIN
        UPDATE dbo.[StatusWorkflow]
             SET  [Start_Status_Id] = @Start_Status_Id, [To_Status_Id] = @To_Status_Id, [All] = @All
             WHERE  [Id] = @Id
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[StatusWorkflow]   
               ([Start_Status_Id], [To_Status_Id], [All]) 
        VALUES(@Start_Status_Id,@To_Status_Id,@All)
        SELECT SCOPE_IDENTITY() as Id
    END
GO
-------------------------------------
CREATE PROCEDURE [dbo].[Struct_Sp_Delete]
(@Id smallint = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;
	DELETE FROM dbo.[Struct] 
	WHERE  
    
		((not @Id is null 
			and [Id] = @Id)
	   or (not @lstId is null
			and [Id] in(select * from dbo.SplitID(@lstId))))
    
GO
-------------------------------------
CREATE PROCEDURE [dbo].[Struct_Sp_Get]  
(@Id smallint = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[Struct] 
	WHERE   
		((not @Id is null and [Id] = @Id)
	   or (not @lstId is null and [Id] in(select * from dbo.SplitID(@lstId))))
   
GO
-------------------------------------
CREATE PROCEDURE [dbo].[Struct_Sp_GetAll] 
AS
SET NOCOUNT ON;
	SELECT * 
	FROM dbo.[Struct]

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Struct_Sp_GetByDataType_Id]  
(@DataType_Id smallint = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[Struct] 
	WHERE   
	   ((not @DataType_Id is null and [DataType_Id] = @DataType_Id)
	   or (not @lstId is null and [DataType_Id]  in(select * from dbo.SplitID(@lstId))))

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Struct_Sp_GetByEntity_Id]  
(@Entity_Id int = null, @lstId varchar(MAX) = null)
AS
	SET NOCOUNT ON;

	SELECT * FROM dbo.[Struct] 
	WHERE   
	   ((not @Entity_Id is null and [Entity_Id] = @Entity_Id)
	   or (not @lstId is null and [Entity_Id]  in(select * from dbo.SplitID(@lstId))))
   
GO
-------------------------------------
CREATE PROCEDURE [Struct_Sp_GetByFilter] 
(@Entity_Id int = null, @Entity_Ids varchar(MAX) = null, @Name varchar(255) = null, @Description varchar(255) = null, @DataType_Id smallint = null, @DataType_Ids varchar(MAX) = null, @Length int = null, @LengthDecimal int = null, @Nullable bit = null, @PK bit = null, @Identity bit = null, @RefEntity varchar(255) = null, @InView bit = null, @InTable bit = null, @InObject bit = null, @Active bit = null, @InImport bit = null, @ImportOrder int = null, @ImportLength int = null, @ImportFormat varchar(50) = null, @ImportName varbinary(255) = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;

SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[Struct] AS PAG
WHERE (@Entity_Id is null or [Entity_Id] = @Entity_Id)
	 and (@Entity_Ids is null or [Entity_Id] in (select * from dbo.SplitID(@Entity_Ids)))
	 and (@Name is null or [Name] = @Name)
	 and (@Description is null or [Description] = @Description)
	 and (@DataType_Id is null or [DataType_Id] = @DataType_Id)
	 and (@DataType_Ids is null or [DataType_Id] in (select * from dbo.SplitID(@DataType_Ids)))
	 and (@Length is null or [Length] = @Length)
	 and (@LengthDecimal is null or [LengthDecimal] = @LengthDecimal)
	 and (@Nullable is null or [Nullable] = @Nullable)
	 and (@PK is null or [PK] = @PK)
	 and (@Identity is null or [Identity] = @Identity)
	 and (@RefEntity is null or [RefEntity] = @RefEntity)
	 and (@InView is null or [InView] = @InView)
	 and (@InTable is null or [InTable] = @InTable)
	 and (@InObject is null or [InObject] = @InObject)
	 and (@Active is null or [Active] = @Active)
	 and (@InImport is null or [InImport] = @InImport)
	 and (@ImportOrder is null or [ImportOrder] = @ImportOrder)
	 and (@ImportLength is null or [ImportLength] = @ImportLength)
	 and (@ImportFormat is null or [ImportFormat] = @ImportFormat)
	 and (@ImportName is null or [ImportName] = @ImportName)

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL
GO
-------------------------------------
CREATE PROCEDURE [dbo].[Struct_sp_GetNewByName]
@Name nvarchar(255)
WITH 
EXECUTE AS CALLER
AS
	SELECT 0 as Id,
		 COLUMN_NAME as [Name],
		 DataType.id as DataType_Id,
		 isnull(Fc.CHARACTER_MAXIMUM_LENGTH, Fc.NUMERIC_PRECISION) as Length,
		 Fc.NUMERIC_SCALE as LengthDecimal, 
		 case Fc.IS_NULLABLE 
		 when 'NO' then convert(bit, 0)
		 else convert(bit, 1) end as [Nullable],
		 case COLUMN_NAME 
			  when 'Id' then convert(bit, 1)
			  else convert(bit, 0) end as PK, 
		 (CASE (SELECT is_identity
				FROM sys.identity_columns
				WHERE name = Fc.COLUMN_NAME
					  AND object_id = object_id ('[' + Fc.TABLE_NAME + ']'))
		  WHEN 1 THEN convert(bit, 1)
		  ELSE convert(bit, 0) END) AS [Identity], 
		 '' as RefEntity, 
		 convert(bit, 0) as InView,
		 convert(bit, 0) as InTable,
		 convert(bit, 0) as InObject
     
	into #tStru
	FROM INFORMATION_SCHEMA.TABLES as ISCHT 
		  inner join INFORMATION_SCHEMA.COLUMNS as fc
				on ISCHT.table_name = fc.table_name
		 LEFT JOIN DataType
		 ON Fc.DATA_TYPE = dbo.DataType.SQL
	WHERE Fc.table_name = @Name


	update #tStru
	set PK = 1
	where [Name] in (
					  select c.name
					  from sys.indexes i,
						sys.all_columns c 
					  Where is_primary_key =1 
						  and c.[object_id] = i.[object_id]
						  and i.[object_id] = (select object_id(@Name))
						  and (c.name = index_col (@Name, i.index_id,  1) or
							  c.name = index_col (@Name, i.index_id,  2) or
							  c.name = index_col (@Name, i.index_id,  3) or
							  c.name = index_col (@Name, i.index_id,  4) or
							  c.name = index_col (@Name, i.index_id,  5) or
							  c.name = index_col (@Name, i.index_id,  6) or
							  c.name = index_col (@Name, i.index_id,  7) or
							  c.name = index_col (@Name, i.index_id,  8) or
							  c.name = index_col (@Name, i.index_id,  9) or
							  c.name = index_col (@Name, i.index_id, 10) or
							  c.name = index_col (@Name, i.index_id, 11) or
							  c.name = index_col (@Name, i.index_id, 12) or
							  c.name = index_col (@Name, i.index_id, 13) or
							  c.name = index_col (@Name, i.index_id, 14) or
							  c.name = index_col (@Name, i.index_id, 15) or
							  c.name = index_col (@Name, i.index_id, 16)))
                          
	select * from #tStru

	drop table #tStru

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Struct_sp_GetNewStruct_Id]
WITH 
EXECUTE AS CALLER
AS
	select (isnull(max(Struct_Id),0) + 1)
	from Entity_Struct

GO
-------------------------------------
CREATE PROCEDURE [dbo].[Struct_sp_GetRelationByName]
@Name varchar(255)
WITH 
EXECUTE AS CALLER
AS
	SELECT distinct fc.TABLE_NAME
	FROM INFORMATION_SCHEMA.TABLES as ISCHT 
		  inner join INFORMATION_SCHEMA.COLUMNS as fc
				on ISCHT.table_name = fc.table_name
		 LEFT JOIN DataType
		 ON Fc.DATA_TYPE = dbo.DataType.SQL
	WHERE Fc.COLUMN_NAME = @Name + '_Id'
		  or Fc.COLUMN_NAME like '%_' + @Name + '_Id'

GO
------------------------------------- 
CREATE PROCEDURE [Struct_Sp_Save]
(@Id smallint, @Entity_Id int, @Name varchar(255), @Description varchar(255), @DataType_Id smallint, @Length int, @LengthDecimal int, @Nullable bit, @PK bit, @Identity bit, @RefEntity varchar(255), @InView bit, @InTable bit, @InObject bit, @Active bit, @InImport bit, @ImportOrder int, @ImportLength int, @ImportFormat varchar(50), @ImportName varbinary(255))
as
IF (SELECT COUNT(*) from dbo.[Struct] WHERE ( [Id] = @Id)  ) > 0
    BEGIN
        UPDATE dbo.[Struct]
            SET  [Entity_Id] = @Entity_Id, [Name] = @Name, [Description] = @Description, [DataType_Id] = @DataType_Id, [Length] = @Length, [LengthDecimal] = @LengthDecimal, [Nullable] = @Nullable, [PK] = @PK, [Identity] = @Identity, [RefEntity] = @RefEntity, [InView] = @InView, [InTable] = @InTable, [InObject] = @InObject, [Active] = @Active, [InImport] = @InImport, [ImportOrder] = @ImportOrder, [ImportLength] = @ImportLength, [ImportFormat] = @ImportFormat, [ImportName] = @ImportName
            WHERE ( [Id] = @Id)
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[Struct]   
              ([Entity_Id], [Name], [Description], [DataType_Id], [Length], [LengthDecimal], [Nullable], [PK], [Identity], [RefEntity], [InView], [InTable], [InObject], [Active], [InImport], [ImportOrder], [ImportLength], [ImportFormat], [ImportName]) 
       VALUES (@Entity_Id , @Name , @Description , @DataType_Id , @Length , @LengthDecimal , @Nullable , @PK , @Identity , @RefEntity , @InView , @InTable , @InObject , @Active , @InImport , @ImportOrder , @ImportLength , @ImportFormat , @ImportName )
        SELECT SCOPE_IDENTITY() as Id
    END
GO


-------------------------------------

CREATE PROCEDURE [dbo].[Type_Sp_Delete]
(@Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[Type] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------

CREATE PROCEDURE [dbo].[Type_Sp_Get]
@Id smallint = null, @lstId varchar(MAX) = null
WITH 
EXECUTE AS CALLER
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[Type] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------

CREATE PROCEDURE [dbo].[Type_Sp_GetAll]
WITH 
EXECUTE AS CALLER
AS
SET NOCOUNT ON;
SELECT * FROM dbo.[Type]
GO
-------------------------------------

CREATE PROCEDURE [dbo].[Type_Sp_GetByFilter]
@Name varchar(100) = null, @Code varchar(50) = null, @TypeConfig_Id smallint = null, @Order smallint = null, @Description varchar(500) = null, @Icon binary(50) = null, @IsDefault bit = null, @Page int = null, @PageSize int = null
WITH 
EXECUTE AS CALLER
AS
SET NOCOUNT ON;

SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[Type] AS PAG
WHERE (@Name is null or [Name] = @Name)
	 and (@Code is null or [Code] = @Code)
	 and (@TypeConfig_Id is null or [TypeConfig_Id] = @TypeConfig_Id)
	 and (@Order is null or [Order] = @Order)
	 and (@Description is null or [Description] = @Description)
	 and (@Icon is null or [Icon] = @Icon)
	 and (@IsDefault is null or [IsDefault] = @IsDefault)

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL
GO
-------------------------------------

CREATE PROCEDURE [dbo].[Type_Sp_GetByTypeConfig_Id]
@TypeConfig_Id smallint = null, @lstId varchar(MAX) = null
WITH 
EXECUTE AS CALLER
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[Type] 
WHERE ((not @TypeConfig_Id is null 
        and [TypeConfig_Id] = @TypeConfig_Id)
   or (not @lstId is null
        and [TypeConfig_Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------

CREATE PROCEDURE [dbo].[Type_Sp_Save]
(@Id smallint, @Name varchar(100), @Code varchar(50), @TypeConfig_Id smallint, @Order smallint, @Description varchar(500), @Icon binary(50), @IsDefault bit) 
as
IF (SELECT COUNT(*) from dbo.[Type]  WHERE  [Id] = @Id) > 0
    BEGIN
        UPDATE dbo.[Type]
             SET  [Name] = @Name, [Code] = @Code, [TypeConfig_Id] = @TypeConfig_Id, [Order] = @Order, [Description] = @Description, [Icon] = @Icon, [IsDefault] = @IsDefault
             WHERE  [Id] = @Id
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[Type]   
               ([Name], [Code], [TypeConfig_Id], [Order], [Description], [Icon], [IsDefault]) 
        VALUES(@Name,@Code,@TypeConfig_Id,@Order,@Description,@Icon,@IsDefault)
        SELECT SCOPE_IDENTITY() as Id
    END
GO
-------------------------------------

CREATE PROCEDURE [dbo].[TypeConfig_Sp_Delete]
(@Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[TypeConfig] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------

CREATE PROCEDURE [dbo].[TypeConfig_Sp_Get]
(@Id smallint = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[TypeConfig] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------

CREATE PROCEDURE [dbo].[TypeConfig_Sp_GetAll] 
AS
SET NOCOUNT ON;
SELECT * FROM dbo.[TypeConfig]
GO
-------------------------------------

CREATE PROCEDURE [dbo].[TypeConfig_Sp_GetByCode]
@Code varchar(50)
WITH 
EXECUTE AS CALLER
AS
select *
from TypeConfig
where Code=@Code
GO
-------------------------------------

CREATE PROCEDURE [dbo].[TypeConfig_Sp_GetByFilter] 
(@Name varchar(100) = null, @Code varchar(50) = null, @Description varchar(500) = null, @Order int = null, @HasIcon bit = null, @HasUniqueCode bit = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;

SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[TypeConfig] AS PAG
WHERE (@Name is null or [Name] = @Name)
	 and (@Code is null or [Code] = @Code)
	 and (@Description is null or [Description] = @Description)
	 and (@Order is null or [Order] = @Order)
	 and (@HasIcon is null or [HasIcon] = @HasIcon)
	 and (@HasUniqueCode is null or [HasUniqueCode] = @HasUniqueCode)

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL
GO
-------------------------------------

CREATE PROCEDURE [dbo].[TypeConfig_Sp_Save]
(@Id smallint, @Name varchar(100), @Code varchar(50), @Description varchar(500), @Order int, @HasIcon bit, @HasUniqueCode bit) 
as
IF (SELECT COUNT(*) from dbo.[TypeConfig]  WHERE  [Id] = @Id) > 0
    BEGIN
        UPDATE dbo.[TypeConfig]
             SET  [Name] = @Name, [Code] = @Code, [Description] = @Description, [Order] = @Order, [HasIcon] = @HasIcon, [HasUniqueCode] = @HasUniqueCode
             WHERE  [Id] = @Id
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[TypeConfig]   
               ([Name], [Code], [Description], [Order], [HasIcon], [HasUniqueCode]) 
        VALUES(@Name,@Code,@Description,@Order,@HasIcon,@HasUniqueCode)
        SELECT SCOPE_IDENTITY() as Id
    END
GO
-------------------------------------

CREATE PROCEDURE [User_Sp_Delete]
(@Company_Id int = null,  
@Id int = null, @lstId varchar(MAX) = null

)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[User] 
WHERE (@Company_Id is null or Company_Id = @Company_Id or Company_Id = 0)  and  
    
    ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------

CREATE PROCEDURE [User_Sp_Get]  
(@Company_Id int = null,  @Id int = null, @lstId varchar(MAX) = null 
)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[User] 
WHERE  (@Company_Id is null or Company_Id = @Company_Id or Company_Id = 0) and  
    ((not @Id is null and [Id] = @Id)
   or (not @lstId is null and [Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------

CREATE PROCEDURE [dbo].[User_Sp_GetAll] (@Company_Id INT = NULL)
AS
SET NOCOUNT ON;
SELECT * 
FROM dbo.[User]
WHERE (@Company_Id IS NULL OR Company_Id = @Company_Id OR Company_Id = 0) 
GO

-------------------------------------

CREATE procedure [dbo].[User_Sp_GetByEmail]
(
 @Email varchar(100)
)
as
select * from [user]
where Email =  @Email

GO
-------------------------------------

CREATE PROCEDURE [dbo].[User_Sp_GetByFilter] 
(@Name varchar(255) = null, @FullName varchar(255) = null, @LastLogin datetime = null, @Email varchar(255) = null, @SessionOpen smallint = null, @State_Type_Id bigint = null, @Password varchar(MAX) = null, @SecretQuestion_Type_Id bigint = null, @SecretAnswer varchar(MAX) = null, @ActivationKey varchar(100) = null, @Language_Type_Id bigint = null, @FailLoginCount smallint = null, @Company_Id int = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;

SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[User] AS PAG
WHERE (@Name is null or [Name] = @Name)
	 and (@FullName is null or [FullName] = @FullName)
	 and (@LastLogin is null or [LastLogin] = @LastLogin)
	 and (@Email is null or [Email] = @Email)
	 and (@SessionOpen is null or [SessionOpen] = @SessionOpen)
	 and (@State_Type_Id is null or [State_Type_Id] = @State_Type_Id)
	 and (@Password is null or [Password] = @Password)
	 and (@SecretQuestion_Type_Id is null or [SecretQuestion_Type_Id] = @SecretQuestion_Type_Id)
	 and (@SecretAnswer is null or [SecretAnswer] = @SecretAnswer)
	 and (@ActivationKey is null or [ActivationKey] = @ActivationKey)
	 and (@Language_Type_Id is null or [Language_Type_Id] = @Language_Type_Id)
	 and (@FailLoginCount is null or [FailLoginCount] = @FailLoginCount)
	 and (@Company_Id is null or [Company_Id] = @Company_Id)

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL
GO
-------------------------------------

create PROCEDURE [dbo].[User_sp_GetByKey]
@Key varchar(100)
WITH 
EXECUTE AS CALLER
AS
select *
from [User]
Where [ActivationKey] = @Key
GO
-------------------------------------

CREATE PROCEDURE [User_Sp_GetByLanguage_Type_Id]  
(@Company_Id int = null,  @Language_Type_Id bigint = null, @lstId varchar(MAX) = null
)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[User] 
WHERE  (@Company_Id is null or Company_Id = @Company_Id or Company_Id = 0) and  
   ((not @Language_Type_Id is null and [Language_Type_Id] = @Language_Type_Id)
   or (not @lstId is null and [Language_Type_Id]  in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------

CREATE PROCEDURE [User_Sp_GetBySecretQuestion_Type_Id]  
(@Company_Id int = null,  @SecretQuestion_Type_Id bigint = null, @lstId varchar(MAX) = null
)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[User] 
WHERE  (@Company_Id is null or Company_Id = @Company_Id or Company_Id = 0) and  
   ((not @SecretQuestion_Type_Id is null and [SecretQuestion_Type_Id] = @SecretQuestion_Type_Id)
   or (not @lstId is null and [SecretQuestion_Type_Id]  in(select * from dbo.SplitID(@lstId))))
GO


-------------------------------------

CREATE PROCEDURE [User_Sp_GetByState_Type_Id]  
(@Company_Id int = null,  @State_Type_Id bigint = null, @lstId varchar(MAX) = null
)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[User] 
WHERE  (@Company_Id is null or Company_Id = @Company_Id or Company_Id = 0) and  
   ((not @State_Type_Id is null and [State_Type_Id] = @State_Type_Id)
   or (not @lstId is null and [State_Type_Id]  in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------

CREATE PROCEDURE [dbo].[User_Sp_Save]
(@Id int, @Name varchar(255), @FullName varchar(255), @LastLogin datetime, @Email varchar(255), @SessionOpen smallint, @State_Type_Id bigint, @Password varchar(MAX), @SecretQuestion_Type_Id bigint, @SecretAnswer varchar(MAX), @ActivationKey varchar(100), @Language_Type_Id bigint, @FailLoginCount smallint, @Company_Id int) 
as
IF (SELECT COUNT(*) from dbo.[User]  WHERE  [Id] = @Id) > 0
    BEGIN
        UPDATE dbo.[User]
             SET  [Name] = @Name, [FullName] = @FullName, [LastLogin] = @LastLogin, [Email] = @Email, [SessionOpen] = @SessionOpen, [State_Type_Id] = @State_Type_Id, [Password] = @Password, [SecretQuestion_Type_Id] = @SecretQuestion_Type_Id, [SecretAnswer] = @SecretAnswer, [ActivationKey] = @ActivationKey, [Language_Type_Id] = @Language_Type_Id, [FailLoginCount] = @FailLoginCount, [Company_Id] = @Company_Id
             WHERE  [Id] = @Id
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[User]   
               ([Name], [FullName], [LastLogin], [Email], [SessionOpen], [State_Type_Id], [Password], [SecretQuestion_Type_Id], [SecretAnswer], [ActivationKey], [Language_Type_Id], [FailLoginCount], [Company_Id]) 
        VALUES(@Name,@FullName,@LastLogin,@Email,@SessionOpen,@State_Type_Id,@Password,@SecretQuestion_Type_Id,@SecretAnswer,@ActivationKey,@Language_Type_Id,@FailLoginCount,@Company_Id)
        SELECT SCOPE_IDENTITY() as Id
    END
GO
-------------------------------------

CREATE PROCEDURE [dbo].[User_Sp_GetByName]
@Name varchar(255)
WITH 
EXECUTE AS CALLER
AS
SELECT *
	FROM [User]
	WHERE
		LOWER([Name]) = LOWER(@Name)
		OR LOWER(Email) = LOWER(@Name)
GO
-------------------------------------

CREATE PROCEDURE [dbo].[UserProfile_Sp_Delete]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;
DELETE FROM dbo.[UserProfile] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------

CREATE PROCEDURE [dbo].[UserProfile_Sp_Get]
(@Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[UserProfile] 
WHERE ((not @Id is null 
        and [Id] = @Id)
   or (not @lstId is null
        and [Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------

CREATE PROCEDURE [dbo].[UserProfile_Sp_GetAll] 
AS
SET NOCOUNT ON;
SELECT * FROM dbo.[UserProfile]
GO
-------------------------------------

CREATE PROCEDURE [dbo].[UserProfile_Sp_GetByFilter] 
(@User_Id int = null, @Profile_Id int = null, @Page int = null, @PageSize int = null) 
AS
SET NOCOUNT ON;

SELECT PAG.*, ROW_NUMBER() OVER (ORDER BY PAG.[Id] ASC) AS RowNumber 
INTO #RESUL
FROM dbo.[UserProfile] AS PAG
WHERE (@User_Id is null or [User_Id] = @User_Id)
	 and (@Profile_Id is null or [Profile_Id] = @Profile_Id)

DECLARE @RowsTotal int
SET @RowsTotal = @@ROWCOUNT

SELECT *, @RowsTotal AS RowsTotal
FROM #RESUL
WHERE @Page is null or (RowNumber > (@Page * @PageSize) - @PageSize and RowNumber <= (@Page * @PageSize))

DROP TABLE #RESUL
GO
-------------------------------------

CREATE PROCEDURE [dbo].[UserProfile_Sp_GetByProfile_Id]
(@Profile_Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[UserProfile] 
WHERE ((not @Profile_Id is null 
        and [Profile_Id] = @Profile_Id)
   or (not @lstId is null
        and [Profile_Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------

CREATE PROCEDURE [dbo].[UserProfile_Sp_GetByUser_Id]
(@User_Id int = null, @lstId varchar(MAX) = null)
AS
SET NOCOUNT ON;

SELECT * FROM dbo.[UserProfile] 
WHERE ((not @User_Id is null 
        and [User_Id] = @User_Id)
   or (not @lstId is null
        and [User_Id] in(select * from dbo.SplitID(@lstId))))
GO
-------------------------------------

CREATE PROCEDURE [dbo].[UserProfile_Sp_Save]
(@Id int, @User_Id int, @Profile_Id int) 
as
IF (SELECT COUNT(*) from dbo.[UserProfile]  WHERE  [Id] = @Id) > 0
    BEGIN
        UPDATE dbo.[UserProfile]
             SET  [User_Id] = @User_Id, [Profile_Id] = @Profile_Id
             WHERE  [Id] = @Id
        SELECT @Id as Id
    END
ELSE
    BEGIN
        
        INSERT INTO dbo.[UserProfile]   
               ([User_Id], [Profile_Id]) 
        VALUES(@User_Id,@Profile_Id)
        SELECT SCOPE_IDENTITY() as Id
    END
GO
-------------------------------------