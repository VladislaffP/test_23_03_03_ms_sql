CREATE PROCEDURE dbo.countries_update

AS
BEGIN
	SET NOCOUNT ON;

insert into dbo.Countries
(
	country_name
)
select distinct 
	country
from dbo.stage_data_load as src
where not exists (select top 1 1 from dbo.Countries where country_name = src.country)

insert into dbo.languages
(
	language_name
)
select distinct 
	language
from dbo.stage_data_load as src
where not exists (select top 1 1 from dbo.languages where [language] = src.[language])

insert into dbo.fact_table
(
	id_country
,	id_language
)
select distinct
	c.country_id
,	l.language_id
from stage_data_load as src
	inner join dbo.Countries as c on c.country_name = src.country
	inner join dbo.languages as l on l.language_name = src.[language]
where not exists (	select top 1 1 
					from dbo.fact_table
					where	id_country = c.country_id
						and id_language = l.language_id
				)

END
GO
