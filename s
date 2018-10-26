/*needed to change account number for multiple accounts. issue was the key identifier on the Detail did not allow a simple update
i needed to get a unique detail for each entry. this uses the row number to set the detail number

first pulling out the data i need to change into one table   */
select *
into #zbb
from [dbo].[div_60_zbb_detail]
where year = 2019 and account in ()

/*creating second temp table to get row number, also only pulled data i would need for the join. 
need to use second table to get row numbers, if first query is used to get row number it will only use row number from 
the source table. which would cause duplicates and not be unique
*/
select level, euid,detail, ROW_NUMBER() OVER (ORDER BY detail) AS RowNbr
into #zbb2
from #zbb

-- joins the second temp table and the main table to do the update. sets the detail to the row number in the #zbb2 table
update [div_60_zbb_detail] 
set detail = t.rownbr
,account = ''
from [div_60_zbb_detail] a join #zbb2 t  on a.euid = t.euid and a.[level] = t.[level]
where a.year = 2019 and a.account in ()


/*
drop table #zbb2
drop table #zbb
*/

