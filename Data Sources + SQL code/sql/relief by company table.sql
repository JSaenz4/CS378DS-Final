drop table reliefbycompany;
create table reliefbycompany (
  company                       VARCHAR2(50) NOT NULL,
  relief_complaints             Integer,
  total_complaints              Integer,
  percent_complaints_relief    Number
);

insert into reliefbycompany select * from(
select total.company, relief_complaints, total_complaints, 
(relief_complaints/total_complaints) from 
(select nvl(company,'Total') as company, count(complaint_id) total_complaints 
  from complaindata 
  where ( company in (
      'Wells Fargo',
      'JPMorgan Chase',
      'Citibank',
      'Bank of America',
      'Ocwen',
      'Nationstar Mortgage'
    ) 
    and
    product in ('Mortgage')
  ) group by rollup(company)) total 

left join


(select nvl(company,'Total') as company, count(complaint_id) relief_complaints from complaindata 
  where ( company in (
      'Wells Fargo',
      'JPMorgan Chase',
      'Citibank',
      'Bank of America',
      'Ocwen',
      'Nationstar Mortgage'
    ) 
    and
    product in ('Mortgage')
    and company_response in (
      'Closed with monetary relief', 
      'Closed with non-monetary relief')
    ) group by rollup(company)) relief
on relief.company = total.company);